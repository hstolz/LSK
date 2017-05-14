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
    
    var userToMatch = [String: AnyObject]()
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
    @IBOutlet weak var SuggestedTimeLabel: UILabel!
    @IBOutlet weak var SuggestedLocationLabel: UILabel!
    
    // subview Scheduled / Pending
    @IBOutlet weak var ScheduledPendingView: UIView!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var ScheduledLabel: UILabel!
   
    
    // function
    @IBAction func MakeMatchButtonTapped(_ sender: Any) {
        
        print("Make Match Button Tapped")
        let defaults = UserDefaults.standard
        let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
        let auth_header = ["Authorization" : "Token " + tokenString]
        
        let endpoint: String = "https://wordup-163921.appspot.com/matches/"
        let i_username = defaults.string(forKey: defaultsKeys.keyOne)! //initiator is current user
        let match_username = self.userToMatch["username"] as! String
        let a_username = match_username
        
        let newTodo: [String: Any] = ["i_username": i_username, "a_username": a_username]
        Alamofire.request(endpoint, method: .post, parameters: newTodo,encoding: JSONEncoding.default, headers: auth_header).validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    print("Matches Validation Successful")
                    self.match = (response.result.value as! NSDictionary) as! [String : AnyObject]

                    let matcher_id = self.userToMatch["id"] as! Int
                    let endpoint: String = "https://wordup-163921.appspot.com/times/\(matcher_id)/"
                    
                    Alamofire.request(endpoint, method: .get, headers: auth_header).validate()
                        .responseJSON { response in
                            
                            switch response.result {
                            case .success:
                                print("Times Validation Successful")
                                self.match = (response.result.value as! NSDictionary) as! [String : AnyObject]
                                let code = self.match["status_code"] as! Int
                                let id = defaults.string(forKey: defaultsKeys.keyThree)!
                                let weInitiated = id as String == "\(self.match["user_id1"] as! Int)"
                                self.switchView(code : code, weInitiated : weInitiated)
                                
                            case .failure(let error):
                                print(error)
                                print("error: times failed")
                            }
                    }
                    
                case .failure(let error):
                    print(error)
                    print("error: no match made")
                }
        }

    }
    
    @IBAction func ScheduleButtonTapped(_ sender: Any) {
        
        print("Schedule Button Tapped")
        let defaults = UserDefaults.standard
        let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
        let auth_header = ["Authorization" : "Token " + tokenString]
        let match_id = self.match["match_id"] as! Int
        let endpoint: String = "https://wordup-163921.appspot.com/matches/\(match_id)/"
        
        let username = defaults.string(forKey: defaultsKeys.keyOne)! //initiator is current user
        let id = defaults.string(forKey: defaultsKeys.keyThree)!
        let weInitiated = id as String == "\(self.match["user_id1"] as! Int)"
        var new_status : String
        if (weInitiated) {
            new_status = "1"
        } else {
            new_status = "2"
        }
        let time_1 = dbDate
        let location = LocationTextField.text!
        
        let parameters: [String: Any] = ["username":username, "new_status":new_status, "time_1":time_1, "location":location]
        
        print("Schedule Button Tapped Parameters: \(parameters)")
        Alamofire.request(endpoint, method: .put, parameters: parameters ,encoding: JSONEncoding.default, headers: auth_header).validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    print("Validation Successful")
                    self.match = (response.result.value as! NSDictionary) as! [String : AnyObject]
                    let code = self.match["status_code"] as! Int
                    let id = defaults.string(forKey: defaultsKeys.keyThree)!
                    let weInitiated = id as String == "\(self.match["user_id1"] as! Int)"
                    self.switchView(code : code, weInitiated : weInitiated)
                    
                case .failure(let error):
                    print(error)
                    print(response.result)
                    print(response.data ?? "No Response Data")
                    print("error: scheduling failed")
                }
        }
        
    }

    @IBAction func AcceptButtonTapped(_ sender: Any) {
        
        print("Accept Button Tapped")
        let defaults = UserDefaults.standard
        let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
        let auth_header = ["Authorization" : "Token " + tokenString]
        
        let match_id = self.match["match_id"] as! Int
        let endpoint: String = "https://wordup-163921.appspot.com/matches/\(match_id)/"
        let username = defaults.string(forKey: defaultsKeys.keyOne)! //initiator is current user
        let new_status : String = "3"
        let stringToDateDF = DateFormatter()
        let dateToStringDF = DateFormatter()
        stringToDateDF.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateToStringDF.dateFormat = "yyyy MM dd HH mm"
        let tempTime = stringToDateDF.date(from: self.match["time_1"] as! String)
        let time = dateToStringDF.string(from: tempTime!)
        let location = self.match["location"] as! String
        
        let parameters: [String: Any] = ["username":username, "new_status":new_status, "time_1":time, "location":location]
        
        print("Accept Button Tapped Parameters: \(parameters)")
        Alamofire.request(endpoint, method: .put, parameters: parameters ,encoding: JSONEncoding.default, headers: auth_header).validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    print("Validation Successful")
                    self.match = (response.result.value as! NSDictionary) as! [String : AnyObject]
                    self.switchView(code : 3, weInitiated : false)
                    
                case .failure(let error):
                    print(error)
                    print(response.result)
                    print(response.data ?? "No Response Data")
                    print("error: matches accept failed")
                }
        }
    }

    @IBAction func RescheduleButtonTapped(_ sender: Any) {
        self.switchView(code : 0, weInitiated : false)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUpDate(self.TimeTextField)
    }
    
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
        toolBar.sizeToFit()
        
        // Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    func doneClick() {
        let storeDateToStringDF = DateFormatter()
        let displayDateToStringDF = DateFormatter()
        storeDateToStringDF.dateFormat = "yyyy MM dd HH mm"
        displayDateToStringDF.dateFormat = "EEEE, MMM d, HH:mm"

        dbDate = storeDateToStringDF.string(from: datePicker.date)
        TimeTextField.text = displayDateToStringDF.string(from: datePicker.date)
        TimeTextField.resignFirstResponder()
    }
    
    func cancelClick() {
        TimeTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MakeMatchView.isHidden = true
        
        if (matchAvailability == 0) { // already matched with this user

            let defaults = UserDefaults.standard
            let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
            let auth_header = ["Authorization" : "Token " + tokenString]
            let matcher_id = self.userToMatch["id"] as! Int
            let endpoint: String = "https://wordup-163921.appspot.com/times/\(matcher_id)/"
            
            Alamofire.request(endpoint, method: .get, headers: auth_header).validate()
                .responseJSON { response in
                    
                    switch response.result {
                    case .success:
                        print("Validation Successful")
                        self.match = (response.result.value as! NSDictionary) as! [String : AnyObject]
                        let code = self.match["status_code"] as! Int
                        let id = defaults.string(forKey: defaultsKeys.keyThree)!
                        let weInitiated = id as String == "\(self.match["user_id1"] as! Int)"
                        self.switchView(code : code, weInitiated : weInitiated)
                        
                    case .failure(let error):
                        print(error)
                        print("ERROR HERE: /times/ endpoint failed")
                    }
            }
            
        }
        
        else { // we have not yet matched with this user
            
            MakeMatchView.isHidden = false
            ScheduleView.isHidden = true
            AcceptRescheduleView.isHidden = true
            ScheduledPendingView.isHidden = true
            
        }
                
        let firstName = self.userToMatch["first_name"] as! String
        let lastName = self.userToMatch["last_name"] as! String
        let fullName = firstName + " " + lastName
        profileUsername.text = fullName
        
        let known_lang_code = self.userToMatch["known_lang"] as! String
        let learn_lang_code = self.userToMatch["learn_lang"] as! String
        let bio_preset = self.userToMatch["bio"] as! String
        profileDescriptionLabel.text = bio_preset
        
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
    }
    
    func switchView(code : Int, weInitiated : Bool) {
       
        if (code == 0) { // ScheduleView
           
            self.ScheduleView.isHidden = false
            self.MakeMatchView.bringSubview(toFront: self.ScheduleView)
            self.MakeMatchView.isHidden = false
            self.AcceptRescheduleView.isHidden = true
            self.ScheduledPendingView.isHidden = true
            self.ScheduleView.isUserInteractionEnabled = true
            
        } else if (code == 3 || (code == 1 &&  weInitiated) ||
                                (code == 2 && !weInitiated)) { // ScheduledPendingView
            
            self.ScheduleView.isHidden = false
            self.MakeMatchView.isHidden = false
            self.AcceptRescheduleView.isHidden = false
            self.ScheduledPendingView.isHidden = false
            self.MakeMatchView.bringSubview(toFront: self.ScheduledPendingView)
            self.ScheduledPendingView.isUserInteractionEnabled = true
            
            let stringToDateDF = DateFormatter()
            let dateToStringDF = DateFormatter()
            stringToDateDF.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateToStringDF.dateFormat = "EEEE, MMM d, HH:mm"
            let d = stringToDateDF.date(from: self.match["time_1"] as! String)
            self.TimeLabel.text = dateToStringDF.string(from: d!)
            
            self.LocationLabel.text = self.match["location"] as? String
            
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
            
            let stringToDateDF = DateFormatter()
            let dateToStringDF = DateFormatter()
            stringToDateDF.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateToStringDF.dateFormat = "EEEE, MMM d, HH:mm"
            let d = stringToDateDF.date(from: self.match["time_1"] as! String)
            self.SuggestedTimeLabel.text = dateToStringDF.string(from: d!)
            
            self.SuggestedLocationLabel.text = self.match["location"] as? String
        
        }
        
    }
    
}

