//
//  Comment.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 7/24/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import Foundation

struct Comment: Decodable{
   
    
    let text: String
    let user: User
    let fromNow: String
}
