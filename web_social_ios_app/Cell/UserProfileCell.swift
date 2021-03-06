//
//  UserProfileCell.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 6/3/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import Foundation
import LBTATools

protocol PostDelegate {
    func handleComments(post: Post)
    func handleLike(post: Post)
}

//this UserProfileCell is brong presented in both HomeContoller and ProfileViewController
class UserProfileCell: LBTAListCell<Post> {
    let userName = UILabel(text: "Name", font: .boldSystemFont(ofSize: 17))
    let postImage = UIImageView(image: nil, contentMode: .scaleAspectFit)
    let postTextLabel = UILabel(text: "postText", font: .systemFont(ofSize: 15))
    let optionsButton = UIImageView(image: #imageLiteral(resourceName: "threeDots"), contentMode: .scaleAspectFit)
    let profileImageView = CircularImageView(width: 40, image: #imageLiteral(resourceName: "userprofile"))
    lazy var  likeButton = UIButton(image: #imageLiteral(resourceName: "like"),tintColor: .black, target: self, action: #selector(handleLike))
    let commentButton = UIImageView(image: #imageLiteral(resourceName: "comment"), contentMode: .scaleAspectFit)
    let postedTimeStamp = UILabel(text: "", font: .systemFont(ofSize: 15), textColor: .lightGray)
    let likeCountLabel = UILabel(text: "0 like", font: .boldSystemFont(ofSize: 16), textColor: .black)
    
    @objc func optionsDelButton() {
        print("Option button pressed")
    }
    
    @objc func handleLike() {
        print("Like button Pressed")
        //yo function chahe duita thau ma implement gareyko cha homeController ra ProfileViewForUserInSearchController
        //HomeController ma chuttai action huncha ra ProfileViewController ma chuttai action huncha
        (parentController as? PostDelegate)?.handleLike(post: item)
    }
    
    @objc func handleComment() {
        
        //Protocol function now executes in two places which is Home and ProfileView Controller. Parentcontroller is dynamic becaseu if we are in Home Controller then parentController is the HomeController and if we are in ProfileViewController then the parent is ProfileViewController.
        
        (parentController as? PostDelegate)?.handleComments(post: item)
    }
    
    override var item: Post! {
        didSet{
           //First Function to execute in this class
            //each label and image ko lagi data from the server
            userName.text = item.user.fullName
            postImage.sd_setImage(with: URL(string: item.imageUrl))
            postTextLabel.text = item.text
            profileImageView.sd_setImage(with: URL(string: item.user.profileImageUrl ?? "0"))
            postedTimeStamp.text = "Posted \(item.fromNow)"
            
            if item.hasLiked == true {
                likeButton.setImage(#imageLiteral(resourceName: "like-red"), for: .normal)
                likeButton.tintColor = .red
            } else {
                likeButton.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                likeButton.tintColor = .black
            }
            
               
           }
       }
    
    
    
    override func setupViews() {
        //this is to render out each cell in the home and profile controller
        super.setupViews()
        
        commentButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleComment))
        commentButton.addGestureRecognizer(tapGesture)
        
        optionsButton.isUserInteractionEnabled = true
        let tg = UITapGestureRecognizer(target: self, action: #selector(optionsDelButton))
        optionsButton.addGestureRecognizer(tg)
        
        profileImageView.layer.borderWidth = 1
        
//        imageheightAnchor = postImage.heightAnchor.constraint(equalToConstant: 0)
//        imageheightAnchor.isActive = true
        
        postImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        postImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        
        
        stack(hstack(stack(profileImageView).padRight(10).padBottom(16).padTop(16),
                     hstack(stack(userName, stack(postedTimeStamp.withWidth(200)).padTop(-50).padBottom(2)).padTop(-20), UIView(), optionsButton.withWidth(25).withHeight(25))).padLeft(10).padRight(10).padTop(10).padBottom(5),
              postImage,
              hstack(likeButton.withWidth(30).withHeight(30),
                     commentButton.withWidth(30).withHeight(30),
                     UIView(),
                     spacing: 20).padLeft(10).padRight(10).padTop(10),
              stack(likeCountLabel).padLeft(10).padTop(10),
              stack(postTextLabel).padLeft(16).padRight(16).padBottom(16).padTop(16))
        
        
        
    }
}
