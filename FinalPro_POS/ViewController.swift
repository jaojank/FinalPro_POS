//
//  ViewController.swift
//  FinalPro_POS
//
//  Created by thebk on 18/3/2563 BE.
//  Copyright © 2563 thebk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SVProgressHUD

public var auth = Auth.auth()

class ViewController: UIViewController {
    
    var userList:Dictionary = [String:[String:Any]]()
    var userName:Array = [String]()
    
    var foodList:Dictionary = [String:[String:Any]]()
    var foodName:Array = [String]()
    
    let db = Firestore.firestore()
    let storage = Storage.storage()

    @IBOutlet weak var lbUser: UILabel!
    
    @IBOutlet weak var lbpass: UILabel!
    
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBAction func btnLogin(_ sender: Any) {
                   
                   self.readFoodData()
                   DispatchQueue.main.async {
                       print("main thread dispatch")
                       
                       if self.txtUser.text != nil && self.txtPass != nil {
                           Auth.auth().signIn(withEmail: self.txtUser.text!, password: self.txtPass.text!) { (user,error) in
                               if error != nil {
                                   print(error.debugDescription)
                               }
                               else {
                                print("Login Successfully")
                                   
                                   let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                   let mvc = self.storyboard?.instantiateViewController(identifier: "menuView") as! MenuVC
                                
                                   
    //                                     mvc.userList = self.userList
                                           mvc.email = self.txtUser.text!
                                           mvc.foodList = self.foodList
                                           mvc.foodName = self.foodName
                                   
                                   if self.userList.count > 0 {
                                           self.view.window?.rootViewController = mvc
                                   }
                                   else {
                                           self.btnLogin(self.btnLogin as Any)
                                           print(self.userList)
                                   }
                               }
                           }
                       }
                   }
               }
    
    
    
    @IBAction func btnSignup(_ sender: Any) {
           let storyBoad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
           let svc = storyBoad.instantiateViewController(identifier: "signinView") as! signinVC
               
           self.present(svc, animated: true, completion: nil)
       }
    
    
    func readData(){
        db.collection("pos").getDocuments { (DocumentSnapshot, Error) in

        if Error == nil && DocumentSnapshot != nil {

            for document in DocumentSnapshot!.documents {

                let data = document.data()
                let name = data["Email"] as! String
                    
                self.userList[name] = data
                self.userName.append(name)
                
                print(self.userList)
                                        
                }
            }
        }
    }
    
    func aimation()  {
           SVProgressHUD.setDefaultStyle(.custom)
           SVProgressHUD.setDefaultMaskType(.custom)
           SVProgressHUD.setForegroundColor(UIColor.red)           //Ring Color
           SVProgressHUD.setBackgroundColor(UIColor.yellow)
           SVProgressHUD.showSuccess(withStatus: "Success")
       }
       
    
    func readFoodData(){
        
       
        self.db.collection("pos").document(txtUser.text!).collection("food").getDocuments{ (DocumentSnapshot, Error) in
            
            if Error == nil && DocumentSnapshot != nil {

            for document in DocumentSnapshot!.documents {

                let data = document.data()
                let name = data["Food_name"] as! String
                    
                self.foodList[name] = data
                self.foodName.append(name)
                
                }
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
        readData()
        
        self.lbpass.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2 )
        self.lbUser.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        // Do any additional setup after loading the view.
    }


}

