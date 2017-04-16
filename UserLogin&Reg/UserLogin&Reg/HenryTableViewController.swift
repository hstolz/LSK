//
//  HenryTableViewController.swift
//  UserLogin&Reg
//
//  Created by Jacky Kong on 4/16/17.
//  Copyright © 2017 Jacky Kong. All rights reserved.
//

import UIKit
import Foundation

class HenryTableViewController: UITableViewController {
    
    
    // GET //
    //------------------------------------------------------------------//
    //    var TableData:Array< String > = Array <String>()
    var TableData = [[String: AnyObject]]() // new int array to save post item
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SHADY POST //
        // =============================================================// 
        
        //////POST!!!!
        print("POSTIN")
        //let url:String = "https://jsonplaceholder.typicode.com/todos/1"
        let userEndpoint = "https://wordup-163921.appspot.com/matches/"
        
        //        let urlURL = URL(string: url)
        
        guard let userUrl = URL(string: userEndpoint) else {
            print ("Error: cannot create url")
            return
        }
        var userUrlRequest = URLRequest(url: userUrl)
        userUrlRequest.httpMethod = "POST"
        let newUser: [String: Any] =
            ["last_name": "stolz", "known_lang": "eng", "first_name": "henry", "learn_lang": "chi", "user_id": 0, "user_name": "hstolz", "pref_time": "2003-12-31T16:00:00Z"]
        //email and password, and repeatpassword are stored
        let jsonUser: Data
        do {
            jsonUser = try JSONSerialization.data(withJSONObject: newUser, options: [])
            userUrlRequest.httpBody = jsonUser
        } catch{
            print ("ERROR: cannot create JSON from new user")
            return
        }
        let session = URLSession.shared
        var task = session.dataTask(with: userUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print ("error calling POST")
                print (error)
                return
            }
            guard let responseData = data else {
                print ("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                print ("GOING INTO DO WHILE")
                
                guard let receivedUser = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The todo is: " + receivedUser.description)
                print(receivedUser["match_id"])
                
                guard let userId = receivedUser["match_id"] as? Int else {
                    print("Could not get email from JSON")
                    return
                }
                print("The ID is: \(userId)")
            } catch  {
//                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
          
        
        
        // GET //
        //------------------------------------------------------------------//
        
        print("GETTIN")
        
        let url:String = "https://wordup-163921.appspot.com/matches/"
        
        let urlRequest = URL(string: url)
        
        var task2 = URLSession.shared.dataTask(with: urlRequest!, completionHandler: {
            (data, response, error) in
            guard error == nil else{
                print("ERROR!!!")
                return
            }
            guard let responseData = data else{
                print("no data~~~~~")
                return
            }
            
            do {
                              //                    print("The title is: " + todoTitle)
                self.TableData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String: AnyObject]]
                
                self.tableView.reloadData()
                
                print ("THIS IS BULLSHIT")
                print (self.TableData)
                
                
            } catch let error as NSError{
                print(error)
            }
            
        }).resume()
   
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        //let item = self.listData[indexPath.row]
        //cell.textLabel?.text = item["Ten"] as? String
        // THATS THE FIELD NAME BOI ie usr id1
        print ("THIS IS CELL:")
        let item = self.TableData[indexPath.row]
        //        cell.textLabel?.text = self.TableData[indexPath.row]
        cell.textLabel?.text = item["match_id"] as? String
//        cell.textLabel?.text = item["user_id2"] as? String
        
        //  let item = self.names
        //        cell.textLabel?.text = item["UserId"] as? String
        //        print(self.listData.count)
        
        
        
        
        return cell
    }
    
    
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
