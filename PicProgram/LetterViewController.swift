//
//  LetterViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/12/19.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit
var isShow:Bool = false
private let time1 = 1.21
private let time2 = 0.3
private let time3 = 2.42
class LetterViewController: BaseViewController {
    var imageView:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func buildUI() {
        imageView = UIImageView.init(frame: self.view.bounds)
       
        self.view.addSubview(imageView)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate1()
        self.perform(#selector(self.stopAnimate), with: nil, afterDelay: time1, inModes: [RunLoopMode.commonModes,RunLoopMode.UITrackingRunLoopMode])

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isShow == true {
            return
        }
        animate2()
        isShow = true
        self.perform(#selector(self.animate3), with: nil, afterDelay: time2, inModes: [RunLoopMode.commonModes,RunLoopMode.UITrackingRunLoopMode])
        self.perform(#selector(self.stopAnimate), with: nil, afterDelay: time2, inModes: [RunLoopMode.commonModes,RunLoopMode.UITrackingRunLoopMode])

    }
    func animate1() {
        var images:[UIImage] = Array()
        for i in 0 ..< 46 {
            if #available(iOS 8, *) {
                images.append(UIImage(named: "xf_\(i)", in: Bundle.main, compatibleWith: nil)!)
            } else {
                images.append(UIImage(named: "xf_\(i)")!)
            }
        }
        imageView.animationDuration = time1
        imageView.animationRepeatCount = 1
        imageView.animationImages = images
        imageView.image = images.last
        imageView.startAnimating()
    }
    
    @objc func stopAnimate() {
        imageView.stopAnimating()
    }
    
    
    func animate2() {
        var images:[UIImage] = Array()
        for i in 46 ..< 61 {
            if #available(iOS 8, *) {
                images.append(UIImage(named: "xf_\(i)", in: Bundle.main, compatibleWith: nil)!)
            } else {
                images.append(UIImage(named: "xf_\(i)")!)
            }
        }
        imageView.animationDuration = time2
        imageView.animationRepeatCount = 1
        imageView.animationImages = images
        imageView.image = images.last
        imageView.startAnimating()
    }
    
    @objc func animate3(){
        var images:[UIImage] = Array()
        for i in 61 ..< 106 {
            if #available(iOS 8, *) {
                images.append(UIImage(named: "xf_\(i)", in: Bundle.main, compatibleWith: nil)!)
            } else {
                images.append(UIImage(named: "xf_\(i)")!)
            }
        }
        imageView.animationDuration = time3
        imageView.animationRepeatCount = 1
        imageView.animationImages = images
        imageView.image = images.last
        imageView.startAnimating()
        self.perform(#selector(self.stopAnimate), with: nil, afterDelay: time3, inModes: [RunLoopMode.commonModes,RunLoopMode.UITrackingRunLoopMode])

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
