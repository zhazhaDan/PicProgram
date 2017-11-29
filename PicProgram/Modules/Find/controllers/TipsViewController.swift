//
//  TipsViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/14.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class TipsViewController: BaseViewController,UITextViewDelegate,UIGestureRecognizerDelegate {
    @IBOutlet weak var localIcon: UIImageView!
    
    @IBOutlet weak var locateView: UIImageView!
    
    @IBOutlet weak var materialBackView: UIView!
    
    @IBOutlet weak var materialOrLocateChoosedView: UIView!
    
    @IBOutlet weak var tipsMaterialsButton: UIButton!
    
    @IBOutlet weak var currentImageView: UIImageView!
    
    @IBOutlet weak var locateChooseStatusView: UIView!
    var lastLocate:CGPoint = CGPoint.zero
    var  chooseLocatedIndex:Int = 1
    var  chooseMaterialIndex:Int = 1
    var picModel:PictureModel!
    var isLocalViewChoosed:Bool = false
    let papers:[String] = ["tips_bianqiancaizhi","tips_youhuabucaizhi","tips_keyincaizhi"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentImageView.xs_setImage(picModel.picture_url)
        self.title = "便签"
        // Do any additional setup after loading the view.
    }
    
    override func buildUI() {
        for i in 0 ..< 3 {
            let btn = self.view.viewWithTag(10+i) as! UIButton
            btn.layer.borderColor = xsColor_main_yellow.cgColor
        }
        self.baseNavigationController?.addRightNavigationBarItems(["neichen_yingyonghuakuang"], ["neichen_yingyonghuakuang"], nil, rightCallBack: { [weak self](tag) in
            self?.requestData()
        })
        self.tipsMaterialsButton.titleLabel?.numberOfLines = 9
    }
    override func requestData() {
        network.requestData(.paint_tips, params: ["tips_content":self.tipsMaterialsButton.title(for: .normal),"tips_texture":self.chooseMaterialIndex,"tips_location":self.chooseLocatedIndex], finishedCallback: { [weak self](result) in
            if result["ret"] as! Int == 0 {
                HUDTool.show(.text, text: "Tips设置成功", delay: 0.8, view: (self?.view)!, complete: nil)
            }
        }, nil)
    }

    @IBAction func tapViewAction(_ sender: UITapGestureRecognizer) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if self.localIcon.frame.contains((touch?.location(in: self.locateView))!) {
            self.lastLocate = (touch?.location(in: self.locateView))!
            self.isLocalViewChoosed = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isLocalViewChoosed == true {
            let touch = touches.first
            self.localIcon.center = (touch?.location(in: self.locateView))!
            let point = (touch?.location(in: self.locateView))!
            self.locateChooseStatusView.isHidden = false
            self.locateChooseStatusView.frame.origin = CGPoint.init(x: floor(point.x/self.locateChooseStatusView.width) * self.locateChooseStatusView.width, y: floor(point.y/self.locateChooseStatusView.height) * self.locateChooseStatusView.height)
            self.chooseLocatedIndex = Int(floor(self.locateChooseStatusView.x/self.locateChooseStatusView.width)) +  Int(floor(self.locateChooseStatusView.y/self.locateChooseStatusView.height))*3 + 1

        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
        self.locateChooseStatusView.isHidden = true
//        self.localIcon.frame.origin = (touch?.location(in: self.locateView))!
//        self.chooseLocatedIndex = Int(floor(self.locateChooseStatusView.x/self.locateChooseStatusView.width)) +  Int(floor(self.locateChooseStatusView.y/self.locateChooseStatusView.height))*3 + 1
        self.isLocalViewChoosed = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.localIcon.frame.origin = lastLocate
        self.isLocalViewChoosed = false
        self.locateChooseStatusView.isHidden = true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view == localIcon {
            return true
        }
        return false
    }
    
    
    
    @IBAction func tipsMaterialChooseAction(_ sender: UIButton) {
        for i in 0 ..< 3 {
            let btn = self.view.viewWithTag(10+i) as! UIButton
            if btn == sender {
                btn.isSelected = true
                self.tipsMaterialsButton.setBackgroundImage(UIImage.init(named: papers[i]), for: .normal)
                chooseMaterialIndex = i + 1
            }else {
                btn.isSelected = false
            }
        }
    }
    @IBAction func materialOrLocateAction(_ sender: UIButton) {
        for i in 0 ..< 2 {
            let btn = self.view.viewWithTag(20+i) as! UIButton
            if btn == sender {
                UIView.animate(withDuration: 0.25, animations: {
                    self.materialOrLocateChoosedView.x = btn.x

                }, completion: { (finished) in
                    if finished == true && i == 1 {
                        self.materialBackView.isHidden = true
                        self.locateView.isHidden = false
                    }else if finished == true && i == 0 {
                        self.materialBackView.isHidden = false
                        self.locateView.isHidden = true
                    }
                })
            }else {
                btn.isSelected = false
            }
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        self.tipsMaterialsButton.setTitle(textView.text, for: .normal)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
