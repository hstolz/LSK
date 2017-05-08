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
    
    
//    func getMatches(userNameString: String, auth_header: Dictionary<String, String>) {
//        
//        let userNameEndpoint: String = "https://wordup-163921.appspot.com/matches/"
//        Alamofire.request(userNameEndpoint, headers: auth_header).validate()
//            .responseJSON { response in
//                
//                switch response.result {
//                case .success:
//                    print("Validation Successful")
//                    
//                    self.TableData = (response.value as! NSArray) as! [[String : AnyObject]]
//                    if self.TableData.count == 0 {
//                        self.displayMyAlertMessage(userMessage: "You do not have any matches yet!", title: "Aww :(")
//                    }
//                    
//                    //  print ("THIS IS THE MATCH ID!!!!!!")
//                    print (self.TableData)
//                    self.tableView.reloadData()
//                    
//                case .failure(let error):
//                    print(error)
//                    print("HEY WHATS UP HELLO, SOMETHING IS WRONG")
//                }
//                
//                // print response as string for debugging, testing, etc.
//                // print(response.result.value as! NSArray)
//                // print(response.result.value as! NSDictionary)
//                print(response.result.error)
//                print(response.request)  // original URL request
//                print(response.response) // HTTP URL response
//                print(response.data)     // server data
//                
//        }
//        
//    }

}
