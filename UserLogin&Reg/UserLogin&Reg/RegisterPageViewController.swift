//
//  RegisterPageViewController.swift
//  UserLogin&Reg
//
//  Created by Jacky Kong on 4/12/17.
//  Copyright © 2017 Jacky Kong. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = repeatPasswordTextField.text
        
        
        // check for empty fields
        if (userEmail == "" || userEmail == nil ) {
            
            // display alert! return for now... 
            displayMyAlertMessage(userMessage: "All fields are required.");
            return;
        }
        
        // check if passwords match 
        
        if (userPassword != userRepeatPassword) {
            
            // display an alert. return for now... 
            displayMyAlertMessage(userMessage: "Passwords do not match.");
            return;
        }
        
        // store data 

        UserDefaults.standard.set(userEmail, forKey:"userEmail");
        UserDefaults.standard.set(userEmail, forKey:"userPassword");
        UserDefaults.standard.synchronize();

        //NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey:"userEmail");
        // send alert with confirmation
         var myAlert = UIAlertController(title: "Alert", message: "Registration Successful! Word Up!", preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default){ action in
            
            self.dismiss(animated: true, completion: nil);
        
        }
        
        
        //////POST!!!!
        //let url:String = "https://jsonplaceholder.typicode.com/todos/1"
        // let userEndpoint = "https://wordup-163921.appspot.com/profiles/"
        
        let todosEndpoint: String = "https://wordup-163921.appspot.com/profiles/"
        let newTodo: [String: Any] = ["last_name": userEmail, "known_lang": "eng", "first_name": userPassword, "learn_lang": "chi", "user_name": userRepeatPassword, "pref_time": "2003-12-31T16:00:00Z"]
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
        }
    
        
    }

    
    func displayMyAlertMessage(userMessage: String) {
        
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style:
            UIAlertActionStyle.default, handler: nil);
        
        myAlert.addAction(okAction);
        self.present(myAlert, animated:true, completion: nil);
        
        
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
