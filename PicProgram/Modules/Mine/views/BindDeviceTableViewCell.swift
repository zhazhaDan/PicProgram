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
    @IBOutlet weak var unbundleButton: UIButton!
    open weak var delegate:MineViewProtocol!
    var row:Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.unbundleButton.layer.borderColor = xsColor_placeholder_grey.cgColor
        self.unbundleButton.layer.borderWidth = 1
    }
    @IBAction func removeRelationshipAction(_ sender: Any) {
        delegate.removeDevice!(view: self, deviceIndex: row)
    }
    
    @IBAction func chooseDeviceAction(_ sender: UIButton) {
        delegate.setBindDevices!(view: sender, deviceIndex: row)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
