//
//  loginAPI.swift
//  WordUp
//
//  Created by Jacky Kong on 5/8/17.
//  Copyright © 2017 Jacky Kong. All rights reserved.
//

import Foundation
import Alamofire

class LoginAPI{
    
    class func doTestPrint() {
        print("WE ARE CALLING FROM ANOTHER SWIFT CLASS WOO!")
        
    }
    
    // add Luis's implementation of storing user data
    class func doLogin(userNameString: String, userPasswordString: String) {
        
        let defaults = UserDefaults.standard
        let loginEndpoint: String = "https://wordup-163921.appspot.com/login/"
        let loginParams: [String: Any] = ["username": userNameString, "password": userPasswordString]
        // defaults.set(userNameString, forKey: defaultsKeys.keyOne)
        
        Alamofire.request(loginEndpoint, method: .post, parameters: loginParams, encoding: JSONEncoding.default).validate()
            .responseJSON { response in // was .responseJSON
                
                switch response.result {
                case .success:
                    
                    print(response.result.value as! NSDictionary)
                    let my_Profile = response.result.value as! NSDictionary
                    print(my_Profile["username"] as! String)
                    print(response.result)
                    
                    defaults.set(my_Profile["id"], forKey: defaultsKeys.keyThree)
                    defaults.set(my_Profile["known_lang"], forKey: defaultsKeys.keyFour)
                    defaults.set(my_Profile["learn_lang"], forKey: defaultsKeys.keyFive)
                    defaults.set(my_Profile["bio"], forKey: defaultsKeys.keySix)
                    
                    
                case .failure(let error):
                    print(error)
                    
                    
            }
        }
        
    }

    class func doGetToken(userNameString: String, userPasswordString: String) {
        
        let defaults = UserDefaults.standard
        
        let tokenEndpoint: String = "https://wordup-163921.appspot.com/token/"
        let tokenParameters: [String: Any] = ["username": userNameString, "password": userPasswordString]
        
        var tokenDict = [String:String]()
        Alamofire.request(tokenEndpoint, method: .post, parameters: tokenParameters, encoding: JSONEncoding.default)
            .responseJSON { response in // was .responseJSON
                if let httpError = response.error {
                    print("ERROR HERE:")
                    let statusCode = httpError._code
                    print(statusCode)
                } else {
                    
                    print("DEM DEBUG STATEMENTS DOE")
                    debugPrint(response)
                    
                    print("TOKEN AS NSDICT:")
                    
                    print(response.value as! NSDictionary)
                    tokenDict = (response.value as! NSDictionary) as! [String : String]
                    print(tokenDict)
                    
                    defaults.set(tokenDict["token"], forKey: defaultsKeys.tokenKey)
                    
                    let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)
                    print("WE ARE PRINTING THE SHIT NOW")
                    print(tokenString)
                }
                
        }
    }

}
