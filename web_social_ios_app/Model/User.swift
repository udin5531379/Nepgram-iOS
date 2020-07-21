//
//  User.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 6/1/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import Foundation

struct User: Decodable {
    
    //var because huna ni sakcha na huna ni sakcha
    let id : String
    let fullName: String
    let emailAddress: String
    var isFollowing: Bool?
    var followers, following: [User]?
    var posts: [Post]? //optional becasue it may contain post or it may not
    
    var isEditable: Bool?
    var bio: String?
    var profileImageUrl: String?
}

struct Post: Decodable {
    let id: String
    let createdAt: Int
    let text: String
    let user: User
    let imageUrl: String
    let fromNow: String
    
}




