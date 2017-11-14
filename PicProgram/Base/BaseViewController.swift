//
//  BaseViewController.swift
//  VirtualGarage
//
//  Created by 龚丹丹 on 2017/9/10.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var scrollView:UIScrollView?
    var backTitle:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = xsColor_main_white
        self.automaticallyAdjustsScrollViewInsets = false
        // 这个方法是为了，不让隐藏状态栏的时候出现view上移
        self.extendedLayoutIncludesOpaqueBars = true
        self.view.backgroundColor = xsColor_main_white
        buildUI()
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.backItem?.title = backTitle
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: backTitle, style: .done, target: nil, action: nil)

    }
    
    func buildUI() {
    }
    
    func requestData() {
        
    }
    
    var baseNavigationController: BaseNavigationController? {
        set(newValue){
        }
        get{
            return (navigationController as! BaseNavigationController)
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
