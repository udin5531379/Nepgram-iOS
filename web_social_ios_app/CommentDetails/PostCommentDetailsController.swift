//
//  PostCommentDetailsController.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 7/22/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import Foundation
import LBTATools
import Alamofire
import JGProgressHUD


class PostCommentDetailsController: LBTAListController<CommmentCell, Comment> { //Cell and then the actual Comment
    
    var postId : String
    
    init(postId: String) {
        self.postId = postId
        super.init()
    }
    
    var post: Post?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCommentsData()
        navigationItem.title = "Comments"
   }
    
    
    
    let hud = JGProgressHUD()
    
    
    
    func fetchCommentsData() {
        //for progress hud
        hud.vibrancyEnabled = false
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.5)
        hud.textLabel.text = "Loading..."
        hud.show(in: self.view)
        
        let URL = "\(Service.shared.baseUrl)/post/\(postId)"
        
        AF.request(URL)
            .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                if let err = dataResponse.error {
                    self.hud.textLabel.text = "Failed to fetch the data"
                    print("failed to retrive the data, ", err)
                    self.hud.dismiss()
                    return
                }
                
                guard let data = dataResponse.data else { return }
                do{
                    let posts = try JSONDecoder().decode(Post.self, from: data)
                    print(posts)
                    self.items = posts.comments ?? []
                        if self.items.count == 0 {
                            print("no comments ")
                            let alert = UIAlertController(title: "Sorry, no comments on this post.", message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Go back", style: .default, handler: { (action) in
                                self.navigationController?.popToRootViewController(animated: true)
                            }))
                            self.present(alert, animated: true)
                        }
                    self.collectionView.reloadData()
                    self.hud.dismiss()
                } catch {
                    print(error)
                }
                
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
}

extension PostCommentDetailsController: UICollectionViewDelegateFlowLayout {
    
    //this is height for each of the cell in the HomeController
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let width = view.frame.width
         let height = estimatedCellHeight(for: indexPath, cellWidth: width)
         return .init(width: width, height: height)
     }
}

//if self.i == nil {
//
//
//                   }
