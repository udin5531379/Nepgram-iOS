//
//  UserSearchCell.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 5/26/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import LBTATools
import Alamofire


class UserSearchCell: LBTAListCell<User> {
    
    let nameLabel = UILabel(text: "Name", font: .systemFont(ofSize: 16), textColor: .black)
    
    lazy var folloUnfollowButton = UIButton(title: "Follow", titleColor: .black, font: .systemFont(ofSize: 16), backgroundColor: .white, target: self, action: #selector(handleFollowUnfollow))
    
    @objc func handleFollowUnfollow(){
    
        (parentController as? UserSearchController)?.didFollow(user: item)
    
    }
    
    override var item: User! {
        
        //called whenever a property has changes
        didSet {
            nameLabel.text = item.fullName
                
            if item.isFollowing == true {
                folloUnfollowButton.backgroundColor = .black
                folloUnfollowButton.setTitle("Unfollow", for: .normal)
                folloUnfollowButton.setTitleColor(.white, for: .normal)
            } else {
                folloUnfollowButton.backgroundColor = .white
                folloUnfollowButton.setTitle("Follow", for: .normal)
                folloUnfollowButton.setTitleColor(.black, for: .normal)
            }
            
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        folloUnfollowButton.layer.cornerRadius = 17
        folloUnfollowButton.layer.borderWidth = 1
        
        hstack(nameLabel,
               UIView(),
               folloUnfollowButton.withHeight(35).withWidth(110), alignment: .center ).padLeft(20).padRight(16)
    }
    
}

extension UserSearchController {
    
    func didFollow(user: User){
        //1. get the index of the button being pressed.
        guard let index = items.firstIndex(where: {$0.id == user.id}) else {return}
        
        //if the user is following...
        let isFollowing = user.isFollowing == true
        let url = "\(Service.shared.baseUrl)/\(isFollowing ? "unfollowing" : "following")/\(user.id)"
        
        AF.request(url, method: .post, encoding: URLEncoding()).validate(statusCode: 200..<300).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("cannot unfollow/follow the user", err)
                return
            }
            
                self.items[index].isFollowing = !isFollowing //flippomg the boolean value
                self.collectionView.reloadItems(at: [[0, index]]) // yesley chahe cell reload garcha


            
         
        }
    }
}

