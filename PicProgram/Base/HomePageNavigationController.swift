//
//  HomePageNavigationController.swift
//  VirtualGarage
//
//  Created by 龚丹丹 on 2017/9/13.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class HomePageNavigationController: BaseNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        buildNavigationBarItem()
//        let backImage = UIImage.init(named: "fanhui")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 40, 0, 0), resizingMode: .tile)
//        UIBarButtonItem().setBackgroundImage(backImage, for: .normal, barMetrics: .default)
//        UIBarButtonItem().setTitlePositionAdjustment(UIOffsetMake(CGFloat.leastNormalMagnitude, CGFloat.leastNormalMagnitude), for: .default)
//        UIBarButtonItem().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -60), for: .default)
//        let backItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
//        self.topViewController?.navigationItem.backBarButtonItem = backItem
    }
    
    func buildNavigationBarItem() {
//        self.addLeftNavigationBarItem("QR_scan_normal","QR_scan_pressed", leftCallBack: {
//            let scanVC = ScanQRCodeViewController()
//            scanVC.backTitle = "扫码"
//            (appDelegate.window?.rootViewController as! UINavigationController).pushViewController(scanVC, animated: true)
//        })
//        self.addRightNavigationBarItems(["search_normal","interact_normal"], ["search_pressed","interact_pressed"], nil, rightCallBack: { (tag) in
//            if tag == 0 {
//                HUDTool.show(.text, text: "该功能暂未开放", delay: 1, view: appDelegate.window!, complete: nil)
//            }else if tag == 1 {
//                let chatVC = ChatViewController()
//                chatVC.backTitle = "虚拟互动"
//                (appDelegate.window?.rootViewController as! UINavigationController).pushViewController(chatVC, animated: true)
//            }
//        })
        self.navigationBar.tintColor = xsColor_main_yellow
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font:xsFont(17),NSAttributedStringKey.foregroundColor:xsColor_main_blue]
        
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
        if self.viewControllers.count == 1 {
            viewController.hidesBottomBarWhenPushed = false
        }
    }

}
