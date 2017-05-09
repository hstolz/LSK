//
//  UserProfilesViewController.swift
//  WordUp
//
//  Created by Luis Legro on 02/05/17.
//  Copyright © 2017 Jacky Kong. All rights reserved.
//

import UIKit
import Alamofire

class UserProfilesViewController: UIViewController, UITextFieldDelegate {
    
    var userData = [String: AnyObject]()
    var userId = [String: AnyObject]()
    //var emptyDictionary: [Int:Int] = [:]
    var match: [String: AnyObject] = [:]
    var matchAvailability = Int()
    var datePicker : UIDatePicker!
    var dbDate : String = ""
    
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
    @IBOutlet weak var profileDescriptionLabel: UILabel!
    
    // subview Match
    @IBOutlet weak var MakeMatchView: UIView!
    @IBOutlet weak var MakeMatchButton: UIButton!
    
    // subview Schedule
    @IBOutlet weak var ScheduleView: UIView!
    @IBOutlet weak var ScheduleButton: UIButton!
    @IBOutlet weak var LocationTextField: UITextField!
    @IBOutlet weak var TimeTextField: UITextField!
    
    // subview Accept / Reschedule
    @IBOutlet weak var AcceptRescheduleView: UIView!
    @IBOutlet weak var AcceptButton: UIButton!
    @IBOutlet weak var RescheduleButton: UIButton!
    @IBOutlet weak var SuggestedTime: UILabel!
    @IBOutlet weak var SuggestedLocation: UILabel!
    
    // subview Scheduled / Pending
    @IBOutlet weak var ScheduledPendingView: UIView!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var ScheduledLabel: UILabel!
   
    
    // function
    @IBAction func MakeMatchButtonTapped(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
        let auth_header = ["Authorization" : "Token " + tokenString]
        
        let todosEndpoint: String = "https://wordup-163921.appspot.com/matches/"
        let i_username = defaults.string(forKey: defaultsKeys.keyOne)! //initiator is current user
        let match_username = self.userId["username"] as! String
        let a_username = match_username
        
        let newTodo: [String: Any] = ["i_username": i_username, "a_username": a_username]
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,encoding: JSONEncoding.default, headers: auth_header).validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    print("Validation Successful")
                    self.ScheduleView.isHidden = false
                    self.MakeMatchView.bringSubview(toFront: self.ScheduleView)
                    self.MakeMatchView.isHidden = false
                    self.AcceptRescheduleView.isHidden = true
                    self.ScheduledPendingView.isHidden = true
                    
