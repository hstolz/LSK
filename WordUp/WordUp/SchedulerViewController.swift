//
//  SchedulerViewController.swift
//  WordUp
//
//  Created by Jacky Kong on 5/3/17.
//  Copyright © 2017 Jacky Kong. All rights reserved.
//

import UIKit

class SchedulerViewController: UIViewController {
    
    
    @IBOutlet weak var dateOneTextField: UITextField!
    
    @IBOutlet weak var dateTwoTextField: UITextField!
    
    @IBOutlet weak var dateThreeTextField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func editDateOne(_ sender: Any) {
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
