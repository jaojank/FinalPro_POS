//
//  numTaleVC.swift
//  FinalPro_POS
//
//  Created by thebk on 26/3/2563 BE.
//  Copyright © 2563 thebk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class numTaleVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let storage = Storage.storage()
    let db = Firestore.firestore()
    let db2 = Firestore.firestore()
    var tableList:Dictionary = [String:[String:Any]]()
    var tableName:Array = [String]()
    var foodList:Dictionary = [String:[String:Any]]()
    var foodName:Array = [String]()
    var email:String = ""
    var orderID:String = ""
    var num:Int = 0
    @IBOutlet weak var clv1: UICollectionView!

    let myRefreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Wait a second", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
     let alertAddSummit = UIAlertController(title: "Success!", message: "Plase scroll down to refresh again", preferredStyle: .alert)

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! collecVCell
        
        cell.lbNumer.text = tableList[tableName[indexPath.row]]!["name"] as! String
        cell.lbStatus.text = tableList[tableName[indexPath.row]]!["status"] as! String
        
        return cell
        

    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.num = indexPath.row
//             var ref: DocumentReference? = nil
//                db.collection("pos/\(email)/order").addDocument(data: [
//                      "Order_numerOfT" :  tableList[tableName[indexPath.row]]!["name"] as! String
//                   ]) { err in
//                       if let err = err {
//                           print("Error adding document: \(err)")
//                       } else {
//                           print("Document added with ID: \(documentID)")
//                           self.orderID = "\(documentID)"
//                       }
//                   }
//                   updateOrderID(name:tableList[tableName[indexPath.row]]!["name"] as! String, id: "\(ref!.documentID)")
//                updateOrderID(name: tableList[tableName[indexPath.row]]!["name"] as! String, id: "\(num)")
                   
                   updateStatus(name: tableList[tableName[indexPath.row]]!["name"] as! String, status: "Busy")
             print("index path of read: \(indexPath.row)")
             print(self.tableList[self.tableName[indexPath.row]])
//             addNumTOrder(orderNumT: tableList[tableName[indexPath.row]]!["name"] as! String)
        
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    //        let mvc = self.storyboard?.instantiateViewController(identifier: "detailView") as! detailVC
            
            let mvc = self.storyboard?.instantiateViewController(identifier: "menuOrderView") as! menuOrderVC
            
              mvc.foodList = self.foodList
              mvc.foodName = self.foodName
              mvc.tableList = self.tableList
              mvc.tableName = self.tableName
              mvc.email = self.email
              mvc.num = self.num
            
//            if self.orderID.count > 0 {
               self.view.window?.rootViewController = mvc
//            }else{
              print("noID")
            
            
        }
    
    @IBAction func addTable(_ sender: Any) {
        
       let numtableNow = tableList.count
       let st:String = ""
       print(numtableNow)
        
        if numtableNow < 9{
           let numtableUp = numtableNow + 1
           let changenumtable = "0\(String(numtableUp))"
           add(number: changenumtable,status: st)
        }
        else{
           let numtableUp = numtableNow + 1
           let changenumtable = String(numtableUp)
           add(number: changenumtable,status: st)
         }
        
       self.present(alertAddSummit, animated: true, completion: nil)
        
//      let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//       let mvc = self.storyboard?.instantiateViewController(identifier: "numtaleView") as! numTaleVC
//                 
//           mvc.email = self.email
//           mvc.tableList = self.tableList
//           mvc.tableName = self.tableName
//           self.view.window?.rootViewController = mvc
       
   }
    func updateStatus(name:String,status:String){
   self.db.collection("pos/\(email)/table").document("\(name)").setData([
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
    func updateOrderID(name:String,id:String){
    self.db.collection("pos/\(email)/order").document("\(id)").setData([
             "Order_numerOfT":name,
             "order_ID": id
             ]) { err in
             if let err = err {
                 print("Error writing document: \(err)")
             } else {
                 print("Document upadte")
             }
         }
     }
    
    
    func add(number:String,status:String){
    self.db.collection("pos/\(email)/table").document("\(number)").setData([
      "name" : number,
      "status": status
       ]){ err in
               if let err = err {
                   print("Error adding document: \(err)")
               } else {
                self.readT()
                   print("Document successfully Add!")
               }
           }
       }
    
    func readT()  {
     self.db2.collection("pos").document("\(email)").collection("table").getDocuments{ (DocumentSnapshot, Error) in
        
        if Error == nil && DocumentSnapshot != nil {
                       self.tableList.removeAll()
                       self.tableName.removeAll()
        for document in DocumentSnapshot!.documents {
                              let data = document.data()
                              let name = data["name"] as! String

                              self.tableList[name] = data
                              self.tableName.append(name)

                        }
        print("readT_ITwork1")
                 }
       }
    }
    
    func addOk()  {
        alertAddSummit.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
    }
    
//
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
    
    func addNumTOrder(orderNumT:String,id:String){
        var ref: DocumentReference? = nil
        ref = db.collection("pos/\(email)/order").addDocument(data: [
           "Order_numerOfT" : orderNumT ,
           "order_id" : "\(ref!.documentID)"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(email)
        print(tableList)
        readT()
        readData()
        addOk()
        clv1.refreshControl = myRefreshControl
        
         let bounds  = clv1.bounds
                
                let collectionViewLayout =  clv1?.collectionViewLayout as! UICollectionViewFlowLayout
        //        collectionViewLayout.itemSize = UICollectionViewFlowLayout.automaticSize
                collectionViewLayout.estimatedItemSize = CGSize(width: bounds.width/3 - 10, height: 100)
                collectionViewLayout.sectionInset = UIEdgeInsets(top: 5,left: 5,bottom: 0,right: 5)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func refresh(sender: UIRefreshControl) {
            
              self.db2.collection("pos").document("\(email)").collection("table").getDocuments{ (DocumentSnapshot, Error) in
                  
                  if Error == nil && DocumentSnapshot != nil {
                                 self.tableList.removeAll()
                                 self.tableName.removeAll()
                  for document in DocumentSnapshot!.documents {
                                        let data = document.data()
                                        let name = data["name"] as! String

                                        self.tableList[name] = data
                                        self.tableName.append(name)

                                  }
                  print("readT_ITwork")
                           }
                 }
            let str = "This is \(self.tableName.count) line"
            self.tableName.append(str)
            sender.endRefreshing()
            clv1.reloadData()
            
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
