//
//  UserSearchController.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 5/26/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import Foundation
import LBTATools

//LBTA ListController takes two arguments
class UserSearchController: LBTAListController<UserSearchCell, User> {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search"
        
        Service.shared.searchForUsers { (res) in
            
            switch res {
            
            case .failure(let err):
                print("Failed to find any Users", err)
            
            case .success(let users):
                self.items = users //yo items chahe LBTA tools bata aako which holds all the array
                self.collectionView.reloadData()
            }
            
        }
    }
    
    //to click cell ani present it in another controller
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = items[indexPath.item]
        let controller = ProfileViewForUsersInSearchController(userId: user.id)
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension UserSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        //line spacing between the cells 
    }
}
