//
//  RegistrationViewController.swift
//  WordUp
//
//  Created by Jacky Kong on 4/29/17.
//  Copyright © 2017 Jacky Kong. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class RegistrationViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var learnLangTextField: UITextField!
    @IBOutlet weak var knownLangTextField: UITextField!
    
    
    var languageTable: [String:String] = [
        "English" : "en", "Chinese" : "zh",
        "Spanish" : "es", "Arabic"  : "ar",
        "Portuguese" : "pt", "Russian" : "ru",
        "French" : "fr", "Japanese" : "ja",
        "Italian" : "it", "Czech" : "cs",
        "German" : "de", "Hebrew" : "he",
        "Hindi" : "hi", "Korean" : "ko",
        "Greek" : "el", "Persian" : "fa",
        "Swahili" : "sw", "Turkish" : "tr",
        "Twi" : "tw", "Urdu" : "ur",
        "Polish" : "pl"]
    
    
    var knownLangOpts = ["English", "Chinese", "Spanish",
                         "Arabic", "Portuguese", "Russian", "French",
                         "Japanese", "Italian", "Czech", "German",
                         "Hebrew", "Hindi", "Korean", "Greek",
                         "Persian", "Swahili", "Turkish",
                         "Twi", "Urdu", "Polish"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return knownLangOpts.count
        }
        if pickerView.tag == 2 {
            return knownLangOpts.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return knownLangOpts[row]
        }
        if pickerView.tag == 2 {
            return knownLangOpts[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            knownLangTextField.text = knownLangOpts[row]
        }
        if pickerView.tag == 2 {
            learnLangTextField.text = knownLangOpts[row]
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScrollView.contentSize.height = 1200
        
        let knownLangPickerView = UIPickerView()
        knownLangTextField.inputView = knownLangPickerView
        knownLangPickerView.delegate = self
        knownLangPickerView.tag = 1
        
        let learnLangPickerView = UIPickerView()
        learnLangTextField.inputView = learnLangPickerView
        learnLangPickerView.delegate = self
        learnLangPickerView.tag = 2
        
      //  print(UserDefaults.standard.string(forKey: defaultsKeys.keyOne))
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapRegisterButton(_ sender: Any) {
        
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = repeatPasswordTextField.text
        let userLearnLang = languageTable[learnLangTextField.text!]
        let userKnownLang = languageTable[knownLangTextField.text!]
        let userNameText = userNameTextField.text
        let userFirstName = firstNameTextField.text
        let userLastName = lastNameTextField.text
        
        
        
        
        // check for empty fields
        //        if (userEmail == "" || userEmail == nil ) {
        //
        //            // display alert! return for now...
        //            displayMyAlertMessage(userMessage: "All fields are required.");
        //            return;
        //        }
        
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
        
        
        
        let todosEndpoint: String = "https://wordup-163921.appspot.com/register/"
        let newTodo: [String: Any] = ["last_name": userLastName, "known_lang": userKnownLang, "first_name": userFirstName, "learn_lang": userLearnLang, "username": userNameText, "password" : userPassword , "email": userEmail ]
        
        print("THAT EMAILLLLLL: " + userEmail!)
        
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo, encoding: JSONEncoding.default).responseJSON { (responseObject) -> Void in
            
            debugPrint(responseObject)
            print(responseObject.result.value)
            //print(response.result.error)
            //print(response.request)  // original URL request
            print(responseObject.response) // HTTP URL response
            
            
            
            if let responseStatus = responseObject.response?.statusCode {
                
                if responseStatus == 400 {
                    print("hey whats up hello")
                    //                    let message = "Username already exists"
                    //                    self.displayMyAlertMessage(userMessage: message)
                    //handle same email error, same user error
                }
                    
                    
                else {
                    // view all cookies
                    print(HTTPCookieStorage.shared.cookies!)
                }
            }
        }
        
        //        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo, encoding: JSONEncoding.default)
        //            .validate()
        //            .responseJSON (completionHandler: {response in
        //                if response.error == nil {
        //                    var statusCode = responseObject.response?.statusCode {
        //                        if statusCode == 400 {
        //                            print ("WE MADE IT HERE")
        //                        }
        //                        else {
        //                            print ("WE ARE HERE")
        //                        }
        //                    }
        //                }
        
        //                if response.result.isSuccess {
        //                    print ("SUCCESS")
        //                }
        //                else if response.result.isFailure {
        //                    print ("FAILURE")
        //                }
        
        
        // display alert with error message
        
        
        
        //        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo, encoding: JSONEncoding.default)
        //            .responseJSON { response in
        ////                if response.error != nil {
        ////                    print ("WE ARE HERE")
        ////                }
        ////                if response.result.isFailure{
        ////                    let httpStatusCode = response.response?.statusCode {
        ////                        if httpStatusCode == 400{
        ////                            message = "Username already exists"
        ////                            displayMyAlertMessage(userMessage: message)
        ////                        }
        ////                    }
        ////                }
        //
        //                //debugPrint(response)
        //                print(response.result.value)
        //                //print(response.result.error)
        //                //print(response.request)  // original URL request
        //                print(response.response) // HTTP URL response
        //                //print(response.data)
        //
        //        }
        //
        
        
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
