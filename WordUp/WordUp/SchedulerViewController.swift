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
    
    @IBOutlet weak var dateOneTextField: UITextField!
    
    @IBOutlet weak var dateTwoTextField: UITextField!
    
    @IBOutlet weak var dateThreeTextField: UITextField!
    
    
    var datePicker : UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        
        let dateOnePickerView = UIDatePicker()
        dateOneTextField.inputView = dateOnePickerView
        dateOneTextField.inputAccessoryView = toolBar
        //dateOnePickerView.delegate = self
        dateOnePickerView.tag = 1
        dateOneTextField.tag = 1
        
        
        let dateTwoPickerView = UIDatePicker()
        dateTwoTextField.inputView = dateOnePickerView
        dateTwoTextField.inputAccessoryView = toolBar
        //dateTwoPickerView.delegate = self
        dateTwoPickerView.tag = 2
        dateOneTextField.tag = 2
    
        
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- textFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            self.pickUpDate(textField)
        } else if textField.tag == 2 {
            self.pickUpDate(textField)
        }
        
    }
    
    // MARK:- Button Done and Cancel
    func doneClick(_ sender : UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd HH mm"
        if sender.tag == 1 {
            dateOneTextField.text = dateFormatter.string(from: datePicker.date)
            dateOneTextField.resignFirstResponder()
        } else if sender.tag == 2 {
            dateTwoTextField.text = dateFormatter.string(from: datePicker.date)
            dateTwoTextField.resignFirstResponder()
        }
    }
    
    func cancelClick(_ sender : UIBarButtonItem) {
        if sender.tag == 1 {
            dateOneTextField.resignFirstResponder()
        } else if sender.tag == 2 {
            dateTwoTextField.resignFirstResponder()
        }
    }
    
    //MARK:- Function of datePicker
    func pickUpDate(_ textField : UITextField) {
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        //self.datePicker.datePickerMode = UIDatePickerMode.date
        self.datePicker.minuteInterval = 30
        self.datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        self.datePicker.tag = textField.tag
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: textField, action:
            #selector(doneClick(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: textField, action: #selector(cancelClick(_:)))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        doneButton.tag = textField.tag
        cancelButton.tag = textField.tag
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
