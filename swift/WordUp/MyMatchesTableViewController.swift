//
//  MyMatchesTableViewController.swift
//  WordUp
//
//  Created by Jacky Kong on 5/6/17.
//  Copyright © 2017 Jacky Kong. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class MyMatchesTableViewController: UITableViewController {

    var TableData = [[String: AnyObject]]() // new int array to save post item
    var MatchTable = [[String: Int]]()
    var classUserName = "";
    var classAuthHeader = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
        let userNameString = defaults.string(forKey: defaultsKeys.keyOne)!
        classUserName = defaults.string(forKey: defaultsKeys.keyOne)!
        let auth_header = ["Authorization" : "Token " + tokenString]
        classAuthHeader = auth_header
        
        getMatches(userNameString: userNameString, auth_header: auth_header)
    }
    
    func showAlert(userMessage:String, title:String) {
        let myAlert = UIAlertController(title: title, message: userMessage,
                                        preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in }
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
    }
    
    func generateMatch(userNameString: String, auth_header: Dictionary<String, String>) {
        
        let endpoint: String = "https://wordup-163921.appspot.com/matches/"
        let parameters: [String: Any] = ["i_username": userNameString ]
        
        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: auth_header).validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    print("Validation Successful")
                    let random_Match = response.result.value as! NSDictionary
                    print(random_Match["username"] as! String)
                    let successMsg = "You matched with " + (random_Match["username"] as! String)
                    self.showAlert(userMessage: successMsg, title: "Congrats!")
                    self.TableData.append(random_Match as! [String : AnyObject])
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print(error)
                    self.showAlert(userMessage: "There are no more people available to match with!", title: "Whoops!")
                }
        }
        
    }
    
    func getMatches(userNameString: String, auth_header: Dictionary<String, String>) {
        
        let userNameEndpoint: String = "https://wordup-163921.appspot.com/matches/"
        Alamofire.request(userNameEndpoint, headers: auth_header).validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    print("Validation Successful")
                    self.TableData = (response.value as! NSArray) as! [[String : AnyObject]]
                    if self.TableData.count == 0 {
                        self.showAlert(userMessage: "You do not have any matches yet!",
                                                   title: "Aww :(")
                    }
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print(error)
                }
                
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.TableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = self.TableData[indexPath.row]

        let first_name = (item["first_name"]) as! String
        let last_name = item["last_name"] as! String
        cell.textLabel?.text = first_name + " " + last_name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showProfileFromMatches") {
            
            let svc = segue.destination as! UserProfilesViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            
            svc.userToMatch = self.TableData[indexPath!.row]
            svc.matchAvailability = 0 
            print (svc.userToMatch)
            
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        let item = self.TableData[row]
        let userId = item["id"]
        print ("User Id: \(String(describing: userId))")
        print("Row Number: \(row)")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
        let userNameString = defaults.string(forKey: defaultsKeys.keyOne)!
        let auth_header = ["Authorization" : "Token " + tokenString]
        
        getMatches(userNameString: userNameString, auth_header: auth_header)
        
        tableView.reloadData()
    }

}
