//
//  AddEmotionView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/12/10.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class AddEmotionView: BaseXibView {

    open weak var delegate : AddEmotionProtocol!
    @IBAction func emotionChoosedAction(_ sender: UIButton) {
        delegate.emotionChoosed!(sender: sender,emotionIndex: sender.tag - 30)
    }


}

@objc protocol AddEmotionProtocol:NSObjectProtocol {
    @objc optional func emotionChoosed(sender:UIButton, emotionIndex index:Int)
}
