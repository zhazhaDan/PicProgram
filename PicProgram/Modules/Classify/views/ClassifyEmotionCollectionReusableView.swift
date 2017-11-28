//
//  ClassifyEmotionCollectionReusableView.swift
//  PicProgram
//
//  Created by sliencio on 2017/11/26.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class ClassifyEmotionCollectionReusableView: UICollectionReusableView,CustomViewProtocol {
    @IBOutlet weak var emotionTitleButton: UIButton!
    open weak var delegate:CustomViewProtocol!
    var section:Int = 0
    @IBAction func emotionListShowAction(_ sender: Any) {
        delegate.listDidSelected!(view: self, at: 0, 0)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
