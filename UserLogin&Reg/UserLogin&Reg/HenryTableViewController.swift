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
        let newTodo: [String: Any] = ["learn_lang": "zh", "i_user_name": "hstolz"]
        
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo, encoding: JSONEncoding.default)
            .response { response in
               // debugPrint(response)
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            

        }
        
//        // GET //
//        //------------------------------------------------------------------//
//        
        print("GETTING")
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
