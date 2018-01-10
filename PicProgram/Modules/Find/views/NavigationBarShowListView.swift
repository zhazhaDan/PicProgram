//
//  NavigationBarShowListView.swift
//  VirtualGarage
//
//  Created by 龚丹丹 on 2017/9/27.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class NavigationBarShowListView: BaseView,UITableViewDelegate,UITableViewDataSource {
    var titles:Array<String> = Array()
    var tableView:UITableView!
    var originFrame:CGRect!
    var isShowing:Bool = false
    open weak var delegate:CustomViewProtocol!
    override func buildUI() {
        originFrame = self.frame
        tableView = UITableView.init(frame: self.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = xsColor_main_white
        tableView.separatorColor = xsColor_main_yellow
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 11, bottom: 0, right: 11)
        self.addSubview(tableView)
        self.height = 0
        self.clipsToBounds = true
    }
    //UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = BarCell.init(style: .default, reuseIdentifier: "cell")
            cell?.separatorInset = UIEdgeInsets.init(top: 0, left: 11, bottom: 0, right: 11)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! BarCell).titleLabel?.text = titles[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("\(indexPath.row)++++++++++++")
        delegate.listDidSelected!(view: self, at: indexPath.row, 0)
    }
    
    override func didMoveToSuperview() {
        UIView.animate(withDuration: 0.25, animations: {
            self.height = self.originFrame.size.height
        }) { (ret) in
            if let superView = self.superview {
                super.didMoveToSuperview()
                self.isShowing = true
            }
        }
    }
    override func removeFromSuperview() {
        UIView.animate(withDuration: 0.25, animations: {[weak self] in
            self?.height = 0
        }) { (ret) in
            if ret == true {
                super.removeFromSuperview()
                self.isShowing = false
            }
        }
    }
}

class BarCell: UITableViewCell {
    var titleLabel:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func buildUI() {
        self.contentView.backgroundColor = xsColor_main_white
        titleLabel = UILabel.initializeLabel(self.bounds, font: 13, textColor: xsColor_main_yellow, textAlignment: .center)
        self.contentView.addSubview(titleLabel)
    }
    override func layoutIfNeeded() {
        self.contentView.bounds = self.bounds
        titleLabel.frame = self.bounds
    }
}
