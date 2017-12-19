//
//  ShareViewController.swift
//  PicProgram
//
//  Created by sliencio on 2017/12/9.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class ShareViewController: BaseViewController,UIGestureRecognizerDelegate,UIScrollViewDelegate ,AddEmotionProtocol,SharePlatformProtocol{
    @IBOutlet weak var figureImageView: UIImageView!
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var picTitleLabel: UILabel!
    @IBOutlet weak var emotionButton: UIButton!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var segView: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: AddEmotionView!
    @IBOutlet weak var view3: SharePlatformView!
    @IBOutlet weak var contentScrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var shareScrollView: UIScrollView!
    @IBOutlet weak var bottomFigureImageView: UIImageView!
    
    
    var picUrl:String!
    var picTitle:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        view2.delegate = self
        view3.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.picImageView.xs_setImage(picUrl)
        self.picTitleLabel.text = self.picTitle
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        codeUpdate()
    }
    
    @IBAction func chooseFigureAction(_ sender: UIButton) {
        for i in 0 ..< 4 {
            let btn = self.view.viewWithTag(20+i) as! UIButton
            if btn == sender {
                btn.isSelected = true
                self.figureImageView.image = UIImage.init(named: "fenxiang_huawen\(i)")
            }else {
                btn.isSelected = false
            }
        }
    }

   
    @IBAction func bottomSegChooseAction(_ sender: UIButton) {
        for i in 0 ..< 3 {
            let btn = self.view.viewWithTag(10+i) as! UIButton
            if btn == sender {
                UIView.animate(withDuration: 0.25, animations: {
                    self.segView.x = btn.x
                }, completion: {(finished) in
                    if finished == true {
                       
                    }
                })
                if i == 1 {
                    self.contentScrollViewHeight.constant = 249
                    self.contentScrollView.height = 249
                }else {
                    self.contentScrollViewHeight.constant = 54
                    self.contentScrollView.height = 54
                }
                self.contentScrollView.updateConstraints()
                self.contentScrollView.setContentOffset(CGPoint.init(x: Int(self.contentScrollView.width) * i, y: 0), animated: false)
                
            }else {
                btn.isSelected = false
            }
        }
        codeUpdate()
        
    }
    
    func codeUpdate() {
        let string = picTitleLabel.text! + emotionButton.title(for: .normal)!
        self.qrCodeImageView.image = string.generateQRCodeImage()
    }
    
    func share(toPlatform index: Int) {
        //TODO:三方分享
        switch index {
        case 0:
            let image = shareView.viewShot()
            ShareThirdAppTool.share.share_icon = image
            ShareThirdAppTool.share.shareToWX(WXSceneSession)
        case 1:
            ShareThirdAppTool.share.title = "我在享+发现了一个有趣的共享头等舱,一起来看看"
            ShareThirdAppTool.share.desc = "去看看"
            ShareThirdAppTool.share.webUrl = "http://www.baidu.com"
            ShareThirdAppTool.share.share_icon = #imageLiteral(resourceName: "fenxiang_ins")
            ShareThirdAppTool.share.shareToWeibo()

        default:
            ShareThirdAppTool.share.share_icon = shareView.viewShot()
            ShareThirdAppTool.share.shareToWX(WXSceneSession)
        }
    }
    
    func emotionChoosed(emotionView: AddEmotionView, sender: UIButton, emotionIndex index: Int) {
        self.emotionButton.setImage(sender.image(for: .normal), for: .normal)
        self.emotionButton.setTitle(sender.title(for: .normal), for: .normal)

    }
    
//    //为了解决tableivew didselect和tableivew.superview添加手势之后的冲突
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if  (touch.view)! == self.contentScrollView {
//            return false
//        }
//        return true
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if touches.first?.view == self.contentScrollView {
//            self.next?.touchesBegan(touches, with: event)
//        }
//    }
//
//
}
