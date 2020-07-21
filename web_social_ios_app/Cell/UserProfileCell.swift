//
//  UserProfileCell.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 6/3/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import Foundation
import LBTATools

//this UserProfileCell is brong presented in both HomeContoller and ProfileViewController
class UserProfileCell: LBTAListCell<Post> {
    let userName = UILabel(text: "Name", font: .boldSystemFont(ofSize: 17))
    let postImage = UIImageView(image: nil, contentMode: .scaleAspectFit)
    let postTextLabel = UILabel(text: "postText", font: .systemFont(ofSize: 15))
    let optionsButton = UIButton(image: UIImage(imageLiteralResourceName: "threeDots"), tintColor: .black, target: self, action: #selector(optionsDelButton))
    let profileImageView = CircularImageView(width: 40, image: #imageLiteral(resourceName: "userprofile"))
    let likeButton = UIButton(image: #imageLiteral(resourceName: "like"), tintColor: .black, target: self, action: #selector(handleLike))
    let commentButton = UIButton(image: #imageLiteral(resourceName: "comment"), tintColor: .black, target: self, action: #selector(handleComment))
    let postedTimeStamp = UILabel(text: "", font: .systemFont(ofSize: 15), textColor: .lightGray)
    
    @objc func optionsDelButton() {
        print("Option button pressed")
    }
    
    @objc func handleLike(){
        print("Like Button Pressed")
    }
    
    @objc func handleComment(){
        print("Comment Button Pressed")
    }
    
    override var item: Post! {
           didSet{
               //First Function to execute in this class
            
                userName.text = item.user.fullName
                postImage.sd_setImage(with: URL(string: item.imageUrl))
                postTextLabel.text = item.text
                profileImageView.sd_setImage(with: URL(string: item.user.profileImageUrl ?? "0"))
                postedTimeStamp.text = "Posted \(item.fromNow)"
               
           }
       }
    
    
    override func setupViews() {
        //this is to render out each cell in the home and profile controller
        super.setupViews()
        
        optionsButton.imageView?.contentMode = .scaleAspectFit
        profileImageView.layer.borderWidth = 1
        
        
        postImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        postImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        
        
        stack(hstack(stack(profileImageView).padRight(10).padBottom(16).padTop(16),
                     hstack(stack(userName, stack(postedTimeStamp.withHeight(10).withWidth(200)).padTop(-50).padBottom(2)).padTop(-20), UIView(), optionsButton.withWidth(25).withHeight(25))).padLeft(10).padRight(10).padTop(10).padBottom(5),
              postImage,
              hstack(likeButton.withWidth(30).withHeight(30),
                     commentButton.withWidth(30).withHeight(30),
                     UIView(),
                     spacing: 20).padLeft(10).padRight(10).padTop(10),
              stack(postTextLabel).padLeft(16).padRight(16).padBottom(16).padTop(16))
        
    }
}
