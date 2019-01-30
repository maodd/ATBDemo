//
//  WebService.swift
//  AtbDemo
//
//  Created by Frank Mao on 2019-01-30.
//  Copyright © 2019 mazoic. All rights reserved.
//

import UIKit

class WebService {

    static let BASE_URL : String = "https://pg-app-0zm86ep1vrbd6js8hyexeabkrxsqhv.scalabl.cloud/1"
    static let APP_ID : String = "wszGxJOkF1BLInGgZbD5koUUpojUOGPqmnHQmLVN"
    static let REST_KEY : String = "4eiICezfYc1gWAM0KCWR3aASWTnOYIGPQnpHjoLg"
    
    static func userLogin(username: String, password: String, callBack :   @escaping ( User?,  String?)->()) {
       
        let encodedUsername = username.replacingOccurrences(of: "+", with: "%2B") //addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "\(BASE_URL)/login?username=\(encodedUsername)&password=\(password)")
        print(url?.absoluteString)
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
            
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
            
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
    
}

    

struct ErrorResponse: Decodable {
    let error     : String
    let code      : Int
    
}
    
struct ParseResponse: Decodable {
    let results     : [User]
    
}

struct User : Decodable {
    let sessionToken     : String
    let objectId : String
    let email  : String
    let username   : String
    let balance: Float
}

class Session {
    var CurrentUser : User? = nil
    
    static let shared = Session()

}
