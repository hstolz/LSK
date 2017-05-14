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
        
        ScrollView.contentSize.height = 1200
        
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        if (userPassword != userRepeatPassword) {
            showAlert(userMessage: "Passwords do not match.", title: "Error:");
            return;
        }
        
        UserDefaults.standard.set(userEmail, forKey:"userEmail");
        UserDefaults.standard.set(userEmail, forKey:"userPassword");
        UserDefaults.standard.synchronize();
        
        let endpoint: String = "https://wordup-163921.appspot.com/register/"
        let parameters: [String: Any] = ["last_name": userLastName!, "known_lang": userKnownLang!, "first_name": userFirstName!, "learn_lang": userLearnLang!, "username": userNameText!, "password" : userPassword! , "email": userEmail!, "bio": userBio]
        
        print("Registration Parameters: \(parameters)")
        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate()
            .responseData { response in
            
            switch response.result {
            case .success:
                
                let defaults = UserDefaults.standard
                defaults.set(userNameText, forKey: defaultsKeys.keyOne)
                defaults.set(userPassword, forKey: defaultsKeys.keyTwo)
                let userName = defaults.string(forKey: defaultsKeys.keyOne)
                let password = defaults.string(forKey: defaultsKeys.keyTwo)
                
                let endpoint: String = "https://wordup-163921.appspot.com/login/"
                let parameters: [String: Any] = ["username": userName!, "password": password!]
                
                print("Login Parameters: \(parameters)")
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
                        let parameters: [String: Any] = ["username": userName!, "password": password!]
                        
                        print("Token Parameters: \(parameters)")
                        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate()
                            .responseJSON { response in
                                
                            switch response.result {
                            case .success:
                                
                                let tokenDict = (response.value as! NSDictionary) as! [String : String]
                                defaults.set(tokenDict["token"], forKey: defaultsKeys.tokenKey)
                                        
                                self.performSegue(withIdentifier: "registrationSuccessSegue",
                                                  sender: self)
                                
                            case .failure(let error):
                                print(error)
                            }
                        }
                            
                    case .failure(let error):
                        print(error)
                    }
            }
                
            case .failure(let error):
                print(error)
                print(response.data!)
                print(response.value!)
                self.showAlert(userMessage: "Could not register, please try again. If you are already registered, please login!", title: "Error")
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
    
}
