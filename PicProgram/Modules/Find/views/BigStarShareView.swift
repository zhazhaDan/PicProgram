//
//  BigStarShareView.swift
//  PicProgram
//
//  Created by sliencio on 2017/12/19.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class BigStarShareView: BaseView,SharePlatformProtocol {

    @IBOutlet weak var blurView: UIVisualEffectView!
    var cell : ArtMasterSayTableViewCell!
    @IBOutlet weak var contentScrollVIew: UIScrollView!
    @IBOutlet weak var materialButton: UIButton!
    @IBOutlet weak var platformButton: UIButton!
    @IBOutlet weak var chooseView: UIView!
    @IBOutlet weak var platView: SharePlatformView!
    @IBAction func materialChooseAction(_ sender: UIButton) {
        let images = [#imageLiteral(resourceName: "yishuxianfeng_huise"),#imageLiteral(resourceName: "yishuxianfeng_dakashuo_xuanzhi"),#imageLiteral(resourceName: "yishuxianfeng_mise")]
        self.cell.materialImageView.image = images[sender.tag - 11]
        for i in 0 ..< 3 {
            let btn = self.viewWithTag(11+i) as! UIButton
            if btn == sender {
               btn.isSelected = true
            }else {
                btn.isSelected = false
            }
        }
        shareAction(platformButton)
    }
    
    
    @IBAction func shareAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.chooseView.x = sender.x
        }
        self.contentScrollVIew.setContentOffset(CGPoint.init(x: SCREEN_WIDTH, y: 0), animated: true)
    }
    @IBAction func materialAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.chooseView.x = sender.x
        }
        self.contentScrollVIew.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.removeFromSuperview))
        self.blurView.addGestureRecognizer(tap)
        cell = Bundle.main.loadNibNamed("ArtMasterSayTableViewCell", owner: self, options: nil)?.first as! ArtMasterSayTableViewCell
        cell.frame = CGRect.init(x: 24, y: 183, width: SCREEN_WIDTH - 48, height: 190)
        self.addSubview(cell)
        
//        let codeString = "大咖说分享文\(MRLanguage(forKey: "pages"))"
        let codeString = "www.atmoran.com"
        let image = codeString.generateQRCodeImage()
        let imageview = UIImageView.init(frame: CGRect.init(x: cell.width - 56 - 12, y: cell.height - 56 - 12, width: 56, height: 56))
        imageview.contentMode = .scaleAspectFit
        imageview.image = image
        cell.addSubview(imageview)
        platView.delegate = self
    }
    
    func share(toPlatform index: Int) {
        //TODO:三方分享
        switch index {
        case 0:
            let image = cell.viewShot()
            ShareThirdAppTool.share.share_icon = image
            let sheet = UIAlertController.init(title: MRLanguage(forKey: "No"), message: nil, preferredStyle: .actionSheet)
            let session = UIAlertAction.init(title: MRLanguage(forKey: "Wechat session"), style: .default, handler: { (action) in
                ShareThirdAppTool.share.shareToWX(WXSceneSession)
            })
            let timeline = UIAlertAction.init(title: MRLanguage(forKey: "Wechat timeline"), style: .default, handler: { (action) in
                ShareThirdAppTool.share.shareToWX(WXSceneTimeline)
            })
            let cancel = UIAlertAction.init(title: MRLanguage(forKey: "No"), style: .cancel, handler: { (action) in
            })
            sheet.addAction(session)
            sheet.addAction(timeline)
            sheet.addAction(cancel)
            appDelegate.window?.rootViewController?.present(sheet, animated: true, completion: nil)
            
        case 1:
            ShareThirdAppTool.share.shareToWeibo()
        case 2:
            ShareThirdAppTool.share.shareToInstagram()
        case 3:
            ShareThirdAppTool.share.shareToTwitter()
        case 4:
            ShareThirdAppTool.share.shareToFacebook()
        default:
            ShareThirdAppTool.share.share_icon = cell.viewShot()
            ShareThirdAppTool.share.shareToWX(WXSceneSession)
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
