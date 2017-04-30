//
//  TestMatchTableViewController.swift
//  WordUp
//
//  Created by Jacky Kong on 4/29/17.
//  Copyright © 2017 Jacky Kong. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class TestMatchTableViewController: UITableViewController {
    
    var TableData = [[String: AnyObject]]() // new int array to save post item
    var MatchTable = [[String: Int]]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
        
        let userNameString = defaults.string(forKey: defaultsKeys.keyOne)!
        
        let auth_header = ["Authorization" : "Token " + tokenString]
        
        print("THAT GOOD KUSH: THE AUTH HEADER")
        print(auth_header)
        
        
        generateMatch(userNameString: userNameString, auth_header: auth_header)
        
        getMatches(userNameString: userNameString, auth_header: auth_header)
        
        
        
        
        
        

        
        //        // GET //
        //        //------------------------------------------------------------------//
        //
        //print("GETTING")
        //
        //        let url:String = "https://wordup-163921.appspot.com/matches/"
        
//        //GETTING MATCH THAT WAS JUST GENERATED
//        let myProfile: [String: Any] = ["username": userNameString]
//        print("THIS SHOULD BE THE USERNAME")
//        print(myProfile["username"]!)
        let todoEndpoint: String = "https://wordup-163921.appspot.com/matches/"
////        Alamofire.request(todoEndpoint, parameters: myProfile, encoding: JSONEncoding.default, headers: auth_header)
//        Alamofire.request(todoEndpoint, method: .get, parameters: myProfile, encoding: JSONEncoding.default, headers: auth_header)
//            .responseJSON { response in
//                
//                if let httpError = response.error {
//                    print("ERROR HERE:")
//                    let statusCode = httpError._code
//                    print(statusCode)
//                } else {
//                    print("Hey Whats Up Hello, why are we here?")
//                }
//                // print response as string for debugging, testing, etc.
//                //print(response.result.value as! NSArray)
//                //debugPrint(response)
//                print(response.result.value)
////                print(response.result.error)
////                print(response.request)  // original URL request
////                print(response.response) // HTTP URL response
////                print(response.data)     // server data
//                
//                
////                self.TableData = (response.value as! NSArray) as! [[String : AnyObject]]
//                print ("-------------------------THIS IS THE DATA WE HAVE!!!!!!")
////                print (self.TableData[0]["user_id2"])
////                for index in self.TableData {
////                    for (key,value) in index {
////                        if key == "user_id2" {
////                            print (value)
////                        }
////                    }
////                }
////                
////                
//                self.tableView.reloadData()
////
//        }
        
        
        
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    func generateMatch(userNameString: String, auth_header: Dictionary<String, String>) {
        
        // SHADY POST //
        // =============================================================//
        
        print("POSTING NOW")
        //GENERATE MATCH
        let todosEndpoint: String = "https://wordup-163921.appspot.com/matches/"
        
        let newTodo: [String: Any] = ["i_username": userNameString ]
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,encoding: JSONEncoding.default, headers: auth_header)
            .responseJSON { response in
                //debugPrint(response)
                //print(response.request)  // original URL request
                //print(response.response) // HTTP URL response
                //print("THIS IS THE DATA")
                print(response.data!)     // server data
                print("THE POST RESPONSE JSON?")
                print(response.result.value as! NSDictionary)
        }
        
        
    }
    
    func getMatches(userNameString: String, auth_header: Dictionary<String, String>) {
        
        let userNameEndpoint: String = "https://wordup-163921.appspot.com/matches/"
        Alamofire.request(userNameEndpoint, headers: auth_header)
            .responseJSON { response in
                // print response as string for debugging, testing, etc.
                print(response.result.value as! NSArray)
                print(response.result.error)
                print(response.request)  // original URL request
                print(response.response) // HTTP URL response
                print(response.data)     // server data
                
                
                self.TableData = (response.value as! NSArray) as! [[String : AnyObject]]
                print ("THIS IS THE MATCH ID!!!!!!")
                print (self.TableData)
                self.tableView.reloadData()
                
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
