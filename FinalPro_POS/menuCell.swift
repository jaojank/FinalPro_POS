//
//  menuCell.swift
//  FinalPro_POS
//
//  Created by thebk on 18/3/2563 BE.
//  Copyright © 2563 thebk. All rights reserved.
//

import UIKit

class menuCell: UITableViewCell {

    @IBOutlet weak var Nfood: UILabel!
    @IBOutlet weak var Pfood: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
