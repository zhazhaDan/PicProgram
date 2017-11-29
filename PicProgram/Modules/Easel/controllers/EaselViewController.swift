//
//  EaselViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/16.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class EaselViewController: BaseViewController {

    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var chooseBottomView: UIView!
    var selectedAtIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func buildUI() {
        self.customNavigationView()
        let view1 = PaintFrameListView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: self.contentScrollView.height))
        self.contentScrollView.addSubview(view1)
    }
    
    func customNavigationView() {
        self.navigationController?.navigationBar.barTintColor = xsColor("fcf9eb")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:xsColor_main_text_blue]
        self.title = LocalizedLanguageTool().getString(forKey: "Art Works")
    }
    
    @IBAction func titleChooseAction(_ sender: UIButton) {
        for i in 0 ..< 3 {
            let btn = self.view.viewWithTag(10+i) as! UIButton
            if btn == sender {
                self.chooseBottomView.x = btn.x
                selectedAtIndex = sender.tag - 10
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
