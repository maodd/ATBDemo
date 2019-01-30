//
//  AtbDemoTests.swift
//  AtbDemoTests
//
//  Created by Frank Mao on 2019-01-30.
//  Copyright © 2019 mazoic. All rights reserved.
//

import XCTest
@testable import AtbDemo

class AtbDemoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /****
 
     curl -X POST \
     -H "Content-Type: application/json" \
     -H "X-LC-Id: {{appid}}" \
     -H "X-LC-Key: {{appkey}}" \
     -d '{"username":"hjiang","password":"f32@ds*@&dsa"}' \
     https://api.parse.cn/1.1/login
     
     */
    func testUserLogin() {
        
        let expectation = XCTestExpectation(description: "User login")
        
        
        WebService.userLogin(username: "maodd.ca@gmail.com", password: "123456") {
            
         user , error in 
            guard let user = user, error == nil else {
                XCTFail("No data was downloaded. \(error)")
                return }
            
            print(user.objectId)
            
            // Fulfill the expectation to indicate that the background task has finished successfully.
            expectation.fulfill()
            
        }
        
        
        
        wait(for: [expectation], timeout: 30.0)
        
    }
    
    func testFetchCurrentUser() {
        
        let expectation = XCTestExpectation(description: "Fetch current user")
        
        
        let url = URL(string: "https://pg-app-0zm86ep1vrbd6js8hyexeabkrxsqhv.scalabl.cloud/1/users/me")
        
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        
        request.httpMethod = "GET"
        
        request.setValue("wszGxJOkF1BLInGgZbD5koUUpojUOGPqmnHQmLVN", forHTTPHeaderField: "X-Parse-Application-Id")
        request.setValue("4eiICezfYc1gWAM0KCWR3aASWTnOYIGPQnpHjoLg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.setValue("r:a349ea74990b76dd3d9e1ec70b5ab083", forHTTPHeaderField: "X-Parse-Session-Token")
        
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                XCTFail("No data was downloaded. \(error?.localizedDescription)")
                return }
            
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
            
            
            
            
            do {
                //create decodable object from data
                let decodedObject = try JSONDecoder().decode(User.self, from: data)
                print(decodedObject)
            } catch let error {
                print("json decoder error, \(error.localizedDescription)")
            }
            
            
            // Fulfill the expectation to indicate that the background task has finished successfully.
            expectation.fulfill()
            
        }
        
        task.resume()
        
        wait(for: [expectation], timeout: 30.0)
        
    }
    
    func testFetchAllUsers() {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Fetch user account")
        
        
        let url = URL(string: "https://pg-app-0zm86ep1vrbd6js8hyexeabkrxsqhv.scalabl.cloud/1/classes/_User")
        
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.setValue("wszGxJOkF1BLInGgZbD5koUUpojUOGPqmnHQmLVN", forHTTPHeaderField: "X-Parse-Application-Id")
        request.setValue("4eiICezfYc1gWAM0KCWR3aASWTnOYIGPQnpHjoLg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                XCTFail("No data was downloaded. \(error?.localizedDescription)")
                return }
            
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
            
            
            
            
            do {
                //create decodable object from data
                let decodedObject = try JSONDecoder().decode(ParseResponse.self, from: data)
                print(decodedObject)
            } catch let error {
                print("json decoder error, \(error.localizedDescription)")
            }
            
            
            // Fulfill the expectation to indicate that the background task has finished successfully.
            expectation.fulfill()
            
        }
        
        task.resume()
        
        wait(for: [expectation], timeout: 30.0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

 
}
