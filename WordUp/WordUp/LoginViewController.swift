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
        
        //        print(defaultsKeys.keyOne)
        //        print(defaultsKeys.keyTwo)
        
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
