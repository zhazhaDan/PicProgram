//
//  AddEmotionView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/12/10.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

enum EmotionType {
    case Emotion_nu
    case Emotion_si
    case Emotion_kong
    case Emotion_jing
    case Emotion_you
    case Emotion_xi
    case Emotion_bei
    case Emotion_wuchang
}

class AddEmotionView: BaseXibView {

    open weak var delegate : AddEmotionProtocol!
    @IBAction func emotionChoosedAction(_ sender: UIButton) {
        delegate.emotionChoosed!(emotionView: self, sender: sender,emotionIndex: sender.tag - 30)
    }


}

@objc protocol AddEmotionProtocol:NSObjectProtocol {
    @objc optional func emotionChoosed(emotionView:AddEmotionView,sender:UIButton, emotionIndex index:Int)
}
