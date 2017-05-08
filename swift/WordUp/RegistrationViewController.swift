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
    
    @IBOutlet weak var bioTextView: UITextView!
    
    
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
    
    func donePicker() {
        
        learnLangTextField.resignFirstResponder()
        knownLangTextField.resignFirstResponder()
        
    }
    
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
        
        LoginAPI.doTestPrint()
        
        ScrollView.contentSize.height = 1200
        
        // NEW STUFF
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        let knownLangPickerView = UIPickerView()
        knownLangTextField.inputView = knownLangPickerView
        knownLangTextField.inputAccessoryView = toolBar
        knownLangPickerView.delegate = self
        knownLangPickerView.tag = 1
        
        let learnLangPickerView = UIPickerView()
        learnLangTextField.inputView = learnLangPickerView
        learnLangTextField.inputAccessoryView = toolBar
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
        let userBio = bioTextView.text!
        
        
        
        
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
        let newTodo: [String: Any] = ["last_name": userLastName, "known_lang": userKnownLang, "first_name": userFirstName, "learn_lang": userLearnLang, "username": userNameText, "password" : userPassword , "email": userEmail, "bio": userBio]
        
        
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo, encoding: JSONEncoding.default).validate().responseData { (responseObject) -> Void in
            
            switch responseObject.result {
            case .success:
                print("Successful")
                
                let defaults = UserDefaults.standard
                
                defaults.set(userNameText, forKey: defaultsKeys.keyOne)
                
                defaults.set(userPassword, forKey: defaultsKeys.keyTwo)
                
                let userName = defaults.string(forKey: defaultsKeys.keyOne)
                print (userName!)
                let password = defaults.string(forKey: defaultsKeys.keyTwo)
                print (password!)
                
                LoginAPI.doLogin(userNameString: userName!, userPasswordString: password!)
                LoginAPI.doGetToken(userNameString: userName!, userPasswordString: password!)

                self.performSegue(withIdentifier: "registrationSuccessSegue", sender: self)
                
            case .failure(let error):
                print(error)
                print(responseObject.data)
                print(responseObject.value)
                self.displayMyAlertMessage(userMessage: "Error Registering, Please try again. If you are already registered, please login!")
                
                print("HEY WHATS UP HELLO, SOMETHING IS WRONG")
            }
            
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
