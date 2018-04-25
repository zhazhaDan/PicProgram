//
//  ClassifyViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/7.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class ClassifyViewController: BaseViewController,CustomViewProtocol {
    var selectedIndex:Int = 0
    var customViews:Array<BaseView> = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = MRLanguage(forKey: "Category")
        // Do any additional setup after loading the view.
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = MRLanguage(forKey: "Category")
        customNavigationView()
        self.scrollView?.setContentOffset(CGPoint.init(x: (scrollView?.width)! * CGFloat(selectedIndex), y: 0), animated: true)
        if self.customViews.count > 0 {
            (customViews.first as! ClassifyCommonListView).collecView.setContentOffset(CGPoint.zero, animated: false)
            (customViews.last as! ClassifyCommonListView).collecView.setContentOffset(CGPoint.zero, animated: false)
            (customViews[1] as! EmotionView).collecView.setContentOffset(CGPoint.zero, animated: false)
            let button = self.view.viewWithTag(10) as? UIButton
            titlesSelected(button!)
        }
        self.navigationItem.leftBarButtonItem = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.leftBarButtonItem = nil
        self.title = MRLanguage(forKey: "Category")
    }
    
    override func requestData() {
        if selectedIndex == 0 {
            requestArtData()
        }else if selectedIndex == 2 {
            requestHomeData()
        }else {
            getEmotionData()
        }
    }
    
    func requestArtData(){
        if (self.customViews.first as! ClassifyCommonListView).dataSource.count > 0 {
            return
        }
        HUDTool.show(.loading, view: self.view)
        network.requestData(.classify_get_art_home, params: nil, finishedCallback: { [weak self](result) in
            HUDTool.hide()
            if result["ret"] as! Int == 0 {
                (self?.customViews.first as! ClassifyCommonListView).dataSource = result["art_home_page"] as! Array<[String : Any]>
                (self?.customViews.first as! ClassifyCommonListView).collecView.reloadData()
            }else{
                HUDTool.show(.text, nil, text: result["err"] as! String, delay: 1, view: (self?.view)!, complete: nil)
            }
        }, nil)
    }
    
    func requestHomeData(){
        if (self.customViews[selectedIndex] as! ClassifyCommonListView).dataSource.count > 0 {
            return
        }
        HUDTool.show(.loading, view: self.view)
        network.requestData(.classify_get_scene_home, params: nil, finishedCallback: { [weak self](result) in
            HUDTool.hide()
            if result["ret"] as! Int == 0 {
                (self?.customViews[(self?.selectedIndex)!] as! ClassifyCommonListView).dataSource = result["scene_home_page"] as! Array<[String : Any]>
                (self?.customViews[(self?.selectedIndex)!] as! ClassifyCommonListView).collecView.reloadData()
            }else{
                HUDTool.show(.text, nil, text: result["err"] as! String, delay: 1, view: (self?.view)!, complete: nil)
            }
        }, nil)
    }
    
    func getEmotionData() {
        if (self.customViews[1] as! EmotionView).dataSource.count > 0 {
            return
        }
        let path = BaseBundle.bundle.path(forResource: "EmotionList", ofType: "plist")
        let data = NSArray.init(contentsOfFile: path!) as! Array<[String : Any]>
        (self.customViews[1] as! EmotionView).dataSource = data
        (self.customViews[1] as! EmotionView).collecView.reloadData()
    }
    
    override func buildUI() {
        super.buildUI()
        let titles = [MRLanguage(forKey: "Art"),MRLanguage(forKey: "Mood"),MRLanguage(forKey: "Scenes")]
        let space = (self.view.width - 84*3)/3
        for i in 0 ..< titles.count {
            let button = UIButton.init(frame: CGRect.init(x: space/2 + (space + 84) * CGFloat(i), y: NavigationBarBottom + 5, width: (84), height: 34))
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
        
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: headerLineView.bottom, width: self.view.width, height: self.view.height - headerLineView.bottom - TabbarHeight))
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.isPagingEnabled = true
        scrollView?.isScrollEnabled = false
        scrollView?.isScrollEnabled = false
        scrollView?.isPagingEnabled = true
        self.view.addSubview(scrollView!)
        
        let view1 = ClassifyCommonListView.init(frame: CGRect.init(x: 0, y: 0, width: (scrollView?.width)!, height: (scrollView?.height)!))
        view1.delegate = self
        let view2 = EmotionView.init(frame:  CGRect.init(x: (scrollView?.width)!, y: 0, width: (scrollView?.width)!, height: (scrollView?.height)!))
        view2.delegate = self
        let view3 = ClassifyCommonListView.init(frame:  CGRect.init(x: (scrollView?.width)! * 2, y: 0, width: (scrollView?.width)!, height: (scrollView?.height)!))
        view3.delegate = self
        customViews = [view1,view2,view3]
        self.scrollView?.addSubview(view1)
        self.scrollView?.addSubview(view2)
        self.scrollView?.addSubview(view3)
        

    }

    func customNavigationView() {
        self.navigationController?.navigationBar.barTintColor = xsColor("fcf9eb")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:xsColor_main_text_blue,NSAttributedStringKey.font:xsFont(17)]
        self.baseNavigationController?.addLeftNavigationBarItem("shousuo_icon", "shousuo_icon", leftCallBack: {
            let searchVC = SearchViewController()
            self.navigationController?.pushViewController(searchVC, animated: true)
        })
        self.baseNavigationController?.addRightNavigationBarItems(["08wode_shebeiguanli"], ["08wode_shebeiguanli"]) { (tag) in
            if UserInfo.user.checkUserLogin() {
                let vc = PlayViewController.player
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else {
                let sb = UIStoryboard.init(name: "Mine", bundle: Bundle.main)
                let login = sb.instantiateViewController(withIdentifier: "SBLoginViewController")
                self.present(HomePageNavigationController.init(rootViewController:login), animated: true, completion: nil)
                
            }
           
        }
        self.title = MRLanguage(forKey: "Category")
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
            requestData()
        }
    }

    func listDidSelected(view: UIView, at index: Int, _ section: Int) {
        if view != self.customViews[1] {
            let vc = ClassifyArtListViewController.init(nibName: "ClassifyArtListViewController", bundle: Bundle.main)
            vc.dataSource = (view as! ClassifyCommonListView).dataSource[section]["paints"] as! Array<[String : Any]>
            vc.selectedIndex = index
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = ClassifyEmotionListViewController.init(nibName: "ClassifyEmotionListViewController", bundle: Bundle.main)
            vc.dataSource = (view as! EmotionView).dataSource
            vc.selectedIndex = index
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
