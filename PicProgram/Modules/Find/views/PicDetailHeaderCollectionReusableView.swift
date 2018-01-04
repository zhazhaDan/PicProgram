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
    open weak var delegate: SearchProtocol!
    
    @IBOutlet weak var collectButton: UIButton!
    
    var segmentIndex:Int = 1

    
    @IBAction func collectAction(_ sender: Any) {
        delegate.collectAction!(view: sender as! UIButton)
    }
    

    
    @IBAction func picChangeAction(_ sender: UISegmentedControl) {
        segmentIndex = sender.selectedSegmentIndex
        delegate.picsStyleChangeAction!(style: sender.selectedSegmentIndex)
    }
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
}
