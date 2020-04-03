//
//  signinVC.swift
//  FinalPro_POS
//
//  Created by thebk on 18/3/2563 BE.
//  Copyright © 2563 thebk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import Lottie
import SVProgressHUD
import MessageUI

class signinVC: UIViewController , MFMailComposeViewControllerDelegate{
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var confirmtxtpass: UITextField!
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var txtRestaurants: UITextField!
    
    let alertPassword = UIAlertController(title: "Error!", message: "Missing Password or do not match!", preferredStyle: .alert)
    
    let alertEmail = UIAlertController(title: "Error!", message: "Missing Email", preferredStyle: .alert)
    
    let alertFirstName = UIAlertController(title: "Error!", message: "FirstName cannot be blank!", preferredStyle: .alert)
    
    let alertLastName = UIAlertController(title: "Error!", message: "LastName cannot be blank!", preferredStyle: .alert)
    
    let alertRestaurantsName = UIAlertController(title: "Error!", message: "RestaurantsName cannot be blank!", preferredStyle: .alert)
    
  
    func addOkButton() {
        alertPassword.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        alertEmail.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        alertFirstName.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        alertLastName.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
    }
    
    @IBAction func btnSignup(_ sender: Any) {
        
        if(txtUser.text == "") {
            self.present(alertEmail, animated: true, completion: nil)
        } else if(txtPass.text == "" || txtPass.text != confirmtxtpass.text) {
            self.present(alertPassword, animated: true, completion: nil)
        } else if(txtFname.text == "") {
            self.present(alertFirstName, animated: true, completion: nil)
        } else if(txtLname.text == "") {
            self.present(alertLastName, animated: true, completion: nil)
        } else if(txtRestaurants.text == "") {
            self.present(alertRestaurantsName, animated: true, completion: nil)
        } else if(txtUser.text != "" && txtPass.text != "") {
            
            if txtUser.text != nil && txtPass != nil {
                Auth.auth().createUser(withEmail: txtUser.text!, password: txtPass.text!) {
                    (Result, Error) in
                    if Error != nil {
                        let alert = UIAlertController(title: "Error!", message: "Error with login \(Error.debugDescription)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"OK\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                        print("Signup error \(Error.debugDescription)")
//                        print(Error.debugDescription)
                    }
                    else {
                        self.add(Fname: self.txtFname.text!, Lname: self.txtLname.text!, Email: self.txtUser.text!, Restaurants: self.txtRestaurants.text!, id: (Auth.auth().currentUser!.uid))
                        print("Register Successfully")
                        self.dismiss(animated: true, completion: nil)
                        let mailCompose = self.configMail()
                        if MFMailComposeViewController.canSendMail() {
                            self.present(mailCompose, animated: true, completion: nil)
                        }else{
                            print("cannot send")
                        }
                    }
                }
            }
            
        }
        
        
    }

    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func add(Fname:String, Lname:String, Email:String, Restaurants:String, id:String){
    //        db.collection("commuFriend").addDocument(data: <#T##[String : Any]#>)({
    //            Fname: Fname,
    //            country: "Japan"
    //        })
    //        var ref: DocumentReference? = nil
              self.db.collection("pos").document("\(Email)").setData([
                "Fname" : Fname ,
                "Lname" : Lname ,
                "Email" : Email,
                "nameRestaurants" : Restaurants,
                "id" : (Auth.auth().currentUser!.uid)
                

                ]){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully Add!")
                }
            }
        }
    
    
    
//    func add (Fname:String, Lname:String, Email:String, Restaurants:String) {
//
//        var studentsClassroomRef = self.db.collection("pos").document(Email)
//            .collection("food");
//
//        studentsClassroomRef.doc(Email).set([
//            "Fname" : Fname ,
//             "Lname" : Lname ,
//             "Email" : Email,
//             "nameRestaurants" : Restaurants
//
//        ]){ err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document successfully Add!")
//            }
//        }
//    }
    
    func configMail() -> MFMailComposeViewController {
        let mailCompose = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setToRecipients(["bbankk26@gmail.com"])
        mailCompose.setSubject("ยินต้อนรับ")
        mailCompose.setMessageBody("ขอบคุณที่ไว้วางใจใช้บรการระบบจัดการร้านของแอพเรา", isHTML:false)
       
        return mailCompose
    }
    
    func aimation()  {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(UIColor.red)           //Ring Color
        SVProgressHUD.setBackgroundColor(UIColor.yellow)
        SVProgressHUD.showSuccess(withStatus: "Success")
    }
    



    override func viewDidLoad() {
        super.viewDidLoad()
        addOkButton()

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
