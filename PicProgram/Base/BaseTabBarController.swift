//
//  BaseTabBarController.swift
//  VirtualGarage
//
//  Created by 龚丹丹 on 2017/9/10.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sleep(2)//启动图延时
        buildBarControllers()
        // Do any additional setup after loading the view.
    }
    func buildBarControllers() {
        
        let normalAttris = [NSAttributedStringKey.foregroundColor:xsColor("cdb291"),NSAttributedStringKey.font:xsFont(10)]
        let selectedAttris = [NSAttributedStringKey.foregroundColor:xsColor("a4b7d2"),NSAttributedStringKey.font:xsFont(10)]
        
        let findVC = FindViewController.init(nibName: "FindViewController", bundle: Bundle.main)
        findVC.tabBarItem = UITabBarItem.init(title: MRLanguage(forKey: "Discover"), image: #imageLiteral(resourceName: "weixuanzhongfaxian_icon").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "weixuanzhongfaxian_icon"))
        findVC.tabBarItem.setTitleTextAttributes(normalAttris, for: .normal)
        findVC.tabBarItem.setTitleTextAttributes(selectedAttris, for: .selected)
        
        let classVC = ClassifyViewController()
        classVC.tabBarItem = UITabBarItem.init(title: MRLanguage(forKey: "Category"), image: #imageLiteral(resourceName: "weixuanzhongfenlei_icon").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "weixuanzhongfenlei_icon"))
        classVC.tabBarItem.setTitleTextAttributes(normalAttris, for: .normal)
        classVC.tabBarItem.setTitleTextAttributes(selectedAttris, for: .selected)
        
        let easelVC = EaselViewController()
        easelVC.tabBarItem = UITabBarItem.init(title: MRLanguage(forKey: "Art Works"), image: #imageLiteral(resourceName: "weixuanzhonghuajia_icon").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "weixuanzhonghuajia_icon"))
        easelVC.tabBarItem.setTitleTextAttributes(normalAttris, for: .normal)
        easelVC.tabBarItem.setTitleTextAttributes(selectedAttris, for: .selected)
        
        let minVC = MineViewController.init(nibName: "MineViewController", bundle: Bundle.main)
        minVC.tabBarItem = UITabBarItem.init(title: MRLanguage(forKey: "My Account"), image: UIImage.init(named: "weixuanzhongwode_icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.init(named: "weixuanzhongwode_icon"))

        minVC.tabBarItem.setTitleTextAttributes(normalAttris, for: .normal)
        minVC.tabBarItem.setTitleTextAttributes(selectedAttris, for: .selected)
        self.viewControllers = [HomePageNavigationController.init(rootViewController:findVC),HomePageNavigationController.init(rootViewController:classVC),HomePageNavigationController.init(rootViewController: easelVC),HomePageNavigationController.init(rootViewController: minVC)]
        
        self.tabBar.tintColor = xsColor("a4b7d2")
//        self.selectedIndex = 3
    }

}
