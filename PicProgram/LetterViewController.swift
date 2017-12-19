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
       imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
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
//        self.perform(#selector(self.stopAnimate), with: nil, afterDelay: time2, inModes: [RunLoopMode.commonModes,RunLoopMode.UITrackingRunLoopMode])

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
        for i in 61 ..< 105 {
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
        self.perform(#selector(self.stopBuildUI), with: nil, afterDelay: time3, inModes: [RunLoopMode.commonModes,RunLoopMode.UITrackingRunLoopMode])
//        self.perform(#selector(self.stopAnimate), with: nil, afterDelay: time3, inModes: [RunLoopMode.commonModes,RunLoopMode.UITrackingRunLoopMode])

    }
    
    @objc func stopBuildUI() {
        let button1 = UIButton.init(frame: CGRect.init(x: 70, y: imageView.height - 180, width: 80, height: 35))
        button1.tag = 10
        imageView.addSubview(button1)
        let button2 = UIButton.init(frame: CGRect.init(x: self.imageView.width - 150, y: button1.y, width: button1.width, height: 35))
        button2.tag = 11

        imageView.addSubview(button2)
        let button3 = UIButton.init(frame: CGRect.init(x: 80, y: self.imageView.height - 70, width: imageView.width - 160, height: 35))
        imageView.addSubview(button3)
        let button4 = UIButton.init(frame: CGRect.init(x: button3.x, y: button3.bottom, width: button3.width, height: 35))
        button4.titleLabel?.font = xsFont(17)
        button4.setTitleColor(xsColor_main_black, for: .normal)
        button4.setTitle("不再显示", for: .normal)
        imageView.addSubview(button4)
        button3.tag = 13
        button4.tag = 14
        button1.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        button3.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        button4.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)

    }
    
    @objc func buttonAction(_ sender :UIButton) {
        if sender.tag == 11 || sender.tag == 13 || sender.tag == 14{
            self.dismiss(animated: true, completion: nil)
        }else if sender.tag == 10{
            self.dismiss(animated: false, completion: {
                let sb = UIStoryboard.init(name: "Mine", bundle: Bundle.main)
                let login = sb.instantiateViewController(withIdentifier: "SBLoginViewController")
                appDelegate.window?.rootViewController?.present(HomePageNavigationController.init(rootViewController: login), animated: true, completion: nil)

            })
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
