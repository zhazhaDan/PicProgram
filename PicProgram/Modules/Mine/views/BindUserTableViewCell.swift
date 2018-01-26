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
    var dataSource: Array<[String:Any]> = Array()
    open weak var delegate:MineViewProtocol!
    var row:Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.promiseButton.layer.borderColor = xsColor_placeholder_grey.cgColor
        self.promiseButton.layer.borderWidth = 1
        self.denyButton.layer.borderColor = xsColor_placeholder_grey.cgColor
        self.denyButton.layer.borderWidth = 1

    }
    @IBAction func denyAction(_ sender: Any) {
        delegate.denyBindDevice!(view: self, deviceIndex: row)
    }
    @IBAction func promiseAction(_ sender: Any) {
        delegate.promiseBindDevice!(view: self, deviceIndex: row)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

