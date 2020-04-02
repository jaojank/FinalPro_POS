//
//  MenuVC.swift
//  FinalPro_POS
//
//  Created by thebk on 18/3/2563 BE.
//  Copyright © 2563 thebk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class MenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
   
    
    let storage = Storage.storage()
    let db = Firestore.firestore()
    let db2 = Firestore.firestore()
    var foodList:Dictionary = [String:[String:Any]]()
    var foodName:Array = [String]()
    var tableList:Dictionary = [String:[String:Any]]()
    var tableName:Array = [String]()
    var email:String = ""
    var num:Int = 0
    
    @IBOutlet weak var tbv1: UITableView!
    
    let myRefreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Wait a second", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//         let cell = tableView.dequeueReusableCell(withIdentifier: "data", for: indexPath) as! menuCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "data", for: indexPath) as! menuCell
        
//      cell.lbNname.text = userList[userName[indexPath.row]]!["C_Nname"] as! String
        cell.Nfood.text = foodList[foodName[indexPath.row]]!["Food_name"] as! String
        cell.Pfood.text = foodList[foodName[indexPath.row]]!["Food_price"] as! String
//        cell.Nfood.text = "500"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath.row)")
            print(self.foodList[self.foodName[indexPath.row]])
            self.num = indexPath.row
            self.deleteData()
            completionHandler(true)
        }
        
        let rename = UIContextualAction(style: .normal, title: "Edit") {
                (action, sourceView, completionHandler) in
                print("index path of edit: \(indexPath.row)")
                print(self.foodList[self.foodName[indexPath.row]])
                self.num = indexPath.row
                
                //building an alert
                let alertController = UIAlertController(title: self.foodName[indexPath.row], message: "Edit user", preferredStyle: .alert)
                
                //the confirm action taking the inputs
                let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
                        
                let name = alertController.textFields?[0].text
                let price = alertController.textFields?[1].text
               
                
                    self.updateData(name: name!, price: price!)
                    print(self.foodList[self.foodName[indexPath.row]])
                    
                }
                
                alertController.addTextField { (textField) in
                    textField.text = self.foodList[self.foodName[indexPath.row]]!["Food_name"] as! String
                }
                alertController.addTextField { (textField) in
                    textField.text = self.foodList[self.foodName[indexPath.row]]!["Food_price"] as! String
                }
            
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                
                //adding action
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                
                
                //presenting dialog
                self.present(alertController, animated: true, completion: nil)
                
                completionHandler(true)
                }
            let swipeActionConfig = UISwipeActionsConfiguration(actions: [rename,delete])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
                
            return swipeActionConfig
        
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    }
    
    func deleteData() {
            self.db.collection("pos/\(email)/food").document(self.foodName[self.num]).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
    //                print(self.userName[self.num])
                    self.readData()
                }
            }
        }
    
    func updateData(name:String, price:String){
        self.db.collection("pos/\(email)/food").document(self.foodName[self.num]).setData([
            "Food_name": name,
            "Food_price": price
            ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document upadte")
                print(self.foodName[self.num])
                self.readData()
            }
        }
    }

    
    func readData(){
        self.db.collection("pos").document("\(email)").collection("food").getDocuments{ (DocumentSnapshot, Error) in
            
            if Error == nil && DocumentSnapshot != nil {
                self.foodList.removeAll()
                self.foodName.removeAll()

            for document in DocumentSnapshot!.documents {

                let data = document.data()
                let name = data["Food_name"] as! String
                    
                self.foodList[name] = data
                self.foodName.append(name)
                self.tbv1.reloadData()
                
                }
                self.tbv1.reloadData()
                print("reload")
                print("======")
                print(self.foodList)
                print(self.foodList.count)
                print(self.foodName)
                print("===+===")
            }
            
        }
    }
    
   
     @IBAction func batnAdd(_ sender: Any) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    //        let mvc = self.storyboard?.instantiateViewController(identifier: "addView") as! addVC
    //         self.present(mvc, animated: true, completion: nil)
            let mvc = storyboard?.instantiateViewController(identifier: "addView") as? addVC
               mvc?.email = self.email
               mvc?.foodList = self.foodList
               mvc?.foodName = self.foodName
        
             self.view.window?.rootViewController = mvc
        }
    
    func readT()  {
          self.db2.collection("pos").document("\(email)").collection("table").getDocuments{ (DocumentSnapshot, Error) in
                  
                    for document in DocumentSnapshot!.documents {
                           let data2 = document.data()
                           let name2 = data2["name"] as! String
                   
                           self.tableList[name2] = data2
                           self.tableName.append(name2)
                      print(self.tableList)
                   
                     }
              }
    }
    
    @IBAction func btnTable(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mvc = self.storyboard?.instantiateViewController(identifier: "numtaleView") as! numTaleVC
        mvc.email = self.email
        mvc.tableList = self.tableList
        mvc.tableName = self.tableName
        print("++++")
        print(tableList)
        print("++++")
        self.view.window?.rootViewController = mvc
    }
    
    @IBAction func btnReport(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let mvc = self.storyboard?.instantiateViewController(identifier: "addView") as! addVC
        //         self.present(mvc, animated: true, completion: nil)
                let mvc = storyboard?.instantiateViewController(identifier: "reportView") as? reportVC
                   mvc?.email = self.email
                   mvc?.foodList = self.foodList
                   mvc?.foodName = self.foodName
            
                 self.view.window?.rootViewController = mvc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readData()
        readT()
        print("\(self.foodName)")
        tbv1.refreshControl = myRefreshControl
        self.tbv1.rowHeight = 100


        // Do any additional setup after loading the view.
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        
        self.db.collection("pos").document("\(email)").collection("food").getDocuments{ (DocumentSnapshot, Error) in
            
            if Error == nil && DocumentSnapshot != nil {
                self.foodList.removeAll()
                self.foodName.removeAll()

            for document in DocumentSnapshot!.documents {

                let data = document.data()
                let name = data["Food_name"] as! String
                    
                self.foodList[name] = data
                self.foodName.append(name)
                
                }
                print("======")
//                print(self.foodList)
//                print(self.foodList.count)
//                print(self.foodName)
                print("======")
            }
            
        }
        let str = "This is \(self.foodName.count) line"
        self.foodName.append(str)
        sender.endRefreshing()
        tbv1.reloadData()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
