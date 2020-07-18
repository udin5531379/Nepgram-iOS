//
//  ProfileViewForUsersInSearchController.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 5/31/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import Foundation
import LBTATools
import Alamofire


//in this class LBTAListController uses two generics, one is Cells and another is post objects, or whatever your are trying to render out in the cells

class ProfileViewForUsersInSearchController: LBTAListHeaderController<UserProfileCell, Post, ProfileHeader>, UICollectionViewDelegateFlowLayout {
    
    override func setupHeader(_ header: ProfileHeader) {
        super.setupHeader(header)
        
        if user == nil { return } //since user chahe phela decode hudaina so pahela chahe nil rakhcha to prevent it from crash then JSON decoder bata deocde bhako user pass huncha which consists of some value and then header.user execute huncha. ViewDidLoad pachi yo header execute huncha
        
        header.user = self.user //calling the didSEt method which is present in the Profile Header
        header.profileController = self
        
        
        
      }
    
    //to flip the follow or unfollow button in the header
    func followUnfollowInsideProfile() {
            //if the user is following...
        guard let user = user else { return }
        let isFollowing = user.isFollowing == true
        let url = "\(Service.shared.baseUrl)/\(isFollowing ? "unfollowing" : "following")/\(user.id)"
            
            AF.request(url, method: .post, encoding: URLEncoding()).validate(statusCode: 200..<300).responseData { (dataResponse) in
                if let err = dataResponse.error {
                    print("cannot unfollow/follow the user", err)
                    return
                }
                
                    self.user?.isFollowing = !isFollowing //flipping the boolean value
                    self.collectionView.reloadData()// yesley chahe reload garcha


                
             
            }
    }
    
    let activityIndicatior : UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.startAnimating()
        ai.color = .darkGray
        return ai
    }()
    
    
    //yo profileContoller call garna chahe userID declare garnu parcha first ma 
    let userId : String
    
    init(userId : String) {
        self.userId = userId
        super.init()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserProfile()
        setupActivityIndicator()
        
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(fetchUserProfile), for: .valueChanged)
        self.collectionView.refreshControl = rc
    }
    
    func setupActivityIndicator() {
        collectionView.addSubview(activityIndicatior)
        activityIndicatior.anchor(top: collectionView.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 50, left: 0, bottom: 0, right: 0))
    }
    
    //yo user chahe header ma pass garna lai banako user object yesley chahe decoded user header ma pass garcha
    var user : User?
    
    
    @objc func fetchUserProfile(){
       
        let publicProfileUrl = "\(Service.shared.baseUrl)/user/\(userId)"
        let currentUserProfile = "\(Service.shared.baseUrl)/profile"
        
        //this is done to load the curretn users profile insted of the other users
        let url = self.userId.isEmpty ? currentUserProfile : publicProfileUrl
        
        AF.request(url).validate(statusCode: 200..<300).responseData { (dataResponse) in
            self.activityIndicatior.stopAnimating()
            if let err = dataResponse.error {
                print("Cannot retrive the data", err)
                self.collectionView.refreshControl?.endRefreshing()
                return
            }
            
        
            let data = dataResponse.data ?? Data()
            

            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                self.user = user // aba yo user chahe header ma pass huncha
                self.items = user.posts ?? [] //iteme is predefines and post chahe saab items ma gayera append huncha
                self.user?.isEditable = self.userId.isEmpty
                self.collectionView.refreshControl?.endRefreshing()
                self.collectionView.reloadData()
            } catch let err {
                print(err)
                self.collectionView.refreshControl?.endRefreshing()
            }
            
        }
    }
    
    
    
    //This is for the size of each cell that renders out the images and imageLabel
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = estimatedCellHeight(for: indexPath, cellWidth: width)
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        //this is the decoded user nil bhayo bhaney chahe header ko width and height nil and display nil huncha
        if user == nil {
            return .init(width: 0, height: 0)
        }
        
        return .init(width: 0, height: 300)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
