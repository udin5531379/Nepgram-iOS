//
//  PostCell.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 5/8/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import Foundation
import LBTATools

protocol DeletePostCellDelegateOptions {
    
    func handlePostOptions(cell: PostCell)

}

class PostCell: UITableViewCell {
    
    let postUsername = UILabel(text: "Username", font: .boldSystemFont(ofSize: 16), textColor: .black)
    
    let postImageView = UIImageView(image: nil, contentMode: .scaleAspectFit)
    
    let postTextLabel = UILabel(text: "Post with multiple lines", font: .systemFont(ofSize: 15, weight: .medium), textColor: .black, numberOfLines: 50)
    
    lazy var deleteOptionButton = UIButton(image: UIImage(imageLiteralResourceName: "threeDots"), tintColor: .black, target: self, action: #selector(handleDeletePostInEachCell))
    
    var delegate: DeletePostCellDelegateOptions? //beginng ma nil huncha kina bhaney hamiley delete garna lai cell choose gareyko hudaina
    
    
    @objc func handleDeletePostInEachCell() {
        
        print("Option to Delete pressed")
//        delegate?.handlePostOptions(cell: self)
        
    }
     
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //what this anchor does is it lets the uploaded image apper to be in square shape like that in instagram. height ra width equal gareyko
        
        postImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        stack(hstack(postUsername, deleteOptionButton.withWidth(30).withHeight(30)).padLeft(16).padTop(16).padRight(16),
              stack(postImageView).padTop(16).padBottom(16),
              stack(postTextLabel).padLeft(16).padRight(16).padBottom(30))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
