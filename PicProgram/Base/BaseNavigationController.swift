//
//  BaseNavigationViewController.swift
//  VirtualGarage
//
//  Created by 龚丹丹 on 2017/9/10.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //隐藏导航栏黑线
        for view in self.navigationBar.allSubviews() {
            if type(of: view)  == UIImageView.self {
                view.isHidden = true
            }
        }
        //设置导航栏颜色
//        self.navigationBar.barTintColor = xsColor_main_white
        //设置导航栏返回按钮样式
//        let backImage = UIImage.init(named: "fanhui")
//        navigationBar.backIndicatorImage = backImage
//        navigationBar.backIndicatorTransitionMaskImage = backImage
        
    }

    open var leftItemCallBack:(() -> Void)?
    func addLeftNavigationBarItem(_ imageName:String = "fanhui",_ selectImageName:String = "fanhui",leftCallBack:@escaping ()->Void) {
        let image = UIImage.init(named: imageName)
        leftItemCallBack = leftCallBack
        let leftButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0)

        leftButton.setImage(image, for: .normal)
        leftButton.setImage(UIImage.init(named: selectImageName), for: .selected)
        leftButton.setImage(UIImage.init(named: selectImageName), for: .highlighted)
        leftButton.addTarget(self, action: #selector(leftNavigationBarAction), for: .touchUpInside)
        let barItem = UIBarButtonItem.init(customView: leftButton)
        self.topViewController?.navigationItem.leftBarButtonItem = barItem
    }
    @objc func leftNavigationBarAction() {
        if (leftItemCallBack != nil) {
            leftItemCallBack!()
        }
    }
    
    open var rightItemCallBack:((Int) -> Void)?
    func addRightNavigationBarItems(_ imageNames:[String]? = nil,_ selectImageNames:[String]? = nil,_ titles:[String]? = nil,rightCallBack:@escaping (Int)->Void) {
        var imageItems : Array = [UIBarButtonItem]()
        if (imageNames != nil) && imageNames?.count as! Int > 0 {
            for i in 0 ..< (imageNames?.count as! Int) {
                let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 44))
                let image = UIImage.init(named: imageNames![(imageNames?.count)! - i - 1])
                button.setImage(image, for: .normal)
                button.setImage(UIImage.init(named: selectImageNames![(imageNames?.count)! - i - 1]), for: .highlighted)
//                button.frame =  CGRect.init(x: 0, y: 0, width: (image?.size.width)!, height: 44)
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20)
                button.addTarget(self, action: #selector(rightNavigationBarAction(_:)), for: .touchUpInside)
                let barItem = UIBarButtonItem.init(customView: button)
                button.tag = 1000+(imageNames?.count)! - i - 1
                imageItems.append(barItem)
            }
        }else {
            for i in 0 ..< (titles?.count)! - 1 {
                let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 44))
                button.setTitle(titles?[(titles?.count)! - i - 1], for: .normal)
                button.setTitleColor(xsColor_text_lightblack, for: .normal)
                button.titleLabel?.font = xsFont(14)
                button.addTarget(self, action: #selector(rightNavigationBarAction(_:)), for: .touchUpInside)
                let barItem = UIBarButtonItem.init(customView: button)
                button.tag = 1000+(titles?.count)! - i - 1
                imageItems.append(barItem)
            }
           
        }
        rightItemCallBack = rightCallBack
        self.topViewController?.navigationItem.rightBarButtonItems = imageItems
    }
    
    
    //按照栈内顺序选择，homepage 的index 0
    func popToViewController(_ index:Int,_ auto:Bool = false) {
        var vcs = (self.viewControllers)
        let count = (vcs.count)
        let pageIndex = index
//        if auto == true {
//            if viewControllers.count > 2 && (viewControllers[1] is AreaDetailViewController || viewControllers[1] is OrderListViewController) {
//                pageIndex = 1
//            }else {
//                pageIndex = 0
//            }
//        }
        for (i,_) in (vcs.enumerated()) {
            if (i < count - 1) && i > pageIndex{
                vcs.remove(at: pageIndex + 1)
            }
        }
        self.setViewControllers(vcs, animated: true)
        
    }
    
    
    @objc func rightNavigationBarAction(_ sender:UIButton) {
        if (rightItemCallBack != nil) {
            rightItemCallBack!(sender.tag - 1000)
        }
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let vc =  super.popViewController(animated: animated)
        vc?.navigationController?.navigationItem.title = ""
        vc?.navigationController?.navigationBar.backItem?.title = ""
        return vc
    }
   
//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        if viewController.isKind(of: BaseViewController.self) {
//            let backTitle = (viewController as! BaseViewController).backTitle
////            viewController.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: backTitle, style: .done, target: nil, action: nil)
//            viewController.navigationController?.navigationBar.backItem?.title = backTitle
//        }
//        super.pushViewController(viewController, animated: animated)
//    }
}
