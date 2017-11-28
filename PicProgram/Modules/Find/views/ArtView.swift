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
    var pioneerModel:PioneerModel {
        set {
            _pioneerModel = newValue
            var images :[String] = Array()
            for item in (_pioneerModel.banner) {
                images.append(item.title_url)
            }
            self.bannerView.bannerImages = images
            self.bannerView.updateUI()
            self.readTableView.reloadData()
        }
        get {
            return _pioneerModel
        }
    }
//    @IBAction func readMoreAction(_ sender: Any) {
//    }
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
////        self.readTableView.delegate = self
////        self.readTableView.dataSource = self
//    }
//    
    override func buildUI() {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.width, height: 180))
        bannerView = BannerView.init(frame: CGRect.init(x: 12, y: 12, width: self.width - 24, height: 168),true)
        view.addSubview(bannerView)
        readTableView = UITableView.init(frame: self.bounds, style:.plain)
        readTableView.height -= 49
        readTableView.backgroundColor = xsColor_main_white
        readTableView.delegate = self
        readTableView.dataSource = self
        readTableView.tableHeaderView = view
        readTableView.separatorStyle = .none
        self.readTableView.register(UINib.init(nibName: "ArtReadTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "readTableViewCell")
        self.readTableView.register(UINib.init(nibName: "ArtMasterSayTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ArtMasterSayTableViewCell")
        self.readTableView.register(UINib.init(nibName: "ArtHeaderView", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: "header")
        self.readTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "footer")
        self.addSubview(self.readTableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if _pioneerModel != nil && self.isFold == false{
                return  1
            }else {
                return 0
            }
        }else {
            if _pioneerModel != nil {
                return  pioneerModel.classic_quote.count
            }else {
                return 0
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 190
        }else {
            return 119
        }
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
        if section == 0 {
            header.titleLabel.text = "大咖说"
            header.nextButton.isHidden = true
        }else {
            header.titleLabel.text = "读精彩"
            header.nextButton.isHidden = false
            header.delegate = cDelegate
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArtMasterSayTableViewCell", for: indexPath) as! ArtMasterSayTableViewCell
            cell.delegate = self
            cell.contentLabel.text = pioneerModel.master_quote.mq_content
            cell.sayNumLabel.text = "\(pioneerModel.master_quote.mq_love_num)"
            let date = Date()
            cell.weendayLabel.text = date.getDayOfWeek()
            cell.dateLabel.text = date.getUpperDate()
//            cell.praiseButton.isSelected = (pioneerModel.master_quote.flag == 1 ? true : false)
            return cell
        }else {
            let cell:ArtReadTableViewCell = tableView.dequeueReusableCell(withIdentifier: "readTableViewCell", for: indexPath) as! ArtReadTableViewCell
            let model = pioneerModel.classic_quote[indexPath.row]
            cell.showPicImageView.xs_setImage(model.cq_img_url)
            cell.picTitleLabel.text = model.cq_title
            cell.picDetailLabel?.text = model.cq_content
            cell.picUploadTimeLabel.text = "上传时间：" + Date.formatterDateString(model.cq_time as AnyObject)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            cDelegate.listView!(view: self, didSelected: indexPath.row)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 400 && self.isFold == false {
//            self.readTableView.deleteSections(NSIndexSet.init(index: 0) as IndexSet, with: .middle)
            self.isFold = true

            self.readTableView.deleteRows(at: [IndexPath.init(row: 0, section: 0)], with: .middle)
        }
    }
    
    func praiseBigStar() {
        network.requestData(.discovery_mqlove, params: ["mq_id":pioneerModel.master_quote.mq_id], finishedCallback: { [weak self](result) in
            if result["ret"] as! Int == 0 {
                let cell = self?.readTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ArtMasterSayTableViewCell
                cell.praiseButton.isSelected = !cell.praiseButton.isSelected
                self?.bigAnimate(view: cell.praiseButton)
                print(cell.praiseButton.isSelected)
            }
        }, nil)
    }
    
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



