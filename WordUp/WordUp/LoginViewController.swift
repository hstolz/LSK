//
//  LoginViewController.swift
//  WordUp
//
//  Created by Jacky Kong on 4/29/17.
//  Copyright © 2017 Jacky Kong. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

struct defaultsKeys {
    
    static let keyOne = "username"
    static let keyTwo = "password"
    static let tokenKey = "token"
    
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginUserNameTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        //  Verification Code 
        
        let defaults = UserDefaults.standard
        
        defaults.set(loginUserNameTextField.text, forKey: defaultsKeys.keyOne)
        
        defaults.set(loginPasswordTextField.text, forKey: defaultsKeys.keyTwo)
        
        let userName = defaults.string(forKey: defaultsKeys.keyOne)
        print (userName!)
        let password = defaults.string(forKey: defaultsKeys.keyTwo)
        print (password!)
        
        
        // WE SHOULD CHECK THAT FIELDS ARENT EMPTY... 
        
        //        print(defaultsKeys.keyOne)
        //        print(defaultsKeys.keyTwo)
        
        // ------------- POST --------------------------- //
        
        let todosEndpoint: String = "https://wordup-163921.appspot.com/login/"
        let newTodo: [String: Any] = ["username": loginUserNameTextField.text, "password": loginPasswordTextField.text]
        
        print(loginUserNameTextField.text)
        print(loginPasswordTextField.text)
        
        
         Alamofire.request(todosEndpoint, method: .post, parameters: newTodo, encoding: JSONEncoding.default)
            .response { response in // was .responseJSON
                if let httpError = response.error {
                    print("ERROR HERE:")
                    let statusCode = httpError._code
                    print(statusCode)
                } else {
                    
//                    print("DEM DEBUG STATEMENTS DOE")
//                    debugPrint(response)
                    
                    print("RESPONSE: ")
                    print(response)
                    print("............")
//                    if let value = response.result.value {
//                        let json = (response.value as! String)
//                        let statusCode = (response.response?.statusCode)!
//                        if statusCode == 401 {
//                            print(json)
//                        } else {
//                            print(json)
//                           // let token = json["token"]
//                            
//                        }
//                    }
                    
                    
                }
                
        }
        
        
         print("END POST --------------------------- ------//")
        
        // HIT TOKEN
        let tokenEndpoint: String = "https://wordup-163921.appspot.com/token/"
        let tokenParameters: [String: Any] = ["username": loginUserNameTextField.text, "password": loginPasswordTextField.text]
        
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
        // END HIT TOKEN
        print("HERE IS THE ONE OUTSIDE THE FCT!!")
        print(tokenDict)
  //      print("THE TOKEN IS" + tokenDict["token"]!)
        
  //      let Auth_header = ["Authorization" : "Token " + tokenDict["token"]! ]
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
