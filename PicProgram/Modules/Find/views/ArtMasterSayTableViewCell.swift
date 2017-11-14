//
//  ArtMasterSayTableViewCell.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/26.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class ArtMasterSayTableViewCell: UITableViewCell {
    open weak var delegate: FindViewProtocol!

    @IBOutlet weak var praiseButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weendayLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var sayNumLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectedBackgroundView = UIView(frame:self.bounds)
        self.selectedBackgroundView?.backgroundColor = xsColor_main_white
    }

    @IBAction func prainAction(_ sender: Any) {
        delegate.praiseBigStar!()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
