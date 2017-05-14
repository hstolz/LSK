//
//  SearchTableViewController.swift
//  WordUp
//
//  Created by Jacky Kong on 5/7/17.
//  Copyright © 2017 Jacky Kong. All rights reserved.
//

import UIKit
import Alamofire

class SearchTableViewController: UITableViewController {

    var listData = [[String: AnyObject]]()
    var names = [String]()
    var TableData = [[String: AnyObject]]()
    var newMatchName = ""
    var classUserName = "";
    var classAuthHeader = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
        let defaults = UserDefaults.standard
        let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
        let auth_header = ["Authorization" : "Token " + tokenString]
        
        classUserName = defaults.string(forKey: defaultsKeys.keyOne)!
        classAuthHeader = auth_header
        
        let endpoint: String = "https://wordup-163921.appspot.com/profiles/"
        Alamofire.request(endpoint, headers: auth_header).validate()
            .responseJSON { response in
            switch response.result {
                
            case .success:
                self.TableData = (response.value as! NSArray) as! [[String : AnyObject]]
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
                self.showAlert(userMessage: "Could not get results. Try again later", title: "Error")
            }
                
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    @IBAction func randomMatchButtonPressed(_ sender: Any) {
        
        let endpoint: String = "https://wordup-163921.appspot.com/matches/"
        
        let parameters: [String: Any] = ["i_username": classUserName]
        Alamofire.request(endpoint, method: .post, parameters: parameters ,encoding: JSONEncoding.default, headers: classAuthHeader).validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    let random_Match = response.result.value as! NSDictionary
                    let successMsg = "You matched with " + (random_Match["username"] as! String)
                    self.showAlert(userMessage: successMsg, title: "Congrats!")
                    self.newMatchName = random_Match["username"] as! String
                    self.tabBarController?.selectedIndex = 1
                    
                case .failure(let error):
                    print(error)
                    self.showAlert(userMessage: "There are no more people available to match with!", title: "Whoops!")
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.TableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = self.TableData[indexPath.row]
        let fname = item["first_name"] as! String
        let lname = item["last_name"] as! String
        cell.textLabel?.text = fname + " " + lname
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showProfileDetail") {
            let svc = segue.destination as! UserProfilesViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            svc.userToMatch = self.TableData[indexPath!.row]
            svc.matchAvailability = 1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let endpoint: String = "https://wordup-163921.appspot.com/profiles/"
        
        Alamofire.request(endpoint, headers: classAuthHeader).validate()
            .responseJSON { response in
            switch response.result {
                
            case .success:
                self.TableData = (response.value as! NSArray) as! [[String : AnyObject]]
                self.tableView.reloadData()
                    
            case .failure(let error):
                print(error)
                self.showAlert(userMessage: "Could not get results. Try again later", title: "Error")
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
