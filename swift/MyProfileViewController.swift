//
//  MyProfileViewController.swift
//  WordUp
//
//  Created by Jacky Kong on 5/7/17.
//  Copyright © 2017 Jacky Kong. All rights reserved.
//

import UIKit
import Alamofire

class MyProfileViewController: UIViewController {

    @IBOutlet weak var profileUserName: UILabel!
    @IBOutlet weak var knownLangLabel: UILabel!
    @IBOutlet weak var learnLangLabel: UILabel!
    @IBOutlet weak var profileUserDescription: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: defaultsKeys.keyOne)
        profileUserName.text = userName
        profileUserDescription.becomeFirstResponder()
        
//        let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
//        
//        
//        let auth_header = ["Authorization" : "Token " + tokenString]
//        
//        let userNameEndpoint: String = "https://wordup-163921.appspot.com/profiles/"
//        Alamofire.request(userNameEndpoint, headers: auth_header).validate()
//            .responseJSON { response in
//                
//                switch response.result {
//                case .success:
//                    print("Validation Successful")
//                    
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

        


        
        
        
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        print("HEY WHATS UP HELLO~~")
        
        // POST WITH TOKEN
        let todosEndpoint: String = "https://wordup-163921.appspot.com/logout/"
        let newTodo: [String: Any] = [:]
        
        //        print(loginUserNameTextField.text)
        //        print(loginPasswordTextField.text)
        
        let defaults = UserDefaults.standard
        let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
        let auth_header = ["Authorization" : "Token " + tokenString]
        
        
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo, encoding: JSONEncoding.default, headers: auth_header)
            .response { response in // was .responseJSON
                if let httpError = response.error {
                    print("ERROR HERE:")
                    let statusCode = httpError._code
                    print(statusCode)
                } else {
                    
                }
                
        }
        
        // CLEAR GLOBAL VARS
        
        defaults.removeObject(forKey: defaultsKeys.keyOne)
        defaults.removeObject(forKey: defaultsKeys.tokenKey)
        defaults.synchronize()
        
        let userName = defaults.string(forKey: defaultsKeys.keyOne)
        print ("WE ARE CLEARING THE USERNAME KEY")
        print (userName)
        let password = defaults.string(forKey: defaultsKeys.tokenKey)
        print ("WE ARE CLEARING THE TOKEN KEY")
        print (password)
        
    }
    
    
    
    //    func textFieldShouldReturn(textField: UITextView) -> Bool{
    //        return true
    //    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     Get the new view controller using segue.destinationViewController.
     Pass the selected object to the new view controller.
     }
     */


}
