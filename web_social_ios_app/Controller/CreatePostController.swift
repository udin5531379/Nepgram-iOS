//
//  CreatePostController.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 5/8/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import Foundation
import LBTATools
import Alamofire
import JGProgressHUD


class  CreatePostContoller: UIViewController, UITextViewDelegate{
    
    // from here to "till here" the above method os done to get the image from the home controller and display it in createPostController.
    
    let selectedImage : UIImage
    
    let imageView = UIImageView(image: nil, contentMode: .scaleAspectFit)
    
    init(selectedImage: UIImage) {
        self.selectedImage = selectedImage
        imageView.image = selectedImage
        super.init(nibName: nil, bundle: nil)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //till here
    
    var homeController : HomeController?

    
     let postButton = UIButton(title: "POST", titleColor: .white, font: .systemFont(ofSize: 15), backgroundColor: UIColor(red: 0/255, green: 74/255, blue: 173/255, alpha: 1), target: self, action: #selector(postCreation))
    
    let placeHolder = UILabel(text: "Enter your caption here", font: .systemFont(ofSize: 20), textColor: .lightGray)
    
    let postBodyTextView = UITextView(text: nil, font: .systemFont(ofSize: 20), textColor: .black)
    
    
    
    
    @objc func postCreation() {
            
        let hud = JGProgressHUD()
                 
                print("uploading posts and images and sending it to the server...")
    
        
                    let url = "http://localhost:1337/post"
        
                    let headers: HTTPHeaders =
                    ["Content-type": "multipart/form-data","Accept": "application/json"]
        
                    AF.upload(multipartFormData: { (formData) in
        
                        print("text being uploaded")
                        guard let text = String(self.postBodyTextView.text).data(using: String.Encoding.utf8) else { return }
                        formData.append(Data(text), withName: "postBody")
        
        
                        print("image being uploaded")
                        guard let imageData = self.selectedImage.jpegData(compressionQuality: 0.5) else { return }
        
                        formData.append(imageData, withName: "imagefile", fileName: "We dont use this", mimeType: "image/jpg")
        
                    }, to: url, method: .post, headers: headers).uploadProgress(closure: { (progress) in
                        
                        //to show the progress of the upload
                        hud.detailTextLabel.text = "0% Complete"
                        hud.show(in: self.view, animated: true)
                        hud.indicatorView = JGProgressHUDPieIndicatorView()
                        incrementHUD(hud, progress: Int(progress.fractionCompleted))
//                        print("Printing the upload progress: \(progress.fractionCompleted)")
        
                    }).responseJSON { (res) in
        
                        print("After finish uploading... this statement is printed")
                        
        
                        switch res.result {
        
                            case .failure(let err) :
                                if let code = err.responseCode, code >= 300 {
                                    print("unable to upload the image and create a post ",code)
                                    return
                                }
         
        
                            case .success(let sucess):
                                
                                self.dismiss(animated: true) {
                                    //self.homeController?.fetchData()
                                    self.refreshHomeController()
                                    
                                } 
                                //yo chahe page reload garna. homecontroller ko instance banayo ani tya ko function acess garyo.
                                
                                hud.dismiss(afterDelay: 1.0)
                                print("Sucessfully uploaded the image and post", sucess)
                               
                                
        
                            }
        
        
                        }
        
    }
    
    fileprivate func refreshHomeController() {
        
        guard let application = (UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController) else { return }
        
        application.refresEverythingInTheUI()
        
    }
 

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //yesley chahe type gareyko track garna milcha delegate self halyp bhaney
        postBodyTextView.delegate = self
        
        view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        postBodyTextView.backgroundColor = .clear
        postButton.layer.cornerRadius = 5
     
        
        view.addSubview(imageView)
        view.addSubview(postButton)
        view.addSubview(postBodyTextView)
        view.addSubview(placeHolder)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postBodyTextView.translatesAutoresizingMaskIntoConstraints = false
        placeHolder.translatesAutoresizingMaskIntoConstraints = false
        
        constraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        

    }
    
//this two function are used to move the view up and down when the keyboard is triggred.
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 200
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        //alpha ko value 1 bhayo bhaney chahe placeholder daykhicha, 0 bhayo bhaney chahe daykhdaina
        placeHolder.alpha = textView.text.isEmpty ? 1 : 0
         
    }
    
    func constraints() {
       
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        
        postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        postButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        
        
        postBodyTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postBodyTextView.topAnchor.constraint(equalTo: postButton.bottomAnchor, constant: 10).isActive = true
        postBodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        postBodyTextView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        
        
        placeHolder.leadingAnchor.constraint(equalTo: postBodyTextView.leadingAnchor, constant: 10).isActive = true
        placeHolder.topAnchor.constraint(equalTo: postBodyTextView.topAnchor, constant: 10).isActive = true
        placeHolder.heightAnchor.constraint(equalToConstant: 20).isActive = true
        placeHolder.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
    
    
    }
    
}
