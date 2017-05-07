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
        
        print("THAT GOOD KUSH: THE AUTH HEADER")
        print(auth_header)
        
        
        //      generateMatch(userNameString: userNameString, auth_header: auth_header)
        
        getMatches(userNameString: userNameString, auth_header: auth_header)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // Alerts!
    func displayMyAlertMessage(userMessage:String, title:String)
    {
        
        let myAlert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
        
    }
    
    // Match Generating Function
    func generateMatch(userNameString: String, auth_header: Dictionary<String, String>) {
        
        
        //GENERATE MATCH
        let todosEndpoint: String = "https://wordup-163921.appspot.com/matches/"
        
        let newTodo: [String: Any] = ["i_username": userNameString ]
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,encoding: JSONEncoding.default, headers: auth_header).validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    print("Validation Successful")
                    print(response.result.value as! NSDictionary)
                    let random_Match = response.result.value as! NSDictionary
                    print(random_Match["username"] as! String)
                    let successMsg = "You matched with " + (random_Match["username"] as! String)
                    self.displayMyAlertMessage(userMessage: successMsg, title: "Congrats!")
                    
                    self.TableData.append(random_Match as! [String : AnyObject])
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print(error)
                    print("ERROR HERE:")
                    print("AINT NO BODY WANNA MATCH WITH YOU")
                    self.displayMyAlertMessage(userMessage: "There are no more people available to match with!", title: "Whoops!")
                }
                
                //                print(response.response) // HTTP URL response
                //                //print("THIS IS THE DATA")
                //                print(response.data!)     // server data
                //                print("THE POST RESPONSE JSON?")
                //                print(response.result.value)
                
                
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
                        self.displayMyAlertMessage(userMessage: "You do not have any matches yet!", title: "Aww :(")
                    }
                    
                    //  print ("THIS IS THE MATCH ID!!!!!!")
                    print (self.TableData)
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print(error)
                    print("HEY WHATS UP HELLO, SOMETHING IS WRONG")
                }
                
                // print response as string for debugging, testing, etc.
                // print(response.result.value as! NSArray)
                // print(response.result.value as! NSDictionary)
                print(response.result.error)
                print(response.request)  // original URL request
                print(response.response) // HTTP URL response
                print(response.data)     // server data
                
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return self.listData.count
        return self.TableData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        let item = self.TableData[indexPath.row]
        
        print ("THAT MATCH_ID THO")
        var first_name = (item["first_name"]) as! String
        var last_name = item["last_name"] as! String
        print (first_name + last_name)
        cell.textLabel?.text = "You matched with " + first_name + " " + last_name
        
        return cell
    }
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
