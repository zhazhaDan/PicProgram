//
//  PicDetailHeaderCollectionReusableView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/23.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class PicDetailHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var eyeNumLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var changeSegment: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
