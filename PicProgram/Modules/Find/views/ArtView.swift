//
//  ArtView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/23.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class ArtView: BaseView,UITableViewDelegate,UITableViewDataSource,FindViewProtocol {
    
//    @IBOutlet weak var nextButton: UIButton!
    
    var readTableView: UITableView!
    var bannerView: BannerView!
    open weak var cDelegate: FindViewProtocol!
    var dataSource:[ClassicQuoteModel] = []
    var _pioneerModel:PioneerModel!
    var isFold:Bool = false
    var cell:ArtMasterSayTableViewCell!
    var cell2:ArtMasterSayTableViewCell!
    var bigStarSayBackView:UIView!
    var view1:UIView!
    var view2:UIView!
    var view1MaskLayer:CAGradientLayer!
    var view2MaskLayer:CAGradientLayer!
    var headerView:UIView!
    var pioneerModel:PioneerModel {
        set {
            _pioneerModel = newValue
            var images :[String] = Array()
            for item in (_pioneerModel.banner) {
                images.append(item.title_url)
            }
            buildBigStarSayUI()
            self.bannerView.bannerImages = images
            self.bannerView.updateUI()
            self.readTableView.reloadData()
        }
        get {
            return _pioneerModel
        }
    }

    override func buildUI() {
//        let bannerBackView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 180))
//        bannerBackView.backgroundColor = xsColor_main_white
        bannerView = BannerView.init(frame: CGRect.init(x: 12, y: 12, width: self.width - 24, height: 168),false,true)
        bannerView.layer.cornerRadius = 8
        bannerView.layer.masksToBounds = true
        readTableView = UITableView.init(frame: self.bounds, style:.grouped)
//        readTableView.height -= TabbarHeight
        readTableView.backgroundColor = xsColor_main_white
        readTableView.delegate = self
        readTableView.dataSource = self
        readTableView.separatorStyle = .none
        self.readTableView.register(UINib.init(nibName: "ArtReadTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "readTableViewCell")
//        self.readTableView.register(UINib.init(nibName: "ArtMasterSayTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ArtMasterSayTableViewCell")
        self.readTableView.register(UINib.init(nibName: "ArtHeaderView", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: "header")
        self.readTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "footer")
        self.addSubview(self.readTableView)
        bigStarSayBackView = UIView.init(frame: CGRect.init(x: 0, y: 180, width: SCREEN_WIDTH, height: 230))
//        headerView.addSubview(bigStarSayBackView)

//        bannerBackView.addSubview(bannerView)
//        self.addSubview(bannerBackView)

    }
    
    
    func buildBigStarSayUI() {
        
        
        headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 410))
        
        headerView.clipsToBounds = true
        headerView.addSubview(bannerView)

        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: headerView.width, height: 40))
        titleLabel.textColor = xsColor_main_yellow
        titleLabel.font = xsFont(14)
        titleLabel.text = "大咖说"
        titleLabel.textAlignment = .center
        bigStarSayBackView.addSubview(titleLabel)
        
        view1 = UIView.init(frame: CGRect.init(x: 0, y: titleLabel.bottom, width: headerView.width, height: 190))
        view1.clipsToBounds = true
        cell = Bundle.main.loadNibNamed("ArtMasterSayTableViewCell", owner: self, options: nil)?.first as! ArtMasterSayTableViewCell
        cell.frame = CGRect.init(x: 12, y: 0, width: headerView.width - 24, height: 190)
        cell.delegate = self
        cell.contentLabel.text = pioneerModel.master_quote.mq_content
        cell.sayNumLabel.text = "\(pioneerModel.master_quote.mq_love_num)"
        cell.clipsToBounds = true
        let date = Date()
        cell.weendayLabel.text = date.getDayOfWeek()
        cell.dateLabel.text = date.getUpperDate()
        cell.praiseButton.isSelected = (pioneerModel.master_quote.flag == 1 ? true : false)
        view1.addSubview(cell)
        bigStarSayBackView.addSubview(view1)
        view2 = UIView.init(frame: CGRect.init(x: 0, y: titleLabel.bottom, width: headerView.width, height: 190))
        view2.clipsToBounds = true
        cell2 = Bundle.main.loadNibNamed("ArtMasterSayTableViewCell", owner: self, options: nil)?.first as! ArtMasterSayTableViewCell
        cell2.frame = cell.frame
        cell2.delegate = self
        cell2.shareDelegate = self.cDelegate
        cell2.clipsToBounds = true
        cell2.contentLabel.text = pioneerModel.master_quote.mq_content
        cell2.sayNumLabel.text = "\(pioneerModel.master_quote.mq_love_num)"
        cell2.dateLabel.text = cell.dateLabel.text
        cell2.praiseButton.isSelected = (pioneerModel.master_quote.flag == 1 ? true : false)
        cell2.layer.masksToBounds = true
        view2.addSubview(cell2)
        bigStarSayBackView.addSubview(view2)
        
        view1.layer.contentsRect = CGRect.init(x: 0, y: 0, width: 1, height: 0.5)
        view2.layer.contentsRect = CGRect.init(x: 0, y: 0.5, width: 1, height: 0.5)
        view1.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
        view2.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
        view1.layer.position = CGPoint.init(x: view1.center.x, y: view1.center.y + view1.height * 0.5)
        view1.height/=2
        view2.height /= 2
        cell2.y = -cell2.height/2
        view1MaskLayer = CAGradientLayer()
        view1MaskLayer.frame = cell.bounds
        view1MaskLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        view1MaskLayer.opacity = 0
        cell.layer.addSublayer(view1MaskLayer)
        
        view2MaskLayer = CAGradientLayer()
        view2MaskLayer.frame = cell2.bounds
        view2MaskLayer.colors = [UIColor.black.cgColor,UIColor.clear.cgColor]
        view2MaskLayer.opacity = 0
        cell2.layer.addSublayer(view2MaskLayer)
        headerView.addSubview(bigStarSayBackView)

        self.readTableView.tableHeaderView = headerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if view1.isHidden == true || scrollView.contentOffset.y < 0 {
            return
        }
