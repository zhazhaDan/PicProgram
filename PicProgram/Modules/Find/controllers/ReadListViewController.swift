//
//  ReadListViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/27.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class ReadListViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var tableView:UITableView!
    var dataSource:[ClassicQuoteModel] = Array()
    override func buildUI() {
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 64, width: self.view.width, height: self.view.height - 64))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "ArtReadTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "readTableViewCell")
        self.view.addSubview(tableView)
        tableView.xs_addRefresh(refresh: .normal_header_refresh) {
            self.requestData()
        }
        requestData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = MRLanguage(forKey: "Art Digest")
    }
    
    override func requestData() {
        network.requestData(.discovery_cqlist, params: nil, finishedCallback: { [weak self](result) in
            self?.tableView.xs_endRefreshing()
            if result["ret"] as! Int == 0 {
                let array = result["classic_quote"] as! Array<[String:Any]>
                self?.dataSource.removeAll()
                for item in array {
                    let model = ClassicQuoteModel.init(dict: item)
                    self?.dataSource.append(model)
                }
                self?.tableView.reloadData()
            }
        }, nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 119
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "readTableViewCell", for: indexPath) as! ArtReadTableViewCell
        let model = dataSource[indexPath.row]
        cell.showPicImageView.xs_setImage(model.cq_img_url)
        cell.picTitleLabel.text = model.cq_title
        cell.picDetailLabel.text = model.cq_content
        cell.picUploadTimeLabel.text = "\(MRLanguage(forKey: "Upload time"))：\(Date.formatterDateString(model.cq_time as AnyObject))"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        let vc = WebViewController()
        vc.urlString = model.cq_h5_url
        self.navigationController?.pushViewController(vc, animated: true)

    }
}


