//
//  ClassifyViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/7.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class ClassifyViewController: BaseViewController {
    var selectedIndex:Int = 0
    var customViews:Array<BaseView> = Array()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func buildUI() {
        super.buildUI()
        let titles = ["艺术","心情","场景"]
        let space = (self.view.width - 84*3)/3
        for i in 0 ..< titles.count {
            let button = UIButton.init(frame: CGRect.init(x: space/2 + (space + 84) * CGFloat(i), y: NavigationBarBottom + 5, width: ( 84), height: 34))
            button.setTitle(titles[i], for: .normal)
            button.titleLabel?.font = xsFont(15)
            button.setTitleColor(xsColor_main_yellow, for: .normal)
            button.setTitleColor(xsColor_main_yellow, for: .selected)
            button.setBackgroundImage(#imageLiteral(resourceName: "01faxian_jinrituijian_yuanjiaojuxing"), for: .selected)
            self.view.addSubview(button)
            button.tag = 10 + i
            button.addTarget(self, action: #selector(titlesSelected(_:)), for: .touchUpInside)
            if i == 0 {
                button.isSelected = true
            }
        }
        let headerLineView = UIImageView.init(image: #imageLiteral(resourceName: "jianbiantiao"))
        headerLineView.frame = CGRect.init(x: 0, y: NavigationBarBottom + 44, width: self.view.width, height: 6)
        self.view.addSubview(headerLineView)
        customNavigationView()
        
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: headerLineView.bottom, width: self.view.width, height: self.view.height - headerLineView.bottom))
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.isPagingEnabled = true
        scrollView?.isScrollEnabled = false
        scrollView?.isScrollEnabled = false
        scrollView?.isPagingEnabled = true
        self.view.addSubview(scrollView!)
        
        let view1 = ClassifyBaseListView.init(frame: CGRect.init(x: 0, y: 0, width: (scrollView?.width)!, height: (scrollView?.height)!))
        let view2 = EmotionView.init(frame:  CGRect.init(x: (scrollView?.width)!, y: 0, width: (scrollView?.width)!, height: (scrollView?.height)!))
        let view3 = ClassifyBaseListView.init(frame:  CGRect.init(x: (scrollView?.width)! * 2, y: 0, width: (scrollView?.width)!, height: (scrollView?.height)!))
        customViews = [view1,view2,view3]
        selectedIndex = 1
        self.scrollView?.addSubview(view1)
        self.scrollView?.addSubview(view2)
        self.scrollView?.addSubview(view3)
        

    }
    
    
    
    func customNavigationView() {
        self.navigationController?.navigationBar.barTintColor = xsColor("fcf9eb")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:xsColor_main_text_blue]
        self.baseNavigationController?.addLeftNavigationBarItem("shousuo_icon", "shousuo_icon", leftCallBack: {
            let searchVC = SearchViewController()
            self.navigationController?.pushViewController(searchVC, animated: true)
        })
        self.baseNavigationController?.addRightNavigationBarItems(["08wode_shebeiguanli"], ["08wode_shebeiguanli"]) { (tag) in
            print("去登录")
        }
        self.title = "分类"
    }
    
    
    @objc func titlesSelected(_ sender: UIButton) {
        for i in [0,1,2] {
            if let button = self.view.viewWithTag(10 + i) as? UIButton {
                if button == sender {
                    button.isSelected = true
                    selectedIndex = i
                }else {
                    button.isSelected = false
                }
            }
            self.scrollView?.setContentOffset(CGPoint.init(x: (scrollView?.width)! * CGFloat(selectedIndex), y: 0), animated: true)
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
