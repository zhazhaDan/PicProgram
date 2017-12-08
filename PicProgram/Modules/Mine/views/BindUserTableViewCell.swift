//
//  BindUserTableViewCell.swift
//  PicProgram
//
//  Created by sliencio on 2017/12/2.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class BindUserTableViewCell: UITableViewCell {
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var promiseButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
