//
//  EditProfileButtonAndChangeAvatar.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 6/18/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import UIKit
import Foundation
import JGProgressHUD
import Alamofire

extension ProfileViewForUsersInSearchController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func editProfile() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            
            dismiss(animated: true) {
                self.uploadUserProfileImage(image: selectedImage)
            }
        
        } else {
                dismiss(animated: true)
        }
        
     }
    
     fileprivate func uploadUserProfileImage(image: UIImage) {
        
        let header : HTTPHeaders
            header = ["Content-type": "multipart/form-data", "Content-Disposition" : "form-data"]
        
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Updating avatar..."
            hud.show(in: view)
            
            let url = "\(Service.shared.baseUrl)/profile"
        
       
                    
            AF.upload(multipartFormData: { (formData) in
                
                guard let user = self.user else { return }
                formData.append(Data(user.fullName.utf8), withName: "fullName")

                let bioData = Data((user.bio ?? "").utf8)
                formData.append(bioData, withName: "bio")
                
                guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
                print("This is the image data", imageData)
                formData.append(imageData, withName: "imageUrl", fileName: "DoesntMatterSoMuch", mimeType: "image/jpg")
                
            }, to: url, method: .post, headers: header ).responseJSON(completionHandler: { (res) in
                
                print("This is the result", res.result)
                
                switch res.result {
                     case .failure(let err):
                        self.fetchUserProfile()
                        hud.dismiss()
                        if let code = err.responseCode{
                             print("unable to upload the image and create a post ",code)
                             break
                         }
  
 
                     case .success(let sucess):
                         self.fetchUserProfile()
                         hud.dismiss(afterDelay: 1.0)
                         print("Sucessfully uploaded the image and post", sucess)
                     }
            })
                
                 
            }
    }


