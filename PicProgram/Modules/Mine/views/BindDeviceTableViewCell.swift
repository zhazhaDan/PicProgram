//
//  BindDeviceTableViewCell.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/12/5.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class BindDeviceTableViewCell: UITableViewCell {
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var deviceNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func removeRelationshipAction(_ sender: Any) {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
