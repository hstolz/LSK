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
    //    var userId: String = "-1"
    
    var classUserName = "";
    var classAuthHeader = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
        let defaults = UserDefaults.standard
        let tokenString = defaults.string(forKey: defaultsKeys.tokenKey)!
        let auth_header = ["Authorization" : "Token " + tokenString]
        
        
        let userNameString = defaults.string(forKey: defaultsKeys.keyOne)!
        
        classUserName = defaults.string(forKey: defaultsKeys.keyOne)!
        classAuthHeader = auth_header

        
        print("THAT GOOD KUSH: THE AUTH HEADER")
        print(auth_header)
        
        
        
        
        let todoEndpoint: String = "https://wordup-163921.appspot.com/profiles/"
        Alamofire.request(todoEndpoint, headers: auth_header)
            .responseJSON { response in
                // print response as string for debugging, testing, etc.
                print(response.result.value as! NSArray)
                print(response.result.error)
                
                self.TableData = (response.value as! NSArray) as! [[String : AnyObject]]
                print (self.TableData)
                self.tableView.reloadData()
                //                let userId = self.TableData[0]["id"]
                //                print ("PRINTING USER ID NOW")
                //                print (userId)
                //                DataManager.sharedInstance.otherUserId = userId as! Int
                //                print (DataManager.sharedInstance.otherUserId)
                //
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func displayMyAlertMessage(userMessage:String, title:String)
    {
        
        let myAlert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in
            // self.dismiss(animated: true, completion: nil)
        }
        
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
        
    }
    
    @IBAction func randomMatchButtonPressed(_ sender: Any) {
        
        let todosEndpoint: String = "https://wordup-163921.appspot.com/matches/"
        
        let newTodo: [String: Any] = ["i_username": classUserName]
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,encoding: JSONEncoding.default, headers: classAuthHeader).validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    print("Validation Successful")
                    print(response.result.value as! NSDictionary)
                    let random_Match = response.result.value as! NSDictionary
                    print(random_Match["username"] as! String)
                    let successMsg = "You matched with " + (random_Match["username"] as! String)
                    self.displayMyAlertMessage(userMessage: successMsg, title: "Congrats!")
                    
//                    self.TableData.append(random_Match as! [String : AnyObject])
//                    self.tableView.reloadData()
                    
                    // SEGUE TO THAT PERSON ? 
                    
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
        return self.TableData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        let item = self.TableData[indexPath.row]
        
        //        cell.textLabel?.text = self.TableData[indexPath.row]
        cell.textLabel?.text = item["last_name"] as? String
        //        print(self.listData.count)
        
        return cell
    }
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "showDetail" {
    //            if let indexPath = self.tableView.indexPathForSelectedRow {
    //                let controller = segue.destination as! UserProfilesViewController
    //                let row = indexPath.row
    //                controller.userId = self.TableData[row]["id"] as! String
    //            }
    //        }
    //    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showProfileDetail") {
            //            if let indexPath = categoryTableView.indexPathForSelectedRow() {
            // do the work here
            //            let navVC = segue.destination as? UINavigationController
            
            //            var svc = navVC?.viewControllers.first as! UserProfilesViewController
            
            //            profileVC
            
            var svc = segue.destination as! UserProfilesViewController
            
            //
            
            //            self.navigationController?.pushViewController(svc, animated: true)
            //            let cell = sender as! UITableViewCell
            //            let indexPath = tableView.indexPath(for: cell)
            //            let selectedIndex = tableView.indexPath(for: sender as! UITableViewCell)!
            
            //            navigationController?.pushViewController(userProfilesViewControllerB, animated: true)
            //            navigationController?.push
            let indexPath = self.tableView.indexPathForSelectedRow
            //            self.navigationController
            print("MOST IMPORTANT NUMBER HERE")
            print (indexPath?.row)
            print (indexPath!.row)
            //            print (self.TableData[2]["id"]!)
            
            svc.userId = self.TableData[indexPath!.row]
            print (svc.userId)
            
            
            //            }
            
            //            tableView.deselectRow(at: indexPath, animated: true)
            
        }
    }
    override  func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath){
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        let item = self.TableData[row]
        print("PRINTING ROW NUMBER")
        print("Row: \(row)")
        
        
        let userId = item["id"]
        //        let
        print ("PRINTING USER ID NOW")
        print (userId)
        //        DataManager.sharedInstance.otherUserId = userId as! Int
        //        let userProfilesViewControllerB = UserProfilesViewController()
        //        userProfilesViewControllerB.userId = userId as! Int
        //        print("PRINTING INSIDE PROTO")
        //        print(userProfilesViewControllerB.userId)
        //        navigationController?.pushViewController(userProfilesViewControllerB, animated: true)
        //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        //        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("nextView") as UserProfilesViewController
        //        self.presentViewController(nextViewController, animated:true, completion:nil)
        //
        //
        
        //        print (DataManager.sharedInstance.otherUserId)
        
        ////
        //        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        //        let destination = storyboard.instantiateViewController(withIdentifier: <#T##String#>)
        //        navigationController?.pushViewController(destination, animated: true)
        //        self.present(destination, animated:true, completion:nil)
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
