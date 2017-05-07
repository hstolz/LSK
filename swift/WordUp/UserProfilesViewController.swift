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
    
    
    @IBOutlet weak var profileUsername: UILabel!
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
        //            self.userId["id"]?.stringValue
        
        
    
        
        
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
