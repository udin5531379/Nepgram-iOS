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
    let userName = UILabel(text: "Name", font: .boldSystemFont(ofSize: 15))
    let postImage = UIImageView(image: nil, contentMode: .scaleAspectFit)
    let postTextLabel = UILabel(text: "postText", font: .systemFont(ofSize: 15))
    let optionsButton = UIButton(image: UIImage(imageLiteralResourceName: "threeDots"), tintColor: .black, target: self, action: #selector(optionsDelButton))
    
    @objc func optionsDelButton() {
        print("Option button pressed")
    }
    
    override var item: Post! {
           didSet{
               //First Function to execute in this class after coming from ProfileViewController
            
               userName.text = item.user.fullName
               postImage.sd_setImage(with: URL(string: item.imageUrl))
               postTextLabel.text = item.text
           }
       }
    
    override func setupViews() {
        super.setupViews()
        
        postImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        postImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        stack(hstack(userName,
                     UIView(),
            optionsButton.withWidth(30).withHeight(30)).padLeft(10).padRight(10).padTop(16).padBottom(16),
        postImage,
        stack(postTextLabel).padLeft(16).padRight(16).padBottom(16).padTop(16))
        
    }
}
