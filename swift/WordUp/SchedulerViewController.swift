//
//  SchedulerViewController.swift
//  WordUp
//
//  Created by Jacky Kong on 5/3/17.
//  Copyright © 2017 Jacky Kong. All rights reserved.
//

import UIKit

class SchedulerViewController: UIViewController, UITextFieldDelegate {
    
    // format: YEAR MONTH DAY HOUR MINUTES 
    
    @IBOutlet weak var textField_Date: UITextField!
    
    @IBOutlet weak var viewOne: UIView!
    
    
    var datePicker : UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func showViewsIfPressed(_ sender: Any) {
        
        self.viewOne.isHidden = false
        
    }
    @IBAction func hideViewIfPressed(_ sender: Any) {
        
        self.viewOne.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- textFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUpDate(self.textField_Date)
    }

    
    //MARK:- Function of datePicker
    func pickUpDate(_ textField : UITextField){
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
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
       // dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "yyyy MM dd HH mm"
        let dbDate = dateFormatter1.string(from: datePicker.date)
        
        let prettyFormatter = DateFormatter()
        prettyFormatter.dateFormat = "EEEE, MMM d, HH:mm"
        textField_Date.text = prettyFormatter.string(from: datePicker.date)
        
        textField_Date.resignFirstResponder()
    }
    
    func cancelClick() {
        textField_Date.resignFirstResponder()
    }
    
////    @IBOutlet weak var dateOneTextField: UITextField!
//    
//    var datePicker : UIDatePicker!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    //MARK:- textFiled Delegate
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.pickUpDate(dateOneTextField)
//    }
//
//
//    //MARK:- Function of datePicker
//    func pickUpDate(_ textField : UITextField) {
//        
//        // DatePicker
//        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
//        self.datePicker.backgroundColor = UIColor.white
//        //self.datePicker.datePickerMode = UIDatePickerMode.date
//        self.datePicker.minuteInterval = 30
//        self.datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
//        
//        textField.inputView = self.datePicker
//        
//        // ToolBar
//        let toolBar = UIToolbar()
//        toolBar.barStyle = .default
//        toolBar.isTranslucent = true
//        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
//        toolBar.sizeToFit()
//        
//        // Adding Button ToolBar
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: textField, action:
//            #selector(doneClick))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: textField, action: #selector(cancelClick))
//        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//        textField.inputAccessoryView = toolBar
//    }
//    
//    
//    // MARK:- Button Done and Cancel
//    func doneClick() {
//        let dateFormatter1 = DateFormatter()
//        //dateFormatter1.dateStyle = .medium
//        dateFormatter1.dateFormat = "yyyy MM dd HH mm"
//        dateOneTextField.text = dateFormatter1.string(from: datePicker.date)
//        dateOneTextField.resignFirstResponder()
//    }
//    func cancelClick() {
//        dateOneTextField.resignFirstResponder()
//    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
