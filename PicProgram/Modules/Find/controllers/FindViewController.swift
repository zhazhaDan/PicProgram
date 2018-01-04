//
//  FindViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/22.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class FindViewController: BaseViewController,BannerViewProtocol,FindViewProtocol {
    var bannerDataSource:Array<[String:Any]> = Array()
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var lineView: UIView!
    var recommandModel:FindTodayRecomModel!
    var pioneerModel:PioneerModel!
    var selectedIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        self.currentView.addSubview(todayView)
    }

    
    @IBAction func chooseViewAction(_ sender: UIButton) {
        selectedIndex = sender.tag - 10
        if sender.isSelected == true {
            return
        }else if sender.tag == 11 {
            sender.isSelected = true
            let btn:UIButton = self.view.viewWithTag(10) as! UIButton
            btn.isSelected = false
            //艺术先锋
            self.currentView.addSubview(artView)
            if self.pioneerModel == nil {
                requestData()
            }
            artView.readTableView.setContentOffset(CGPoint.zero, animated: true)
        }else if sender.tag == 10 {
            sender.isSelected = true
            let btn:UIButton = self.view.viewWithTag(11) as! UIButton
            btn.isSelected = false
            //今日推荐
            self.currentView.addSubview(todayView)
        }
    }
    var _today:TodayRecommandView!
    var todayView:TodayRecommandView {
        get{
            if _today == nil {
                _today = TodayRecommandView()
                _today.bannerView.delegate = self
                _today.cDelegate = self
            }
            return _today
        }
        set{
            _today = newValue
        }
    }
    var _art:ArtView!
    var artView:ArtView {
        get{
            if _art == nil {
                _art = ArtView.init(frame:self.currentView.bounds)
                _art.bannerView.delegate = self
                _art.cDelegate = self
            }
            return _art
        }
        set{
            _art = newValue
        }
        
    }
    
    override func buildUI() {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        todayView.frame = self.currentView.bounds
        customNavigationView()
        self.navigationItem.leftBarButtonItem = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func customNavigationView() {
        self.navigationController?.navigationBar.barTintColor = xsColor("fcf9eb")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:xsColor_main_text_blue,NSAttributedStringKey.font:xsFont(17)]

        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 320, height: 26))
        button.setBackgroundImage(#imageLiteral(resourceName: "01faixian_jinrituijian_shousuolan"), for: .normal)
        button.setTitle("艺术品名称/作者", for: .normal)
        button.setImage(#imageLiteral(resourceName: "01faxian_jinrituijian_shousuo"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        button.titleLabel?.font = xsFont(12)
        button.setTitleColor(xsColor_placeholder_grey, for: .normal)
        button.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        self.baseNavigationController?.addRightNavigationBarItems(["08wode_shebeiguanli"], ["08wode_shebeiguanli"]) { [weak self](tag) in
            if UserInfo.user.checkUserLogin() {
                let vc = PlayViewController.player
                self?.navigationController?.pushViewController(vc, animated: true)
            }else {
                let sb = UIStoryboard.init(name: "Mine", bundle: Bundle.main)
                let login = sb.instantiateViewController(withIdentifier: "SBLoginViewController")
                self?.present(HomePageNavigationController.init(rootViewController:login), animated: true, completion: nil)
                
            }
            
        }
        self.baseNavigationController?.topViewController?.navigationItem.titleView = button
    }
    
    func bannerViewDidSelected(view: BannerView, _ index: Int) {
        if view == self.todayView.bannerView {
            let layout = UICollectionViewFlowLayout.init()
            let vc = PicDetailActCollectionViewController.init(collectionViewLayout: layout)
            vc.paint_id = self.recommandModel.banner[index].paint_id
            vc.title = "今日推荐"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if view == self.artView.bannerView {
            let layout = UICollectionViewFlowLayout.init()
            let vc = PicDetailCollectionViewController.init(collectionViewLayout: layout)
            vc.title = "艺术先锋"
            vc.paint_id = self.pioneerModel.banner[index].paint_id
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    
    @objc func searchAction() {
        let searchVC = SearchViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    override func requestData() {
        var apiType:RequestAPIType = .discovery_recommend
        if selectedIndex == 1 {
            apiType = .discovery_poineer
        }
        HUDTool.show(.loading, view: self.view)
        network.requestData(apiType, params: nil, finishedCallback: { [weak self](result) in
            HUDTool.hide()
            if result["ret"] as! Int == 0 {
                if self?.selectedIndex == 0 {
                    self?.recommandModel = FindTodayRecomModel.init(dict: result["recommend_home_page"] as! [String : Any])
                    self?.todayView.recommandModel = (self?.recommandModel)!
                }else {
                    self?.pioneerModel = PioneerModel.init(dict: result["pioneer_home"] as! [String : Any])
                    self?.artView.pioneerModel = (self?.pioneerModel)!
                }
            }
        }, nil)
    }
    
    func seeMoreNews() {
        let controller = RecommandListCollectionViewController()
        controller.title = "最新"
        controller.type = 1
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func seeMoreHots() {
        let controller = RecommandListCollectionViewController()
        controller.title = "最热"
        controller.type = 2
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func seeMoreReaders() {
        let vc = ReadListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func viewDidSelected(view: ItemView, paint_id: Int64) {
        let layout = UICollectionViewFlowLayout.init()
        let vc = PicDetailCollectionViewController.init(collectionViewLayout: layout)
        vc.paintModel = view.model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func listView(view: UIView, didSelected atIndex: Int) {
        if view == artView {
            let data = self.pioneerModel.classic_quote[atIndex]
            let vc = WebViewController()
            vc.urlString = data.cq_h5_url
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
//    func praiseBigStar() {
//        network.requestData(.discovery_mqlove, params: ["mq_id":pioneerModel.master_quote.mq_id], finishedCallback: { (result) in
//            if result["ret"] as! Int == 0 {
//
//            }
//        }, nil)
//    }
    func shareBigStar() {
        let view = Bundle.main.loadNibNamed("BigStarShareView", owner: self, options: nil)?.first as! BigStarShareView
        
        
        view.cell.contentLabel.text = pioneerModel.master_quote.mq_content
        view.cell.sayNumLabel.isHidden = true
        let date = Date()
        view.cell.weendayLabel.text = date.getDayOfWeek()
        view.cell.dateLabel.text = date.getUpperDate()
        view.cell.praiseButton.isHidden = true
        view.cell.shareButton.isHidden = true
        
        
        view.frame = UIScreen.main.bounds
        self.tabBarController?.view.addSubview(view)
    }
    
}
