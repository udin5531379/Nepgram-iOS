//
//  Service.swift
//  web_social_ios_app
//
//  Created by Udin Rajkarnikar on 5/27/20.
//  Copyright © 2020 np.com.udinrajkarnikar. All rights reserved.
//

import Foundation
import Alamofire

class Service: NSObject {
     
    static let shared = Service()
    
    let baseUrl = "http://localhost:1337"
    
    func searchForUsers(completion: @escaping (AFResult<[User]>) -> ()) {
        let url = "\(baseUrl)/search"
        AF.request(url).validate(statusCode: 200..<300).responseData { (dataResponse) in
            
            if let err = dataResponse.error {
                completion(.failure(err))
                return
            }
            
            do {
                let data = dataResponse.data ?? Data()
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(.success(users))
            } catch {
                guard let error = dataResponse.error else { return }
                
                completion(.failure(error))
            }
        }
    }
}
