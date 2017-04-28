//
//  NewDateViewController.swift
//  UserLogin&Reg
//
//  Created by Jacky Kong on 4/27/17.
//  Copyright © 2017 Jacky Kong. All rights reserved.
//

import UIKit

class NewDateViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    @IBAction func datePickerAction(_ sender: Any) {
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd HH mm"
        var strDate = dateFormatter.string(from: myDatePicker.date)
        self.dateLabel.text = strDate
    }
    
    @IBOutlet weak var dateTextField1: UITextField!
    @IBOutlet weak var dateTextField2: UITextField!
    @IBOutlet weak var dateTextField3: UITextField!
    
    @IBAction func editingDate1(_ sender: UITextField) {
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
