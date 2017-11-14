//
//  SearchResultView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/27.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

enum SearchResultListType {
    case SearchResultListType_production
    case SearchResultListType_autor
    case SearchResultListType_paint
}

class SearchResultView: BaseView,UITableViewDelegate,UITableViewDataSource {

    var showTableViews:[UITableView] = Array()
    var selectedLineView:UIView!
    var scrollView:UIScrollView!
    var dataSource:[[BaseObject]] = Array()
    var selectIndex:Int = 0
    var noResultView:UILabel!
    open weak var sDelegate:SearchProtocol!

    func reloadDatas() {
        for tableView in showTableViews {
            tableView.reloadData()
        }
        if self.dataSource[self.selectIndex].count == 0 {
            self.showTableViews[self.selectIndex].addSubview(self.noResultView)
        }else {
            self.noResultView.removeFromSuperview()
        }
    }
    
    override func buildUI() {
        self.backgroundColor = xsColor_main_white
        let titles = ["作品","作者","画单"]
        let width = self.width/3
        for i in 0..<titles.count {
            let button = UIButton.init(frame: CGRect.init(x: (width) * CGFloat(i) +  (width - 61)/2, y: 0, width: 61, height: 30))
            button.setTitleColor(xsColor_main_yellow, for: .normal)
            button.setTitle(titles[i], for: .normal)
            button.titleLabel?.font = xsFont(15)
            button.tag = 10+i
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            self.addSubview(button)
        }
        selectedLineView = UIView.init(frame: CGRect.init(x: (width - 61)/2, y: 30, width: 61, height: 4))
        selectedLineView.backgroundColor = xsColor_main_text_blue
        selectedLineView.layer.cornerRadius = 2
        selectedLineView.layer.masksToBounds = true
        self.addSubview(selectedLineView)
        
        let lineView = UIImageView.init(frame: CGRect.init(x: 0, y: selectedLineView.bottom, width: self.width, height: 2))
        lineView.image = #imageLiteral(resourceName: "jianbiantiao")
        self.addSubview(lineView)
        
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: lineView.bottom, width: self.width, height: self.height - lineView.bottom))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = false
        self.addSubview(scrollView)
        
        for i in 0 ..< 3 {
            let tableView = UITableView.init(frame: CGRect.init(x: self.width * CGFloat(i), y: 0, width: scrollView.width, height: scrollView.height),style:.plain)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorInset = UIEdgeInsetsMake(23, 15, 7, 15)
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell0")
            tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "customCell")
            scrollView.addSubview(tableView)
            showTableViews.append(tableView)
        }
        noResultView = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: scrollView.width, height: scrollView.height))
        noResultView.text = "无结果"
        noResultView.font = xsFont(15)
        noResultView.textColor = xsColor_placeholder_grey
        noResultView.textAlignment = .center
        if self.dataSource.count > 0 {
            if self.dataSource[self.selectIndex].count == 0 {
                self.showTableViews[self.selectIndex].addSubview(self.noResultView)
            }else {
                self.noResultView.removeFromSuperview()
            }
        }
        
    }

    @objc func buttonAction(_ sender:UIButton) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.selectedLineView.x = sender.x
        }) { (finished) in
            if finished {
                self.selectIndex = sender.tag - 10
                self.showTableViews[self.selectIndex].reloadData()
                if self.dataSource[self.selectIndex].count == 0 {
                    self.showTableViews[self.selectIndex].addSubview(self.noResultView)
                }else {
                    self.noResultView.removeFromSuperview()
                }
                self.scrollView.setContentOffset(CGPoint.init(x: CGFloat(sender.tag - 10) * self.width, y: 0), animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[selectIndex].count;// dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectIndex == 0 {
            return 49
        }
        return 82
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sDelegate.searchResultDidChoosedCell!(view: selectIndex, indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath)
            cell.textLabel?.textColor = xsColor_main_yellow
            cell.textLabel?.font  = xsFont(14)

            let model = dataSource[selectIndex][indexPath.row] as! PictureModel
            cell.textLabel?.text = model.title
            return cell
        }else if selectIndex == 1 {
            let cell:SearchResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! SearchResultTableViewCell
            cell.layoutIfNeeded()
            let model = dataSource[selectIndex][indexPath.row] as! PaintModel
            cell.iconImageView.xs_setImage(model.img_url)
            cell.titleLabel.isHidden = true
            cell.subTitleLabel.textColor = xsColor_main_yellow
            cell.subTitleLabel.text = model.authro_name
            return cell
        }else if selectIndex == 2 {
            let cell:SearchResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! SearchResultTableViewCell
            cell.layoutIfNeeded()
            let model = dataSource[selectIndex][indexPath.row] as! PaintModel
            cell.iconImageView.xs_setImage(model.title_url)
            cell.titleLabel.text = model.paint_title
            cell.subTitleLabel.text = "\(model.picture_num)张作品，播放\(model.read_num)次"
            return cell
        }
        return UITableViewCell()
    }
    
    
}

class SearchResultTableViewCell: UITableViewCell {
    var titleLabel:UILabel!
    var iconImageView:UIImageView!
    var subTitleLabel:UILabel!
    var isLayout:Bool = false
    func layoutUI() {
        if isLayout == false {
            isLayout = true
            iconImageView = UIImageView.init(frame: CGRect.init(x: 12, y: 23, width: 52, height: 52))
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.layer.cornerRadius = 8
            iconImageView.layer.masksToBounds = true
            self.addSubview(iconImageView)
            titleLabel = UILabel.init(frame: CGRect.init(x: iconImageView.right + 22, y: iconImageView.y, width: self.width - iconImageView.right - 44, height: 20))
            titleLabel.font = xsFont(14)
            titleLabel.textColor = xsColor_main_yellow
            titleLabel.textAlignment = .left
            self.addSubview(titleLabel)
            
            subTitleLabel = UILabel.init(frame: CGRect.init(x: titleLabel.x, y: iconImageView.y, width: self.width - iconImageView.right - 44, height: 20))
            subTitleLabel.font = xsFont(12)
            subTitleLabel.textColor = xsColor_placeholder_grey
            subTitleLabel.textAlignment = .left
            self.addSubview(subTitleLabel)

        }
        
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        layoutUI()
        titleLabel.frame = CGRect.init(x: iconImageView.right + 22, y: iconImageView.y, width: self.width - iconImageView.right - 44, height: 20)
        subTitleLabel.frame = CGRect.init(x: titleLabel.x, y: iconImageView.bottom - 20, width: self.width - iconImageView.right - 44, height: 20)
    }
}
