//
//  ProfileHeader.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 6/5/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import Foundation
import LBTATools


//stack ra label haru saab yesma declare garney

class ProfileHeader:  UICollectionReusableView {
    
    let profileImage = CircularImageView(width: 70)
    
    let fullNameLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 16), textColor: .black, textAlignment: .center)
    
    let followUnfollowButton = UIButton(title: "Follow", titleColor: .black, font: .systemFont(ofSize: 16), backgroundColor: .white, target: self, action: #selector(followUnfollow))
    let editProfileButton = UIButton(title: "Edit Profile", titleColor: .white, font: .boldSystemFont(ofSize: 16), backgroundColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), target: self, action: #selector(editProfile))
    
    let postCountLabel = UILabel(text: "Posts Count", font: .systemFont(ofSize: 12), textColor: .black, textAlignment: .center)
    let followersCountLabel = UILabel(text: "followers", font: .systemFont(ofSize: 12), textColor: .black, textAlignment: .center)
    let followingCountLabel = UILabel(text: "following", font: .systemFont(ofSize: 12), textColor: .black, textAlignment: .center)
    
    let postLabel = UILabel(text: "Posts", font: .systemFont(ofSize: 14), textColor: .black, textAlignment: .center)
    let followersLabel = UILabel(text: "Followers", font: .systemFont(ofSize: 14), textColor: .black, textAlignment: .center)
    let followingLabel = UILabel(text: "Following", font: .systemFont(ofSize: 14), textColor: .black, textAlignment: .center)
    
    let bioLabel = UILabel(text: "This is my Nepgram Profile", font: .systemFont(ofSize: 15), textColor: .black, textAlignment: .center, numberOfLines: 3)
    
    weak var profileController: ProfileViewForUsersInSearchController? //thia is going to link back to the controller class
    
    @objc func followUnfollow() {
        profileController?.followUnfollowInsideProfile()
    }
    
    @objc func editProfile() {
        profileController?.editProfile()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        profileController?.editProfile()
    }
    
    var user : User! {
        didSet{
            profileImage.sd_setImage(with: URL(string: user.profileImageUrl ?? ""))
           
            
            fullNameLabel.text = user.fullName
            bioLabel.text = user.bio
            
            followUnfollowButton.setTitle(user.isFollowing == true ? "Unfollow" : "Follow", for: .normal)
            followUnfollowButton.setTitleColor(user.isFollowing == true ? .white : .black, for: .normal)
            followUnfollowButton.backgroundColor = user.isFollowing == true ? .black : .white
            
            if user.isEditable == true {
                followUnfollowButton.removeFromSuperview()
            } else {
                editProfileButton.removeFromSuperview()
            }
            
            followersCountLabel.text = "\(user.followers?.count ?? 0 )"
            followingCountLabel.text = "\(user.following?.count ?? 0 )"
            postCountLabel.text = "\(user.posts?.count ?? 0 )"
           
        }
    }
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 0.5)
        
        followUnfollowButton.layer.cornerRadius = 17
        
        profileImage.layer.cornerRadius = 40
        profileImage.layer.borderWidth = 1
        
        profileImage.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        
        editProfileButton.layer.cornerRadius = 17
        
        stack(profileImage,
              fullNameLabel,
              followUnfollowButton.withHeight(35).withWidth(100),
              editProfileButton.withHeight(35).withWidth(100),
              hstack(stack(postCountLabel,postLabel),
                     stack(followersCountLabel,followersLabel),
                     stack(followingCountLabel,followingLabel),
                     spacing: 16, alignment: .center),
              bioLabel,
              spacing: 10, alignment: .center).withMargins(.allSides(16))
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
