//
//  UserProfilesViewController.swift
//  WordUp
//
//  Created by Luis Legro on 02/05/17.
//  Copyright © 2017 Jacky Kong. All rights reserved.
//

import UIKit
import Alamofire

class UserProfilesViewController: UIViewController {
    
    var userData = [String: AnyObject]()
    var userId = [String: AnyObject]()
    
    
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
    
    
    @IBOutlet weak var learn_lang: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var known_lang: UILabel!
    @IBOutlet weak var profileDescription: UITextView!
    //@IBOutlet weak var profileUsername: UILabel!
    //    @IBOutlet weak var profileUsername: UILabel!
    //    @IBOutlet weak var profileUsername: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
        let auth_header = ["Authorization" : "Token " + tokenString]
        //        profileUsername.text = self.userId
        print("PRINT THE FOLLOWING")
        //        print(self.userId["username"]!)
        //        newDetail.setQuantity(quantity: "\(quantity)")
        let firstName = self.userId["first_name"] as! String
        let lastName = self.userId["last_name"] as! String
        let fullName = firstName + " " + lastName
        //        print(firstName)
        //        print(lastName)
        //        let fullName = self.userId["first_name"] as! String + self.userId["last_name"] as! String
        profileUsername.text = fullName
        let known_lang_code = self.userId["known_lang"] as! String
        let learn_lang_code = self.userId["learn_lang"] as! String
        let bio_preset = self.userId["bio"] as! String
        profileDescription.text = bio_preset
        //            self.userId["id"]?.stringValue
        
        
        for entry in languageTable {
            if (entry.value == known_lang_code) {
                known_lang.text = entry.key
            }
        }
        
        for entry in languageTable {
            if (entry.value == learn_lang_code) {
                learn_lang.text = entry.key
            }
        }
    
        
        
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

