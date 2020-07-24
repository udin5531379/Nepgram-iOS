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
   
    let commentedUsersNameLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 17), textColor: .black)
    let commentedTimeLabel = UILabel(text: "", font: .systemFont(ofSize: 10), textColor: .lightGray)
    let commentTextLabel = UILabel(text: "", font: .systemFont(ofSize: 15), textColor: .black)
    
    
    override var item: Comment! {
        didSet {
            commentedUsersNameLabel.text = item.user.fullName
            commentedTimeLabel.text = item.fromNow
            commentTextLabel.text = item.text
        }
    }
    
    
    override func setupViews() {
           super.setupViews()
           self.backgroundColor = .red
       }
       
    
}
