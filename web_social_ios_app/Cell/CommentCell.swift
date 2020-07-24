//
//  CommentCell.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 7/24/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import Foundation
import LBTATools

class CommmentCell : LBTAListCell<Comment> {
    
    let profileImageView = CircularImageView(width: 44)
    let commentedUsersNameLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 17), textColor: .black)
    let commentedTimeLabel = UILabel(text: "", font: .systemFont(ofSize: 13), textColor: .lightGray)
    let commentTextLabel = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .black, numberOfLines: 100)
    let nilCommentLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 50), textColor: .black, textAlignment: .center)
    
    
    override var item: Comment! {
        didSet {
            profileImageView.sd_setImage(with: URL(string: item.user.profileImageUrl ?? ""))
            commentedUsersNameLabel.text = item.user.fullName
            commentedTimeLabel.text = "Posted \(item.fromNow)"
            commentTextLabel.text = item.text
            
        }
    }
    
    
    override func setupViews() {
           super.setupViews()
        
        commentTextLabel.lineBreakMode = .byWordWrapping
        //each cell kasari render out garney part
        stack(hstack(profileImageView,
                     stack(commentedUsersNameLabel,commentedTimeLabel), spacing: 10).padBottom(10),
            commentTextLabel).padTop(10).padRight(10).padLeft(10).padBottom(10)
        
       }
       
    
}
