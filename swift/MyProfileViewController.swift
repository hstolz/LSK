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


    @IBOutlet weak var profileUserName: UILabel!
    @IBOutlet weak var knownLangLabel: UILabel!
    @IBOutlet weak var learnLangLabel: UILabel!
    //@IBOutlet weak var profileUserDescription: UITextView!
    @IBOutlet weak var profileUserDescriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: defaultsKeys.keyOne)
        let known_lang_code = defaults.string(forKey: defaultsKeys.keyFour)
        let learn_lang_code = defaults.string(forKey: defaultsKeys.keyFive)
        let bio_preset = defaults.string(forKey: defaultsKeys.keySix)
        
        profileUserDescriptionLabel.text = bio_preset
        
        for entry in languageTable {
            if (entry.value == known_lang_code!) {
                knownLangLabel.text = entry.key
            }
        }
        
        for entry in languageTable {
            if (entry.value == learn_lang_code!) {
                learnLangLabel.text = entry.key
            }
        }

        profileUserName.text = userName
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
                
        // Post With Token
        let endpoint: String = "https://wordup-163921.appspot.com/logout/"
        let parameters: [String: Any] = [:]
        let defaults = UserDefaults.standard
        let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
        let auth_header = ["Authorization" : "Token " + tokenString]
        
        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: auth_header).validate()
            .responseData { response in
                
                switch response.result {
                case .success:
                    
                    // Clear Global Variables
                    defaults.removeObject(forKey: defaultsKeys.keyOne)
                    defaults.removeObject(forKey: defaultsKeys.keyTwo)
                    defaults.removeObject(forKey: defaultsKeys.tokenKey)
                    defaults.removeObject(forKey: defaultsKeys.keyThree)
                    defaults.removeObject(forKey: defaultsKeys.keyFour)
                    defaults.removeObject(forKey: defaultsKeys.keyFive)
                    defaults.removeObject(forKey: defaultsKeys.keySix)
                    defaults.synchronize()
                    
                    self.performSegue(withIdentifier: "LogoutSegue", sender: self)
                    
                case .failure(let error):
                    print("Logout Failed: \(error)")
                    debugPrint(response)
                    self.showAlert(userMessage: "Failed to logout. Please try again.", title: "Error")
                }
                
        }
        
    }
    
    func showAlert(userMessage:String, title:String) {
        let myAlert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in }
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
