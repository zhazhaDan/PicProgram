//
//  TestViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/24.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class TestViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
    var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView = UIScrollView.init(frame: self.view.bounds)
        scrollView?.contentSize = CGSize.init(width: (scrollView?.width)!, height: (scrollView?.height)! * 2)
        scrollView?.backgroundColor = UIColor.red
        scrollView?.delegate = self
        tableView = UITableView.init(frame: self.view.bounds)
        scrollView?.addSubview(tableView)
        self.view.addSubview(scrollView!)
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = true
        tableView.clipsToBounds = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        for gesture in (tableView.gestureRecognizers)! {
//            gesture.require(toFail: (scrollView?.gestureRecognizers?.first)!)
//        }
        scrollView?.bounces = true
        scrollView?.clipsToBounds = true
    }
  
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if scrollView == tableView {
//            if tableView.contentOffset.y <= 0 {
//                scrollView
//            }
//        }
//    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isMember(of: UIScrollView.self) {
            print("scrollview 在滚动")
        }else if scrollView.isMember(of: UITableView.self) {
            print("tableview 在滚动")
            if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height {
                self.scrollView?.becomeFirstResponder()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.backgroundColor = UIColor.yellow
        return cell
    }
    

}
