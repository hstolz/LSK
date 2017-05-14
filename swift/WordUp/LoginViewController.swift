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
    static let keyThree = "userId"
    static let keyFour = "known_lang"
    static let keyFive = "learn_lang"
    static let keySix = "bio"
    
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginUserNameTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        defaults.set(loginUserNameTextField.text, forKey: defaultsKeys.keyOne)
        defaults.set(loginPasswordTextField.text, forKey: defaultsKeys.keyTwo)
        
        let endpoint: String = "https://wordup-163921.appspot.com/login/"
        let parameters: [String: Any] = ["username": defaults.string(forKey: defaultsKeys.keyOne)!,
                                         "password": defaults.string(forKey: defaultsKeys.keyTwo)!]
        
         Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    
                    let user_profile = response.result.value as! NSDictionary                    
                    defaults.set(user_profile["id"], forKey: defaultsKeys.keyThree)
                    defaults.set(user_profile["known_lang"], forKey: defaultsKeys.keyFour)
                    defaults.set(user_profile["learn_lang"], forKey: defaultsKeys.keyFive)
                    defaults.set(user_profile["bio"], forKey: defaultsKeys.keySix)
                    
                    let endpoint: String = "https://wordup-163921.appspot.com/token/"
                    let parameters: [String: Any] = ["username": defaults.string(forKey: defaultsKeys.keyOne)!, "password": defaults.string(forKey: defaultsKeys.keyTwo)!]
                    
                    var tokenDict = [String:String]()
                    Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate()
                        .responseJSON { response in
                            
                            switch response.result {
                            case .success:
                                tokenDict = (response.value as! NSDictionary) as! [String : String]
                                defaults.set(tokenDict["token"], forKey: defaultsKeys.tokenKey)
                                self.performSegue(withIdentifier: "loginSegue", sender: self)
                                
                            case .failure(let error):
                                print(error)
                                self.showAlert(userMessage: "Login failed. Please Try Again.",
                                                           title: "Error")
                            }
                    }
                    
                case .failure(let error):
                    print(error)
                    self.showAlert(userMessage: "Login failed. Please Try Again.",
                                               title: "Error")
                }
        }
    }
    
    func showAlert(userMessage:String, title:String) {
        let myAlert = UIAlertController(title: title, message: userMessage,
                                        preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in }
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
