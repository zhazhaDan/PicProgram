//
//  TipsViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/14.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class TipsViewController: BaseViewController,UITextViewDelegate {

    
    
    @IBOutlet weak var materialOrLocateChoosedView: UIView!
    
    @IBOutlet weak var tipsMaterialsButton: UIButton!
    
    @IBOutlet weak var currentImageView: UIImageView!
    var picModel:PictureModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentImageView.xs_setImage(picModel.picture_url)
        // Do any additional setup after loading the view.
    }

    @IBAction func panTipsLocate(_ sender: Any) {
    }
    @IBAction func tipsMaterialChooseAction(_ sender: UIButton) {
        for i in 0 ..< 3 {
            let btn = self.view.viewWithTag(10+i) as! UIButton
            if btn == sender {
                btn.isSelected = true
            }else {
                btn.isSelected = false
            }
        }
    }
    @IBAction func materialOrLocateAction(_ sender: UIButton) {
        for i in 0 ..< 2 {
            let btn = self.view.viewWithTag(20+i) as! UIButton
            if btn == sender {
                btn.isSelected = true
                UIView.animate(withDuration: 0.25, animations: {
                    self.materialOrLocateChoosedView.x = btn.x
                })
            }else {
                btn.isSelected = false
            }
        }
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
