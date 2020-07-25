//
//  HomeController.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 5/4/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import Foundation
import LBTATools
import WebKit
import Alamofire
import JGProgressHUD
import SDWebImage


class HomeController: LBTAListController<UserProfileCell, Post>, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PostDelegate{
    
    //Delegate Function to show comments on both the HomeControllerView and ProfileControllerView
    func handleComments(post: Post) {
        let postViewController = PostCommentDetailsController(postId: post.id)
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Home"
        
        let searchButton = UIButton(image: #imageLiteral(resourceName: "search"), tintColor: .black, target: self, action: #selector(handleSearch))
        let barButton = UIBarButtonItem(customView: searchButton)
        NSLayoutConstraint.activate([(barButton.customView!.widthAnchor.constraint(equalToConstant: 23)),
                                     (barButton.customView!.heightAnchor.constraint(equalToConstant: 23))])
        navigationItem.rightBarButtonItem = barButton
            
        
        navigationItem.leftBarButtonItem = .init(title: "Login", style: .plain, target: self, action: #selector(loginCredentials))
        
        let refreshC = UIRefreshControl()
           refreshC.addTarget(self, action: #selector(fetchData), for: .valueChanged)
           self.collectionView.refreshControl = refreshC
        
        
     }
    
    
    @objc func handleSearch(){
        let navC = UINavigationController(rootViewController: UserSearchController())
        present(navC, animated: true)
        
    }
    
    //login button
    @objc func loginCredentials(){
        
        print("trying to login...")
        let navController = UINavigationController(rootViewController: LoginController())
        present(navController, animated: true)
        
    }
    
    
    let hud = JGProgressHUD(style: .dark)
    let baseURL = "http://localhost:1337/post"
    
    
    //for fetching the data from the server
    @objc func fetchData() {
        
        //for progress hud
        hud.vibrancyEnabled = true
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.5)
        hud.textLabel.text = "Loading..."
        hud.show(in: self.view)
        
        
        AF.request(baseURL)
            .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                if let err = dataResponse.error {
                    self.collectionView.refreshControl?.endRefreshing()
                    self.hud.textLabel.text = "Failed to fetch the data"
                    print("failed to retrive the data, ", err)
                    self.hud.dismiss()
                    return
                }
                
                guard let data = dataResponse.data else { return }
                do{
                    self.collectionView.refreshControl?.endRefreshing()
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    print(posts)
                    self.items = posts
                    self.collectionView.reloadData()
                    self.hud.dismiss()
                } catch {
                    self.collectionView.refreshControl?.endRefreshing()
                    print(error)
                }
                
        }
    }
}
 //yo wipe gareyko becasue these are tableview functions and LBTA tools are more of a collectionView.
    
//    var posts = [Post]()
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//       tableView.deselectRow(at: indexPath, animated: true)
//
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return posts.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = PostCell(style: .subtitle, reuseIdentifier: "postCell")
//        let post = posts[indexPath.row]
//        cell.postUsername.text = post.user.fullName
//        cell.postTextLabel.text = post.text
//        cell.postImageView.sd_setImage(with: URL(string: post.imageUrl))
//        cell.delegate = self
//
//        return cell
        
        
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
//        let post = posts[indexPath.row]
//        cell.textLabel?.text = post.user.fullName
//        cell.textLabel?.font = .systemFont(ofSize: 10, weight:
//        cell.detailTextLabel?.text = post.text
//        cell.detailTextLabel?.numberOfLines = 0
//
//        //to show the image in the table view
//        cell.imageView?.sd_setImage(with: URL(string: post.imageUrl ))
//
//
//
//    }



//now homecontroller has access to the each cell since we just confirmed it to the delegate in the PostCell
// 1.delegate setup garna lai first ma protoocl banauney Postcell ma
//2.Inside PostCell var delegate: (Protocol Name)
//3.delegatw.(prootocol name)
//4. HomeController ma delegate extension garney

//extension HomeController: DeletePostCellDelegateOptions {
    
//    func handlePostOptions(cell: PostCell) {
//
//        let deleletAlertAction = UIAlertController(title: "Delete Post", message: "Are you sure you want to delete this post?", preferredStyle: .actionSheet)
//
//        let okDelete = UIAlertAction(title: "Delete", style: .destructive) { (delete) in
//            //this is to delete the post cell from both server and UI
//            
//            //for progress hud
//            self.hud.vibrancyEnabled = true
//            self.hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.5)
//            self.hud.textLabel.text = "Loading..."
//            self.hud.show(in: self.view)
//            print("Delete button Pressed")
//
//            guard let indexPath = self.tableView.indexPath(for: cell) else { return }
//            let post = self.posts[indexPath.row]
//            let url = self.baseURL + "/\(post.id)"
//
//             AF.request(url, method: .delete).validate(statusCode: 200..<300).response { (dataResponse) in
//                 if let response = dataResponse.error{
//                     print(url)
//                     print("The Post could not be deleted", response)
//                    self.hud.textLabel.text = "The post could not be deleted"
//                    self.hud.dismiss()
//                     return
//
//                }
//                        self.hud.dismiss()
//                        print("Sucessfully deleted post")
//                         //yo chahe array bata delete gareyko
//                         self.posts.remove(at: indexPath.row)
//
//                         //yo chahe tableView bata delete gareyko ie UI ma
//                         self.tableView.deleteRows(at: [indexPath], with: .automatic)
//
//             }
//
//        }
//
//        let cancelDelete = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
//            print("cancel button Pressed")
//        }
//
//        deleletAlertAction.addAction(okDelete)
//        deleletAlertAction.addAction(cancelDelete)
//
//        self.present(deleletAlertAction, animated: true)
//
//        }
    
    
//}

   //fecthData() {//this one is for webVIew loading html tag in the iphone app
       //      {
       //        print("Fetching Data...")
       //
       //        guard let url = URL(string: "http://localhost:1337/post") else {return}
       //
       //        DispatchQueue.main.async{
       //
       //            URLSession.shared.dataTask(with: url) {(data, resp, err) in
       //                  if let err = err {
       //                      //Failing to load the data from the server
       //                        print("Failed to hit the server", err)
       //                        return
       //
       //                  } else if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {
       //
       //                      //Unauthorized login
       //                      print("Failed to fetch the post, status code: ", resp.statusCode)
       //
       //                      return
       //
       //                  } else {
       //
       //                    DispatchQueue.main.async {
       //                        //After login, sucessfully fetching the data
       //                        print("Data Fecthing Sucessful, with response data: ")
       //                        let html = String(data: data ?? Data(), encoding: .utf8) ?? ""
       //                        print(html)
       //                        let vc = UIViewController()
       //                        let webview = WKWebView()
       //                        webview.loadHTMLString(html, baseURL: nil)
       //                        vc.view.addSubview(webview)
       //                        webview.fillSuperview()
       //                        self.present(vc, animated: true)
       //                        }
       //
       //                    }
       //
       //                  }.resume()
       //            }
       //        }
           

    

extension UIBarButtonItem {

    static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true

        return menuBarItem
    }
    
    static func postButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true

        return menuBarItem
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    //this is height for each of the cell in the HomeController
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = estimatedCellHeight(for: indexPath, cellWidth: width)
        return .init(width: width, height: height)
    }
    
//Delegate


}
