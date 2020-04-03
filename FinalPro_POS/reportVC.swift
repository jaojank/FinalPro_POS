//
//  reportVC.swift
//  FinalPro_POS
//
//  Created by thebk on 2/4/2563 BE.
//  Copyright © 2563 thebk. All rights reserved.
//

import UIKit
import Charts
import Firebase

class reportVC: UIViewController {
    
    let db = Firestore.firestore()
    var foodList:Dictionary = [String:[String:Any]]()
    var foodName:Array = [String]()
    var email:String = ""

    @IBAction func btnTable(_ sender: Any) {
    }
    @IBAction func btnMenu(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mvc = storyboard?.instantiateViewController(identifier: "menuView") as? MenuVC
                   mvc?.email = self.email
                   mvc?.foodList = self.foodList
                   mvc?.foodName = self.foodName
            
                 self.view.window?.rootViewController = mvc
    }
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var charts: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setChartValues()

        // Do any additional setup after loading the view.
    }
    func setChartValues(){
        let values = (0..<40).map {(i) -> ChartDataEntry in
            //dfsgsfdh
            let val = Double(UInt32())
            return ChartDataEntry(x: Double(i), y:val)
        }
        let set1 = LineChartDataSet(entries: values, label: "ยอดขาย(รายวัน)")
        let data = LineChartData(dataSet: set1)

        self.charts.data = data
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
