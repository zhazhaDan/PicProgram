//
//  LetterViewController.swift
//  PicProgram
//
//  Created by sliencio on 2017/12/19.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class LetterViewController: BaseViewController {
    var coverImageView: UIImageView!
    var contentImageView: UIImageView!
    var backImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate1()
    }
    
    func animate1() {
        UIView.animate(withDuration: 1.21, animations: {
            self.coverImageView.y = self.view.height - self.coverImageView.height - 50
        }) { (finish) in
            if finish == true {
                self.backImageView.y = self.view.height - self.coverImageView.height - 50 - 46
                self.backImageView.x = self.coverImageView.x
                self.backImageView.isHidden = false
                self.animate2()
            }
        }
    }
    
    func animate2() {
        // 1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.x")
        
        // 2.设置动画的属性
        rotationAnim.fromValue = -M_PI
        rotationAnim.toValue = 0
        rotationAnim.repeatCount = 1
        rotationAnim.duration = 1.36
        // 这个属性很重要 如果不设置当页面运行到后台再次进入该页面的时候 动画会停止
        rotationAnim.isRemovedOnCompletion = false
        
        // 3.将动画添加到layer中
        self.backImageView.layer.add(rotationAnim, forKey: nil)
        animate3()
        
//        UIView.animate(withDuration: 0.15, animations: {
//            self.coverImageView.y = self.view.height - self.coverImageView.height - 50
//        }) { (finish) in
//            if finish == true {
//
//            }
//        }
    }
    
    func animate3() {
        self.contentImageView.isHidden = false
        UIView.animate(withDuration: 1.21, animations: {
            self.coverImageView.y = self.view.height - 100
            self.backImageView.y = self.coverImageView.y - self.backImageView.height
            self.contentImageView.y = self.view.height - self.coverImageView.height
        }) { (finish) in
            if finish == true {
                
            }
        }
    }
    
    
    override func buildUI() {
        contentImageView = UIImageView.init(image: #imageLiteral(resourceName: "xf_105"))
        contentImageView.frame = CGRect.init(x: (self.view.width - 241)/2, y: self.view.height, width: 241, height: 375)
        contentImageView.isHidden = true
        self.view.addSubview(contentImageView)

        coverImageView = UIImageView.init(image: UIImage.init(named: "xf_045"))
        coverImageView.frame = CGRect.init(x: (self.view.width - 253)/2, y: self.view.height, width: 253, height: 378)
        self.view.addSubview(coverImageView)
        backImageView = UIImageView.init(image: #imageLiteral(resourceName: "xf_wenzi"))
        backImageView.isHidden = true
        self.view.addSubview(backImageView)
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
