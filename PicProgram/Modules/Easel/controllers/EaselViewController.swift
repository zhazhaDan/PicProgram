//
//  EaselViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/16.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class EaselViewController: BaseViewController,CustomViewProtocol {

    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var chooseBottomView: UIView!
    var selectedAtIndex:Int = 0
    var view1 : PaintFrameListView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLocalPaintsDatas()
    }
    
    override func buildUI() {
        self.customNavigationView()
        view1 = PaintFrameListView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: self.contentScrollView.height))
        view1.delegate = self
        self.contentScrollView.addSubview(view1)
    }
    
    func customNavigationView() {
        self.navigationController?.navigationBar.barTintColor = xsColor("fcf9eb")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:xsColor_main_text_blue]
        self.title = MRLanguage(forKey: "Art Works")
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
    
    func loadLocalPaintsDatas() {
        var datas:[PaintModel] = Array()
        for item in Paint.fetchAllLocalPaint()! {
            let model = PaintModel.init(paint: item)
            datas.append(model)
        }
        view1.dataSource = datas
    }
    
    func listDidSelected(view: UIView, at index: Int, _ section: Int) {
        if view == view1 {
            let layout = UICollectionViewFlowLayout.init()
            let vc = PicDetailCollectionViewController.init(collectionViewLayout: layout)
            vc.paintModel = view1.dataSource[index]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
