//
//  WebService.swift
//  AtbDemo
//
//  Created by Frank Mao on 2019-01-30.
//  Copyright © 2019 mazoic. All rights reserved.
//

import UIKit

class WebService {

    static let BASE_URL : String = "https://pg-app-9n7l0umow0580c4b7i5dhy6istr4je.scalabl.cloud/1"
    static let APP_ID : String = "QKNoKbq76lL8BimtH3fkOQgOVpShlRjHeBID3HfP"
    static let REST_KEY : String = "AE7XJ7Drawv4dqfi2sD2rgC6TSHNISqJl3VHPeSf"
    
    static func userLogin(username: String, password: String, callBack :   @escaping ( User?,  String?)->()) {
       
        let encodedUsername = username.replacingOccurrences(of: "+", with: "%2B") //addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "\(BASE_URL)/login?username=\(encodedUsername)&password=\(password)")
        
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        
        request.httpMethod = "GET"
        
        request.setValue(APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.setValue(REST_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                callBack(nil, error?.localizedDescription)
                
                return
                
            }
            
            
            do {
                //create decodable object from data
                let error = try JSONDecoder().decode(ErrorResponse.self, from: data)
                
                
                callBack(nil, error.error)
                return
            } catch _ {
                
            
            
               
            }
            
            do {
                //create decodable object from data
                let decodedObject = try JSONDecoder().decode(User.self, from: data)
                print(decodedObject)
                
                callBack(decodedObject, nil)
            } catch let error {
                print("json decoder error, \(error.localizedDescription)")
                
                callBack(nil, error.localizedDescription)
            }
            
        
        }
        task.resume()
    }
    
    
    static func fetchUserAccounts(userObjectId: String, callBack :   @escaping ( [UserAccount]?,  String?)->()) {
        
        
        let url = URL(string: "\(BASE_URL)/classes/UserAccount?where=%7B%22user%22%3A%7B%22__type%22%3A%22Pointer%22%2C%20%22className%22%3A%22_User%22%2C%20%22objectId%22%3A%20%22YMJH4RlUyw%22%7D%7D&include=account")
        
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        
        request.httpMethod = "GET"
        
        request.setValue(APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.setValue(REST_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                callBack(nil, error?.localizedDescription)
                
                return
                
            }
            
            
            do {
                //create decodable object from data
                let error = try JSONDecoder().decode(ErrorResponse.self, from: data)
                
                
                callBack(nil, error.error)
                return
            } catch _ {
                
                
                
                
            }
            
            do {
                
                print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
                
                
                //create decodable object from data
                let decodedObject = try JSONDecoder().decode(UserAccountQueryResponse.self, from: data)
                print(decodedObject)
                
                callBack(decodedObject.results, nil)
            } catch let error {
                print("json decoder error, \(error.localizedDescription)")
                
                callBack(nil, error.localizedDescription)
            }
            
            
        }
        task.resume()
    }
    
}



    

struct ErrorResponse: Decodable {
    let error     : String
    let code      : Int
}
    
struct UserAccountQueryResponse: Decodable {
    let results     : [UserAccount]?
    
}

struct User : Decodable {
    let sessionToken     : String?
    let objectId : String
    let email  : String?
    let username   : String?

}

struct Account: Decodable {
    let name: String
    let objectId: String
    let type: Int
}

struct UserAccount : Decodable {
    let objectId: String
    let user: User
    let account   : Account
    let balance: Float
}


class Session {
    var CurrentUser : User? = nil
    
    static let shared = Session()

}
