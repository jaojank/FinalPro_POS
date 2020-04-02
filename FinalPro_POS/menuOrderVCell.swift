//
//  menuOrderVCell.swift
//  FinalPro_POS
//
//  Created by thebk on 1/4/2563 BE.
//  Copyright © 2563 thebk. All rights reserved.
//

import UIKit

protocol dataCollectionProtocol : class {
    func addOrder(indx: menuOrderVCell)
    func DeletOMenu(indx:menuOrderVCell)
}

class menuOrderVCell: UITableViewCell {


    @IBOutlet weak var lbNameMeu: UILabel!
    weak var delegate : dataCollectionProtocol?
        
    //    var delegate: dataCollectionProtocol?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnaddMenu(_ sender: Any) {
         delegate?.addOrder(indx:self)
    }
    @IBAction func btnDeletOMenu(_ sender: Any) {
            delegate?.DeletOMenu(indx:self)
       }
    
}
