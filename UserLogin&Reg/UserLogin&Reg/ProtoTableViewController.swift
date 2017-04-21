//
//  ProtoTableViewController.swift
//  prototype_0
//
//  Created by Jacky Kong on 4/15/17.
//  Copyright © 2017 Jacky Kong. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class ProtoTableViewController: UITableViewController {
    
    var listData = [[String: AnyObject]]()
    
    var names = [String]()
    
    //    var TableData:Array< String > = Array <String>()
    var TableData = [[String: AnyObject]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let todoEndpoint: String = "https://wordup-163921.appspot.com/profiles/"
        Alamofire.request(todoEndpoint)
            .responseJSON { response in
                // print response as string for debugging, testing, etc.
                print(response.result.value as! NSArray)
                print(response.result.error)
                
                self.TableData = (response.value as! NSArray) as! [[String : AnyObject]]
                print (self.TableData)
                self.tableView.reloadData()
//                let restaurants = response.result.value
//                
//                guard let results = restaurants as? NSArray
//                    else {
//                        print ("cannot find key location in \(restaurants)")
//                        return
//                }
//                
//                for r in results {
//                    self.TableData.append(r)
//                    self.tableView.reloadData()
//                }
                
                
        }
        
//        //let url:String = "https://jsonplaceholder.typicode.com/todos/1"
//        let url:String = "https://wordup-163921.appspot.com/profiles/"
//        
//        let urlRequest = URL(string: url)
//        
//        let task = URLSession.shared.dataTask(with: urlRequest!, completionHandler: {
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
//            do {
//            
//                //                    print("The title is: " + todoTitle)
//                self.TableData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String: AnyObject]]
//                //                    self.TableData.append(todoTitle)
//                //                    self.TableData.append("deez nuts")
//                //                    self.TableData.append("u's a bitch")
//                self.tableView.reloadData()
//                
//                print ("THIS IS BULLSHIT")
//                print (self.TableData)
//                
//                
//            } catch let error as NSError{
//                print(error)
//            }
//            
//        }).resume()
//        
        
        
        
        
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
        cell.textLabel?.text = item["last_name"] as? String
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
