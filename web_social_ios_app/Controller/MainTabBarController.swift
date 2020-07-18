//
//  MainTabBarController.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 6/18/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import UIKit



class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewControllers?.firstIndex(of: viewController) == 1 { //this 1 is the maintab controller for image picker plus sign
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            present(imagePicker, animated: true)
            
            return false
            
        }
        return true
    }
    
    let homeController = HomeController()
    let profileViewController = ProfileViewForUsersInSearchController(userId: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = UIViewController()
        vc.view.backgroundColor = .yellow
        UITabBar.appearance().tintColor = .black
        UINavigationBar.appearance().tintColor = .black
        self.delegate = self
        

        
        viewControllers = [
            createNavBarInsideTabBar(viewController: homeController, tabBarImage: #imageLiteral(resourceName: "home")),
            createNavBarInsideTabBar(viewController: vc, tabBarImage: #imageLiteral(resourceName: "plus")),
            createNavBarInsideTabBar(viewController: profileViewController, tabBarImage: #imageLiteral(resourceName: "userprofile"))
        ]
    }
    
    func refresEverythingInTheUI(){
        homeController.fetchData()
        profileViewController.fetchUserProfile()
    }
    
    func createNavBarInsideTabBar(viewController: UIViewController, tabBarImage: UIImage) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = tabBarImage
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: 15, left: 10, bottom: -3, right: 10)
        
        
        
        return navController
    }
}

extension MainTabBarController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
                let createPostController = CreatePostContoller(selectedImage: image)
                self.present(createPostController, animated: true)
            }
        } else {
             dismiss(animated: true)
        }
      }
    
}
