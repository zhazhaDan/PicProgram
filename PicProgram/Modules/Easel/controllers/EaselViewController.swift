//
//  EaselViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/16.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class EaselViewController: BaseViewController,CustomViewProtocol {

    @IBOutlet weak var segButtonsHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var chooseBottomView: UIView!
    var selectedAtIndex:Int = 0
    var view1 : PaintFrameListView!
    var view2 : PicturesView!
    var view3 : PaintFrameListView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLocalPaintsDatas()
        updateHistoryPaintDatas()
        loadCollectDatas()
        self.title = MRLanguage(forKey: "Art Works")
        if view1 != nil {
            view1.collectionView.setContentOffset(CGPoint.zero, animated: false)
            view2.collecView.setContentOffset(CGPoint.zero, animated: false)
            view3.collectionView.setContentOffset(CGPoint.zero, animated: false)
            let button = self.view.viewWithTag(10) as? UIButton
            titleChooseAction(button!)
        }
        self.contentScrollView.setContentOffset(CGPoint.init(x: CGFloat(selectedAtIndex) * SCREEN_WIDTH, y: 0), animated: false)
        self.navigationItem.leftBarButtonItem = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = MRLanguage(forKey: "Art Works")
        self.navigationItem.leftBarButtonItem = nil
    }
    
   
    override func buildUI() {
        self.customNavigationView()
        view1 = PaintFrameListView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - segButtonsHeightConstrain.constant - TabbarHeight - NavigationBarBottom))
        view1.delegate = self
        self.contentScrollView.addSubview(view1)
        
        view2 = PicturesView.init(frame: CGRect.init(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: view1.height))
        view2.delegate = self
        self.contentScrollView.addSubview(view2)
        
        view3 = PaintFrameListView.init(frame: CGRect.init(x: SCREEN_WIDTH * 2, y: 0, width: SCREEN_WIDTH, height: view1.height))
        view3.delegate = self
        self.contentScrollView.addSubview(view3)
  }
    
    func customNavigationView() {
        self.navigationController?.navigationBar.barTintColor = xsColor("fcf9eb")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:xsColor_main_text_blue]
        self.navigationItem.leftBarButtonItem = nil
    }
    
    @IBAction func titleChooseAction(_ sender: UIButton) {
        for i in 0 ..< 3 {
            let btn = self.view.viewWithTag(10+i) as! UIButton
            if btn == sender {
                self.chooseBottomView.x = btn.x
                selectedAtIndex = sender.tag - 10
                contentScrollView.setContentOffset(CGPoint.init(x: contentScrollView.width * CGFloat(i), y: 0), animated: true)
            }
        }
    }
    //更新数据
    func updateHistoryPaintDatas() {
        view2.requestData()
    }
    func loadLocalPaintsDatas() {
        var datas:[PaintModel] = Array()
        for item in Paint.fetchAllLocalPaint()! {
            let model = PaintModel.init(paint: item)
            datas.append(model)
        }
        if datas.count == 0 {
            let paint = Paint.fetchPaint(key: .name, value: MRLanguage(forKey: "My collection"), create: true, painttype: 1)
            let model = PaintModel.init(paint: paint!)
            datas.append(model)
            do {
                try appDelegate.managedObjectContext.save()
            }catch{}
        }
        
        view1.dataSource = datas
    }
    
    func loadCollectDatas() {
        network.requestData(.user_collect_list, params: nil, finishedCallback: { (result) in
            if result["ret"] as! Int == 0 {
                if result["paint_arry"] != nil {
                    var datas:[PaintModel] = Array()
                    for item in (result["paint_arry"] as! Array<[String:Any]>) {
                        let model = PaintModel.init(dict: item)
                        datas.append(model)
                    }
                    self.view3.dataSource = datas
                 }
            }
        }, nil)
    }
    
    
    func listDidSelected(view: UIView, at index: Int, _ section: Int) {
        if view == view1 {
            let layout = UICollectionViewFlowLayout.init()
            let vc = PicDetailCollectionViewController.init(collectionViewLayout: layout)
            vc.paintModel = view1.dataSource[index]
            self.navigationController?.pushViewController(vc, animated: true)
        }else if view == view2 {
            if UserInfo.user.checkUserLogin() {
                let vc = PlayViewController.player
                vc.dataSource = view2.dataSource
                vc.currentIndex = index
                vc.title = MRLanguage(forKey: "Recent viewed")//view2.dataSource[index].title
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let sb = UIStoryboard.init(name: "Mine", bundle: Bundle.main)
                let login = sb.instantiateViewController(withIdentifier: "SBLoginViewController")
                self.present(HomePageNavigationController.init(rootViewController:login), animated: true, completion: nil)
                
            }
            
        }else if view == view3 {
            let layout = UICollectionViewFlowLayout.init()
            let vc = PicDetailCollectionViewController.init(collectionViewLayout: layout)
            vc.paintModel = view3.dataSource[index]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func listWillDelete(view: UIView, at index: Int, _ section: Int) {
        if view == view1 {//本地删除
            HUDTool.show(.loading, text: MRLanguage(forKey: "Deleting"), delay: 0.6, view: self.view, complete: nil)
            let paint = Paint.fetchPaint(key: .name, value: view1.dataSource[index].paint_title, create: false, painttype: 1)
            if paint != nil {
                appDelegate.managedObjectContext.delete(paint!)
                do {
                    HUDTool.hide()
                    try appDelegate.managedObjectContext.save()
                    HUDTool.show(.text, text: MRLanguage(forKey: "Delete Success"), delay: 0.6, view: self.view, complete: {[weak self] in
                        self?.view1.dataSource.remove(at: index)
                        self?.view1.collectionView.reloadData()
                    })
                }catch{}
            }
        }else if view == view3 {//发送请求
            HUDTool.show(.loading, text: MRLanguage(forKey: "Deleting"), delay: 0.6, view: self.view, complete: nil)
            network.requestData(.paint_collect, params: ["paint_id":view3.dataSource[index].paint_id], finishedCallback: { [weak self](result) in
                HUDTool.hide()
                if result["ret"] as! Int == 0 {
                    HUDTool.show(.text, text: MRLanguage(forKey: "Delete Success"), delay: 0.6, view: (self?.view)!, complete: {[weak self] in
                        self?.view3.dataSource.remove(at: index)
                        self?.view3.collectionView.reloadData()
                    })
                }
                }, nil)
        }
    }
}
