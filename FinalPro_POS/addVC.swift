//
//  addVC.swift
//  FinalPro_POS
//
//  Created by thebk on 19/3/2563 BE.
//  Copyright © 2563 thebk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore


class addVC: UIViewController {
    
    let db = Firestore.firestore()
    var email:String = ""
    var foodList:Dictionary = [String:[String:Any]]()
    var foodName:Array = [String]()
    
    @IBOutlet weak var txtFoodN: UITextField!
    @IBOutlet weak var txtFoodP: UITextField!
    
        @IBAction func btnAdd(_ sender: Any) {
           
                self.add(foodN:"\(txtFoodN.text!)", foodP:"\(txtFoodP.text!)")
            
            
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let mvc = self.storyboard?.instantiateViewController(identifier: "menuView") as! MenuVC
            
                    mvc.foodList = self.foodList
                    mvc.foodName = self.foodName
                    mvc.email = self.email

                   self.view.window?.rootViewController = mvc
    //             self.dismiss(animated: true, completion: nil)
    //        }
        }
        
         func add(foodN:String, foodP:String ){
            self.db.collection("pos/\(email)/food").document("\(foodN)").setData([
              "Food_name" : foodN ,
              "Food_price" : foodP
               ]){ err in
                       if let err = err {
                           print("Error adding document: \(err)")
                       } else {
                        self.readData()
                           print("Document successfully Add!")
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
                
                }
                print("reload")
                print("======")
                print(self.foodList)
                print(self.foodList.count)
                print(self.foodName)
                print("======")
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(self.email)")

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