//        bigStarSayBackView.bottom = readTableView.contentOffset.y + 180
        let angle = scrollView.contentOffset.y * CGFloat.pi / bigStarSayBackView.height
        print(angle)
        
        if angle >= CGFloat.pi/2  {
//            view1.isHidden = true
//            view2.isHidden = true
//            headerView.height = 180
//            self.readTableView.tableHeaderView = headerView
            return
        }else {
//            view1.isHidden = false
//            view2.isHidden = false
//            headerView.height = 180
//            self.readTableView.tableHeaderView = headerView

        }
        self.view1MaskLayer.opacity = Float(angle / 1.5)
        self.view2MaskLayer.opacity = Float(angle / 1.5)
        var transform = CATransform3DIdentity
        transform.m34 = -1/300.0
        view1.layer.transform = CATransform3DRotate(transform, -angle, 1, 0, 0)
       
        var transform2 = CATransform3DIdentity
        transform2.m34 = -1/300.0
        view2.layer.transform = CATransform3DRotate(transform2, angle, 1, 0, 0)
        let space = 12*(CGFloat(angle / 1.5) + 1)
        cell.frame = CGRect.init(x: space, y: 0, width: headerView.width - space * 2, height: cell.height)
        cell2.frame = CGRect.init(x: space, y: -cell.height/2, width: headerView.width - space * 2, height: cell.height)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      scrollViewDidScroll(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidScroll(scrollView)

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            if _pioneerModel != nil && self.isFold == false{
//                return  1
//            }else {
//                return 0
//            }
//        }else {
            if _pioneerModel != nil {
                return  pioneerModel.classic_quote.count
            }else {
                return 0
            }
//        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0{
//            return 190
//        }else {
            return 152
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! ArtHeaderView
//        if section == 0 {
//            header.titleLabel.text = "大咖说"
//            header.nextButton.isHidden = true
//        }else {
            header.nextButton.isHidden = false
        header.nextButton.setTitle("读精彩", for: .normal)
            header.delegate = cDelegate
//        }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ArtMasterSayTableViewCell", for: indexPath) as! ArtMasterSayTableViewCell
//            cell.delegate = self
//            cell.contentLabel.text = pioneerModel.master_quote.mq_content
//            cell.sayNumLabel.text = "\(pioneerModel.master_quote.mq_love_num)"
//            let date = Date()
//            cell.weendayLabel.text = date.getDayOfWeek()
//            cell.dateLabel.text = date.getUpperDate()
//            cell.praiseButton.isSelected = (pioneerModel.master_quote.flag == 1 ? true : false)
//            return cell
//        }else {
            let cell:ArtReadTableViewCell = tableView.dequeueReusableCell(withIdentifier: "readTableViewCell", for: indexPath) as! ArtReadTableViewCell
            let model = pioneerModel.classic_quote[indexPath.row]
            cell.showPicImageView.xs_setImage(model.cq_img_url)
            cell.picTitleLabel.text = model.cq_title
            cell.picDetailLabel?.text = model.cq_content
            cell.picUploadTimeLabel.isHidden = true
            cell.timeHeightConstraint.constant = 0
            cell.updateConstraints()
            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 1 {
            cDelegate.listView!(view: self, didSelected: indexPath.row)
//        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y >= 400 && self.isFold == false {
////            self.readTableView.deleteSections(NSIndexSet.init(index: 0) as IndexSet, with: .middle)
//            self.isFold = true
//
//            self.readTableView.deleteRows(at: [IndexPath.init(row: 0, section: 0)], with: .middle)
//        }
//    }
    
    func praiseBigStar() {
        network.requestData(.discovery_mqlove, params: ["mq_id":pioneerModel.master_quote.mq_id], finishedCallback: { [weak self](result) in
            if result["ret"] as! Int == 0 {
                if self?.cell2.praiseButton.isSelected == true {
                    self?.pioneerModel.master_quote.mq_love_num = (self?.pioneerModel.master_quote.mq_love_num)! - 1
                    self?.cell2.sayNumLabel.text = "\((self?.pioneerModel.master_quote.mq_love_num)!)"
                }else {
                    self?.pioneerModel.master_quote.mq_love_num = (self?.pioneerModel.master_quote.mq_love_num)! + 1
                    self?.cell2.sayNumLabel.text = "\((self?.pioneerModel.master_quote.mq_love_num)!)"
                }
                self?.cell2.praiseButton.isSelected = !(self?.cell2.praiseButton.isSelected)!
                self?.bigAnimate(view: (self?.cell2.praiseButton)!)
            }
        }, nil)
    }
    
//    func shareBigStar() {
//        let view = Bundle.main.loadNibNamed("BigStarShareView", owner: self, options: nil)?.first as! BigStarShareView
//        self.addSubview(view)
//    }
//    
    func bigAnimate(view:UIView) {
        self.isUserInteractionEnabled = false
        let anim = CAKeyframeAnimation.init(keyPath: "transform.scale")
        anim.values = [1,2,3,2,1]
        anim.duration = 0.3
        view.layer.add(anim, forKey: "add")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + anim.duration) {
            self.isUserInteractionEnabled = true
        }

    }
}