                case .failure(let error):
                    print(error)
                    print("ERROR HERE:")
                    print("AINT NO BODY WANNA MATCH WITH YOU")
                }
        }

    }
    
    @IBAction func ScheduleButtonTapped(_ sender: Any) {
        print("schedule button tapped")
        let defaults = UserDefaults.standard
        let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
        let auth_header = ["Authorization" : "Token " + tokenString]
        
        let match_username = self.match["match_id"] as! Int
        let todosEndpoint: String = "https://wordup-163921.appspot.com/matches/\(match_username)/"
        let username = defaults.string(forKey: defaultsKeys.keyOne)! //initiator is current user
        let weInitiated = match_username == match["user_id2"] as! Int
        var new_status : String
        if (weInitiated) {
            new_status = "1"
        } else {
            new_status = "2"
        }
        let time_1 = dbDate
        let location = LocationTextField.text!
        
        let newTodo: [String: Any] = ["username":username, "new_status":new_status, "time_1":time_1, "location":location]
        
        print("OUR JSON")
        print(newTodo)
        Alamofire.request(todosEndpoint, method: .put, parameters: newTodo,encoding: JSONEncoding.default, headers: auth_header).validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    print("Validation Successful")
                    self.match = (response.result.value
                        as! NSDictionary) as! [String : AnyObject]
                    let code = self.match["status_code"] as! Int
                    let weInitiated = match_username == self.match["user_id2"] as! Int
                    self.switchView(code : code, weInitiated : weInitiated)
                    
                case .failure(let error):
                    print(error)
                    print(response.result)
                    print(response.data)
                    debugPrint(response)
                    print("ERROR HERE:")
                    print("/matches/ put fucked up")
                }
        }
        
    }

    @IBAction func AcceptButtonTapped(_ sender: Any) {
        print("accept button tapped")
        let defaults = UserDefaults.standard
        let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
        let auth_header = ["Authorization" : "Token " + tokenString]
        
        let match_username = self.match["match_id"] as! Int
        let todosEndpoint: String = "https://wordup-163921.appspot.com/matches/\(match_username)/"
        let username = defaults.string(forKey: defaultsKeys.keyOne)! //initiator is current user
        var new_status : String = "3"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let d = dateFormatter1.date(from: self.match["time_1"] as! String)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy MM dd HH mm"
        let time_1 = dateFormatter2.string(from: d!)

        let location = self.match["location"] as! String
        
        let newTodo: [String: Any] = ["username":username, "new_status":new_status, "time_1":time_1, "location":location]
        
        print("OUR JSON")
        print(newTodo)
        Alamofire.request(todosEndpoint, method: .put, parameters: newTodo,encoding: JSONEncoding.default, headers: auth_header).validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    print("Validation Successful")
                    self.match = (response.result.value
                        as! NSDictionary) as! [String : AnyObject]
                    self.switchView(code : 3, weInitiated : false)
                    
                case .failure(let error):
                    print(error)
                    print(response.result)
                    print(response.data)
                    debugPrint(response)
                    print("ERROR HERE:")
                    print("/matches/ put fucked up")
                }
        }
    }

    @IBAction func RescheduleButtonTapped(_ sender: Any) {
        self.switchView(code : 0, weInitiated : false)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUpDate(self.TimeTextField)
        print("hello")
    }
    
    //MARK:- Function of datePicker
    func pickUpDate(_ textField : UITextField){
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        self.datePicker.minuteInterval = 15
        self.datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SchedulerViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SchedulerViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    // MARK:- Button Done and Cancel
    func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "yyyy MM dd HH mm"
        dbDate = dateFormatter1.string(from: datePicker.date)
        print(dbDate)
        
        let prettyFormatter = DateFormatter()
        prettyFormatter.dateFormat = "EEEE, MMM d, HH:mm"
        TimeTextField.text = prettyFormatter.string(from: datePicker.date)
        
        TimeTextField.resignFirstResponder()
    }
    
    func cancelClick() {
        TimeTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MakeMatchView.isHidden = true
        
        if (matchAvailability == 0) {
            // already matched with user ...
            let defaults = UserDefaults.standard
            let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
            let auth_header = ["Authorization" : "Token " + tokenString]
            
            let match_username = self.userId["id"] as! Int
            print(match_username)
            let todosEndpoint: String = "https://wordup-163921.appspot.com/times/\(match_username)/"
            print(todosEndpoint)
            
            Alamofire.request(todosEndpoint, method: .get, headers: auth_header).validate()
                .responseJSON { response in
                    
                    switch response.result {
                    case .success:
                        print("Validation Successful")
                        self.match = (response.result.value
                            as! NSDictionary) as! [String : AnyObject]
                        let code = self.match["status_code"] as! Int
                        let weInitiated = match_username == self.match["user_id2"] as! Int
                        self.switchView(code : code, weInitiated : weInitiated)
                        
                    case .failure(let error):
                        print(error)
                        print("ERROR HERE:")
                        print("/times/ endpoint fucked up")
                    }
            }
            
        }
        
        else {
            //  show match me button 
            MakeMatchView.isHidden = false
            ScheduleView.isHidden = true
            AcceptRescheduleView.isHidden = true
            ScheduledPendingView.isHidden = true
        }
        
        
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
        //profileDescription.text = bio_preset
        profileDescriptionLabel.text = bio_preset
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
    
    func switchView(code : Int, weInitiated : Bool) {
        if (code == 0) { // ScheduleView
            self.ScheduleView.isHidden = false
            self.MakeMatchView.bringSubview(toFront: self.ScheduleView)
            self.MakeMatchView.isHidden = false
            self.AcceptRescheduleView.isHidden = true
            self.ScheduledPendingView.isHidden = true
            self.ScheduleView.isUserInteractionEnabled = true
        } else if (code == 3 || (code == 1 && weInitiated) || (code == 2 && !weInitiated)) { // ScheduledPendingView
            self.ScheduleView.isHidden = false
            self.MakeMatchView.isHidden = false
            self.AcceptRescheduleView.isHidden = false
            self.ScheduledPendingView.isHidden = false
            self.MakeMatchView.bringSubview(toFront: self.ScheduledPendingView)
            self.ScheduledPendingView.isUserInteractionEnabled = true
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let d = dateFormatter1.date(from: self.match["time_1"] as! String)
            print("Self Match Time_1")
            print(self.match["time_1"])
            print(d!)
            
            let prettyFormatter = DateFormatter()
            prettyFormatter.dateFormat = "EEEE, MMM d, HH:mm"
            self.TimeLabel.text = prettyFormatter.string(from: d!)
            self.LocationLabel.text = self.match["location"] as! String
            
            if (code == 3) {
                self.ScheduledLabel.text = "Scheduled"
            } else {
                self.ScheduledLabel.text = "Pending"
            }
            
        } else { // AcceptRescheduleView
            self.ScheduleView.isHidden = false
            self.MakeMatchView.isHidden = false
            self.AcceptRescheduleView.isHidden = false
            self.ScheduledPendingView.isHidden = true
            self.MakeMatchView.bringSubview(toFront: self.AcceptRescheduleView)
            self.AcceptRescheduleView.isUserInteractionEnabled = true
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let d = dateFormatter1.date(from: self.match["time_1"] as! String)
            print("Self Match Time_1")
            print(self.match["time_1"])
            print(d!)
            
            let prettyFormatter = DateFormatter()
            prettyFormatter.dateFormat = "EEEE, MMM d, HH:mm"
            self.SuggestedTime.text = prettyFormatter.string(from: d!)
            self.SuggestedLocation.text = self.match["location"] as! String
        }
        
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

