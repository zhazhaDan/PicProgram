//
//  ArtReadTableViewCell.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/22.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class ArtReadTableViewCell: UITableViewCell {

    @IBOutlet weak var showPicImageView: UIImageView!
    @IBOutlet weak var picTitleLabel: UILabel!
    @IBOutlet weak var picDetailLabel: UILabel!
    @IBOutlet weak var picUploadTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
