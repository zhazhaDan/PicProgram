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
        let findVC = FindViewController.init(nibName: "FindViewController", bundle: Bundle.main)
        findVC.tabBarItem = UITabBarItem.init(title: "发现", image: #imageLiteral(resourceName: "weixuanzhongfaxian_icon").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "weixuanzhongfaxian_icon"))
        findVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:xsColor("cdb291")], for: .normal)
        findVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:xsColor("a4b7d2")], for: .selected)
        
        let classVC = ClassifyViewController()
        classVC.tabBarItem = UITabBarItem.init(title: "分类", image: #imageLiteral(resourceName: "weixuanzhongfenlei_icon").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "weixuanzhongfenlei_icon"))
        classVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:xsColor("cdb291")], for: .normal)
        classVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:xsColor("a4b7d2")], for: .selected)
        
        let easelVC = EaselViewController()
        easelVC.tabBarItem = UITabBarItem.init(title: "画架", image: #imageLiteral(resourceName: "weixuanzhonghuajia_icon").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "weixuanzhonghuajia_icon"))
        easelVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:xsColor("cdb291")], for: .normal)
        easelVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:xsColor("a4b7d2")], for: .selected)
        
        let minVC = MineViewController()
        minVC.tabBarItem = UITabBarItem.init(title: "我的", image: UIImage.init(named: "weixuanzhongwode_icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.init(named: "weixuanzhongwode_icon"))

        minVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:xsColor("cdb291")], for: .normal)
        minVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:xsColor("a4b7d2")], for: .selected)
        self.viewControllers = [HomePageNavigationController.init(rootViewController:findVC),HomePageNavigationController.init(rootViewController:classVC),UINavigationController.init(rootViewController: easelVC),UINavigationController.init(rootViewController: minVC)]
        
        self.tabBar.tintColor = xsColor("a4b7d2")
        self.selectedIndex = 3
    }

}
