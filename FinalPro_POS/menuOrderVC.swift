//
//  menuOrderVC.swift
//  FinalPro_POS
//
//  Created by thebk on 1/4/2563 BE.
//  Copyright © 2563 thebk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class menuOrderVC: UIViewController , UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    
   
    
    let storage = Storage.storage()
    let db = Firestore.firestore()
    var tableList:Dictionary = [String:[String:Any]]()
    var tableName:Array = [String]()
    var foodList:Dictionary = [String:[String:Any]]()
    var foodName:Array = [String]()
    var orderNTList:Dictionary = [String:[String:Any]]()
    var orderNTName:Array = [String]()
    var email:String = ""
    var orderID:String = ""
    let st:String = ""
    var num:Int = 0
    let countFood = ["1","2","3","4","5","6","7","8","9","10"]
    var pickerView = UIPickerView()
    let test = UITextField()
    var steper = UIStepper()
    
    @IBOutlet weak var tbv2: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodList.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = tableView.dequeueReusableCell(withIdentifier: "cellMenuO", for: indexPath) as! menuOrderVCell
//        cell.Nfood.text = foodList[foodName[indexPath.row]]!["Food_name"] as! String
        cell.lbNameMeu.text = foodList[foodName[indexPath.row]]!["Food_name"] as! String
        cell.index = indexPath
        cell.delegate = self
            
        return cell
       }
       
    @IBAction func btnBack(_ sender: Any) {
          self.updateStatus(name: self.tableList[self.tableName[self.num]]!["name"] as! String, status: self.st)
                                     
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = self.storyboard?.instantiateViewController(identifier: "numtaleView") as! numTaleVC
                vc.email = self.email
                vc.tableName = self.tableName
                vc.tableList = self.tableList
            self.view.window?.rootViewController = vc
         
                                  
                              
    }
    
    @IBOutlet weak var lbNumTable: UILabel!
    
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
                    
                    }
                   
    //                print("reload")
    //                print("======")
    //                print(self.foodList)
    //                print(self.foodList.count)
    //                print(self.foodName)
    //                print("===+===")
                }
                
            }
        }
    func deleteOrder()  {
        self.db.collection("pos/\(email)/order").document(orderID).delete(){ err in
            if let err = err {
             print("Error removing document: \(err)")
             } else {
             print("Document successfully removed!2")
            }
            
        }
    }
    
    func readOrderNT(){
            self.db.collection("pos").document("\(email)").collection("order").getDocuments{ (DocumentSnapshot, Error) in
                
                if Error == nil && DocumentSnapshot != nil {
                    self.orderNTList.removeAll()
                    self.orderNTName.removeAll()

                for document in DocumentSnapshot!.documents {

                    let data = document.data()
                    let name = data["order_ID"] as! String
                        
                    self.orderNTList[name] = data
                    self.orderNTName.append(name)
                    
                    }
                   
    //                print("reload")
    //                print("======")
    //                print(self.foodList)
    //                print(self.foodList.count)
    //                print(self.foodName)
    //                print("===+===")
                }
                
            }
        }
    
    func readT()  {
             self.db.collection("pos").document("\(email)").collection("table").getDocuments{ (DocumentSnapshot, Error) in
                
                if Error == nil && DocumentSnapshot != nil {
                       self.tableList.removeAll()
                       self.tableName.removeAll()
                     
                       for document in DocumentSnapshot!.documents {
                              let data2 = document.data()
                              let name2 = data2["name"] as! String
                      
                              self.tableList[name2] = data2
                              self.tableName.append(name2)
//                         print(self.tableList)
                      
                        }
                }
                }
       }
    func updateStatus(name:String,status:String){
           self.db.collection("pos/\(email)/table").document(self.tableList[self.tableName[self.num]]!["name"] as! String).setData([
               "name": name,
               "status": status
               ]) { err in
               if let err = err {
                   print("Error writing document: \(err)")
               } else {
                   print("Document upadte")
                  self.readT()
               }
           }
       }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return countFood.count
      }
      
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return countFood[row]
      }
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
              test.text = self.countFood[row]
              test.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if Auth.auth().currentUser != nil {
//            self.loginInfoLabel.text = "Hello|" + (Auth.auth().currentUser?.email)!
//        }
//        else {
//            self.loginInfoLabel.text = "Please Login"
//        }
        self.lbNumTable.text = "Table|" +  (self.tableList[self.tableName[self.num]]!["name"] as! String)
    }

    override func viewDidLoad() {
        print("==OrderID==")
        print(orderID)
        readT()
        super.viewDidLoad()
        self.tbv2.rowHeight = 70
        
        pickerView.delegate = self
        pickerView.dataSource = self
    

        // Do any additional setup after loading the view.
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

extension menuOrderVC : dataCollectionProtocol{
   
    
    func DeletOMenu(indx: menuOrderVCell) {
        
        if let indexpath = tbv2?.indexPath(for: indx){
            self.db.collection("pos/\(email)/table/\((self.tableList[self.tableName[self.num]]!["name"] as! String))/order").document(self.foodName[indexpath.row]).delete() { err in
             if let err = err {
              print("Error removing document: \(err)")
               } else {
              print("Document successfully removed!")
                                        
         }
          }

        }
        
    }
    
    
    
    
    func addOrder(indx: menuOrderVCell) {
        if let indexpath = tbv2?.indexPath(for: indx){
            let alertController = UIAlertController(title: self.foodName[indexpath.row], message: "จำนวนอาหารที่ต้องการสั่ง", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
                
            let count = alertController.textFields?[0].text
            let price = self.foodList[self.foodName[indexpath.row]]!["Food_price"] as! String
            let countInt1 = Int(count!)
            let priceInt = Int(price)
            let countprice:Int = countInt1! * priceInt!
            let totalprice = "\(countprice)"
            
                self.addMenuOrder(name: self.foodList[self.foodName[indexpath.row]]!["Food_name"] as! String, countFood: count!, price: totalprice)
            
                
//            let Nname = alertController.textFields?[2].text
//            let age = alertController.textFields?[3].text
//            let email = alertController.textFields?[4].text
//            let image = alertController.textFields?[5].text
//
//                self.updateData(name: name!, Lname: Lname!, Nname: Nname!, Age: age!, Email: email!, image: image!)
//                print(self.userList[self.userName[self.num]])
                
            }
            alertController.addTextField { (textField) in
                textField.inputView = self.pickerView
                textField.placeholder = "จำนวนอาหาร"
                textField.textAlignment = .center
                textField.text = self.test.text
                print("=====")
                print(self.test.text)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            //adding action
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            
            //presenting dialog
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
//    func alert(test:UITextField){
//         alertController.addTextField { (textField) in
//         let test = textField
//         textField.inputView = self.pickerView
//         textField.placeholder = "จำนวนอาหาร"
//         textField.textAlignment = .center
//        //                textField.text = ""
//                    }
//    }
    
    func addMenuOrder(name:String, countFood:String, price:String) {
        self.db.collection("pos/\(email)/table/\((self.tableList[self.tableName[self.num]]!["name"] as! String))/order").document(name).setData([
            "name": name,
            "countFood": countFood,
            "price": price
            ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document upadte")
               self.readT()
            }
        }
    }
    
    
//    func deleteData(indx: collecVC) {
//        if let indexpath = clv1?.indexPath(for: indx){
//            self.db.collection("commu").document(self.userName[indexpath.item]).delete() { err in
//                        if let err = err {
//                            print("Error removing document: \(err)")
//                        } else {
//                            print("Document successfully removed!")
//                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                                      let vc = self.storyboard?.instantiateViewController(identifier: "MainView") as! mainVC
//                                          self.view.window?.rootViewController = vc
//            //                print(self.userName[self.num])
////                            self.recollec()
////                            self.readData()
//                        }
//                    }
//
//        }
//    }
}
