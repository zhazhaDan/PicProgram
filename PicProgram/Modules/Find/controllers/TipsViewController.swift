//
//  TipsViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/14.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class TipsViewController: BaseViewController,UITextViewDelegate {
    @IBOutlet weak var localIcon: UIImageView!
    
    @IBOutlet weak var locateView: UIImageView!
    
    @IBOutlet weak var materialBackView: UIView!
    
    @IBOutlet weak var materialOrLocateChoosedView: UIView!
    
    @IBOutlet weak var tipsMaterialsButton: UIButton!
    
    @IBOutlet weak var currentImageView: UIImageView!
    
    @IBOutlet weak var locateChooseStatusView: UIView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var switchSender: UISwitch!
    @IBOutlet weak var switchShowLabel: UILabel!
    
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
        network.requestData(.paint_tips, params: ["tips_content":self.textView.text,"tips_texture":self.chooseMaterialIndex,"tips_location":self.chooseLocatedIndex,"flag":(switchSender.isOn == true ? 2 : 1)], finishedCallback: { [weak self](result) in
            if result["ret"] as! Int == 0 {
                HUDTool.show(.text, text: "Tips设置成功", delay: 0.8, view: (self?.view)!, complete: nil)
            }
        }, nil)
    }

    @IBAction func hintAction(_ sender: Any) {
        let hintView = Bundle.main.loadNibNamed("HintView", owner: nil, options: nil)?.first as! HintView
        hintView.frame = (self.navigationController?.view.bounds)!
        hintView.hintTextLabel.text = "此功能需绑定墨染数字画框使用\n底部点选便签材质、位置\n右上角按钮推送到数字画框硬件端"
        //"此功能需绑定墨染数字画框使用\n底部点选内衬材质、大小\n右上角按钮推送到数字画框硬件端"
        self.navigationController?.view.addSubview(hintView)
    }
    
    @IBAction func tapViewAction(_ sender: UITapGestureRecognizer) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn == false {
            self.switchSender.onTintColor = xsColor_main_white
            self.switchShowLabel.text = "显示到画框端"
        }else {
            self.switchSender.onTintColor = xsColor_main_blue
            self.switchShowLabel.text = "不显示到画框端"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.locateView.isHidden == true {
            return
        }
        let touch = touches.first
        if self.localIcon.frame.contains((touch?.location(in: self.locateView))!) {
            self.lastLocate = (touch?.location(in: self.locateView))!
            self.isLocalViewChoosed = true
            self.tipsMaterialsButton.isHidden = true
            self.textView.isHidden = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isLocalViewChoosed == true {
            let touch = touches.first
            self.localIcon.center = (touch?.location(in: self.locateView))!
            let point = (touch?.location(in: self.locateView))!
            self.locateChooseStatusView.isHidden = false
            self.locateChooseStatusView.frame.origin = CGPoint.init(x: floor(point.x/self.locateChooseStatusView.width) * self.locateChooseStatusView.width, y: floor(point.y/self.locateChooseStatusView.height) * self.locateChooseStatusView.height)
            self.chooseLocatedIndex = Int(floor(self.locateChooseStatusView.x/self.locateChooseStatusView.width)) +  Int(floor(self.locateChooseStatusView.y/self.locateChooseStatusView.height))*2 + 1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.locateView.isHidden == true {
            return
        }
        self.locateChooseStatusView.isHidden = true
        self.isLocalViewChoosed = false
        self.tipsMaterialsButton.isHidden = false
        self.textView.isHidden = false
        self.localIcon.center = self.tipsMaterialsButton.frame.origin
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.locateView.isHidden == true {
            return
        }
        self.localIcon.center = self.tipsMaterialsButton.frame.origin
        self.isLocalViewChoosed = false
        self.locateChooseStatusView.isHidden = true
        self.textView.isHidden = false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view == localIcon {
            return true
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)

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
