//
//  TodayRecommandView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/23.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

@objc protocol FindViewProtocol:NSObjectProtocol {
    @objc optional func seeMoreHots()
    @objc optional func seeMoreNews()
    @objc optional func seeMoreReaders()
    @objc optional func praiseBigStar()
    @objc optional func shareBigStar()
    @objc optional func viewDidSelected(view:ItemView,paint_id:Int64)
    @objc optional func listView(view:UIView,didSelected atIndex:Int)
}

class TodayRecommandView: BaseScrollView {
    var bannerView: BannerView!
    open weak var _cDelegate: FindViewProtocol!
    var _recommandModel:FindTodayRecomModel!
    var recommandModel:FindTodayRecomModel {
        set {
            _recommandModel = newValue
            var images :[String] = Array()
            for item in (self.recommandModel.banner) {
                images.append(item.title_url)
            }
            self.bannerView.bannerImages = images
            self.bannerView.updateUI()
            self.buildNewsHotsView()
        }
        get {
            return _recommandModel
        }
    }
    open weak var cDelegate: FindViewProtocol! {
        set{
            _cDelegate = newValue
        }
        get{
            return _cDelegate
        }
    }
    var newListView: UIView!
    var hotListView: UIView!
    @objc func newMoreAction(_ sender: Any) {
        cDelegate.seeMoreNews!()
    }
    @objc func hotMoreAction(_ sender: Any) {
        cDelegate.seeMoreHots!()
    }
    
    override func buildUI() {
        self.backgroundColor = xsColor_main_white
        bannerView = BannerView.init(frame: CGRect.init(x: 12, y: 12, width: SCREEN_WIDTH - 24, height: 168), false)
        bannerView.layer.cornerRadius = 8
        bannerView.layer.masksToBounds = true
        self.addSubview(bannerView)
        let header1 = FindHeaderView()
        header1.frame = CGRect.init(x: 12, y: bannerView.bottom + 13, width: bannerView.width, height: 40)
        header1.nextButton.setTitle(MRLanguage(forKey: "Recent Art Works"), for: .normal)
        header1.titleLabel.text = MRLanguage(forKey: "Recent Art Works")
        header1.nextButton.addTarget(self, action: #selector(newMoreAction(_:)), for: .touchUpInside)
        header1.layoutIfNeeded()
        self.addSubview(header1)
        newListView = UIView.init(frame:CGRect.init(x: header1.x, y: header1.bottom, width: header1.width, height: 125))
        self.addSubview(newListView)

        let header2 = FindHeaderView()
        header2.frame = CGRect.init(x: 12, y: newListView.bottom + 13, width: bannerView.width, height: 40)
        header2.nextButton.setTitle(MRLanguage(forKey: "Popular Art Works t"), for: .normal)

        header2.titleLabel.text = MRLanguage(forKey: "Popular Art Works t")
        header2.layoutIfNeeded()
        header2.nextButton.addTarget(self, action: #selector(hotMoreAction(_:)), for: .touchUpInside)
        self.addSubview(header2)

        hotListView = UIView.init(frame:CGRect.init(x: header1.x, y: header2.bottom, width: header1.width, height: 125))
        self.addSubview(hotListView)
        self.contentSize = CGSize.init(width: self.width, height: hotListView.bottom + 20)

    }
    
    
    
    func buildNewsHotsView() {
        for i in 0 ..< self.recommandModel.new_arry.count {
            let newItem = self.recommandModel.new_arry[i]
            
            let newView = Bundle.main.loadNibNamed("ItemView", owner: nil, options: nil)?.first as! ItemView
            newView.frame =  CGRect.init(x: (bannerView.width - 5)/2 * CGFloat(i) + 5 * CGFloat(i), y: 0, width: (bannerView.width - 5)/2, height: self.newListView.height)
            newView.delegate = cDelegate
            newView.tag = 100 + i
            newView.model = newItem
            newListView.addSubview(newView)

        }
        
        for i in 0 ..< self.recommandModel.hot_arry.count {
            
            let hotItem = self.recommandModel.hot_arry[i]
            let hotView = Bundle.main.loadNibNamed("ItemView", owner: nil, options: nil)?.first as! ItemView
            hotView.frame =  CGRect.init(x: (bannerView.width - 5)/2 * CGFloat(i) + 5 * CGFloat(i), y: 0, width: (bannerView.width - 5)/2, height: self.newListView.height)
            hotView.delegate = cDelegate
            hotView.tag = 200 + i
            hotView.model = hotItem
            hotListView.addSubview(hotView)
            
        }
        
        self.contentSize = CGSize.init(width: SCREEN_WIDTH - 24, height: hotListView.bottom + NavigationBarBottom + 50)
    }
    
   
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
