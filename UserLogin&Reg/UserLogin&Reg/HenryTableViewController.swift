//
//  HenryTableViewController.swift
//  UserLogin&Reg
//
//  Created by Jacky Kong on 4/16/17.
//  Copyright © 2017 Jacky Kong. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON


class HenryTableViewController: UITableViewController {
    
    
    // GET //
    //------------------------------------------------------------------//
    //    var TableData:Array< String > = Array <String>()
    var TableData = [[String: AnyObject]]() // new int array to save post item
    var MatchTable = [[String: Int]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SHADY POST //
        // =============================================================// 
    
        print("POSTING NOW")
        
        let todosEndpoint: String = "https://wordup-163921.appspot.com/matches/"
        let newTodo: [String: Any] = ["learn_lang": "chi", "i_user_name": "hstolz"]
        
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo, encoding: JSONEncoding.default)
            .response { response in
               // debugPrint(response)
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            

        }
        //let url:String = "https://jsonplaceholder.typicode.com/todos/1"
        // let userEndpoint = "https://wordup-163921.appspot.com/matches/"
        
        //        let urlURL = URL(string: url)
//        guard let userUrl = URL(string: userEndpoint) else {
//            print ("Error: cannot create url")
//            return
//        }
//        
//        print("Make the URL reqest")
//        var userUrlRequest = URLRequest(url: userUrl)
//        userUrlRequest.httpMethod = "POST"
//        let newUser: [String: Any] =
//            ["last_name": "stolz", "known_lang": "eng", "first_name": "henry", "learn_lang": "chi", "user_id": 0, "user_name": "hstolz", "pref_time": "2003-12-31T16:00:00Z"]
        //email and password, and repeatpassword are stored
        
        // NEW POST
        
//        let userEndpoint: String = "https://wordup-163921.appspot.com/matches/"
//        guard let userURL = URL(string: userEndpoint) else {
//            print("Error: cannot create URL")
//            return
//        }
//        var todosUrlRequest = URLRequest(url: userURL)
//        todosUrlRequest.httpMethod = "POST"
//        let newTodo: [String: Any] =
//            ["last_name": "stolz", "known_lang": "eng", "first_name": "henry", "learn_lang": "chi", "user_id": 0, "user_name": "hstolz", "pref_time": "2003-12-31T16:00:00Z"]
//        
//        let jsonTodo: Data
//        do {
//            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
//            todosUrlRequest.httpBody = jsonTodo
//        } catch {
//            print("Error: cannot create JSON from todo")
//            return
//        }
//        
//        let session = URLSession.shared
//        let task = session.dataTask(with: todosUrlRequest) { _, _, _ in }
//        task.resume()
//        
//        print ("gottem!")
        
//        let jsonUser: Data
//        do {
//            jsonUser = try JSONSerialization.data(withJSONObject: newUser, options: [])
//            userUrlRequest.httpBody = jsonUser
//        } catch{
//            print ("ERROR: cannot create JSON from new user")
//            return
//        }
//        
//        print("are we even here?")
//        
//        let session = URLSession.shared
//        var task = session.dataTask(with: userUrlRequest) {
//            (data, response, error) in
//            guard error == nil else {
//                print ("error calling POST")
//                print (error)
//                return
//            }
//            guard let responseData = data else {
//                print ("Error: did not receive data")
//                return
//            }
//            
//        print("about to go to do while")
//        // parse the result as JSON, since that's what the API provides
//        do {
//            print ("GOING INTO DO WHILE")
//                
//            guard let receivedUser = try JSONSerialization.jsonObject(with: responseData,
//                                                                          options: []) as? [String: Any]
//                else {
//                    print("Could not get JSON from responseData as dictionary")
//                    return
//                }
//                
//            print("The todo is: " + receivedUser.description)
//            print(receivedUser["match_id"])
//                
//            guard let userId = receivedUser["match_id"] as? Int else {
//                print("Could not get email from JSON")
//                return
//                }
//                
//            print("The ID is: \(userId)")
//            }
//            
//        catch  {
//            print("error parsing response from POST on /todos")
//            return
//        }
//    }
//    task.resume()
//          
        
        
//        // GET //
//        //------------------------------------------------------------------//
//        
//        print("GETTING")
//        
//        let url:String = "https://wordup-163921.appspot.com/matches/"
        
        let todoEndpoint: String = "https://wordup-163921.appspot.com/matches/"
        Alamofire.request(todoEndpoint)
            .responseJSON { response in
                // print response as string for debugging, testing, etc.
                print(response.result.value as! NSArray)
                print(response.result.error)
                print(response.request)  // original URL request
                print(response.response) // HTTP URL response
                print(response.data)     // server data

                
                self.TableData = (response.value as! NSArray) as! [[String : AnyObject]]
                print (self.TableData)
                self.tableView.reloadData()
                
        }

//        
//        let urlRequest = URL(string: url)
//        
//        var task2 = URLSession.shared.dataTask(with: urlRequest!, completionHandler: {
//            (data, response, error) in
//            guard error == nil else{
//                print("ERROR!!!")
//                return
//            }
//            guard let responseData = data else{
//                print("no data~~~~~")
//                return
//            }
//            
//            
//            do {
//        
//                self.TableData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String: AnyObject]]
//
//                self.tableView.reloadData()
//                
//                print ("THIS IS BULLSHIT")
//                print (self.TableData)
//                
//            } catch let error as NSError{
//                print(error)
//            }
//            
//        }).resume()
   
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
                let item = self.TableData[indexPath.row]
     
        print ("THAT MATCH_ID THO")
        var that_int = (item["match_id"]) as! Int
        print (that_int)
        cell.textLabel?.text = "match id is: " + String(describing: that_int) + " yay! you got henry :)"
        
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
