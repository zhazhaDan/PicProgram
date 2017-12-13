//
//  PicDetailCollectionViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/23.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PicDetailCollectionViewCell"
private let reuseHeaderIdentifier = "header"

class PicDetailCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,SearchProtocol,UIGestureRecognizerDelegate {
    private var _paint_id:Int = 0
    var paint_id:Int {
        set{
            _paint_id = newValue
            if _paintModel == nil {
                _paintModel = PaintModel()
                _paintModel.paint_id = _paint_id
            }
        }
        get {
            return _paint_id
        }
    }
    private var _paintModel:PaintModel!
    var paintModel:PaintModel {
        set{
            _paintModel = newValue
            _paint_id = newValue.paint_id
        }
        get {
            return _paintModel
        }
    }
    var dataSource:Array<PictureModel> = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "禅境迷踪"
        self.collectionView?.frame = CGRect.init(x: 0, y: -StatusBarHeight, width: self.view.width, height: self.view.height + StatusBarHeight)
        self.collectionView?.backgroundColor = xsColor_main_white
        // Register cell classes
        self.collectionView!.register(UINib.init(nibName: "PicDetailCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)
        self.registHeader()
        self.addRightNavigationBarItems(["shangchunhuakuang","fenxiang","08wode_shebeiguanli"])
    }
    
    func registHeader() {
        self.collectionView?.register(UINib.init(nibName: "PicDetailHeaderStyle3View", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if paint_id != 0 {
            requestData()
        }else {
            self.collectionView?.reloadData()
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.collectionView?.y = -StatusBarHeight
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func requestData() {
        network.requestData(.paint_info, params: ["paint_id":paint_id], finishedCallback: { [weak self](result) in
            if result["ret"] as! Int == 0 {
                self?.paintModel = PaintModel.init(dict: result["paint_detail"] as! [String : Any])
                self?.picsStyleChangeAction(style: 1)
                self?.collectionView?.reloadData()
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 0.8, view: (self?.view)!, complete: nil)
            }
        }, nil)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if dataSource == nil {
            return 0
        }
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PicDetailCollectionViewCell
        cell.model = paintModel.picture_arry[indexPath.row]
        // Configure the cell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PlayViewController.player
        vc.dataSource = paintModel.picture_arry
        vc.title = paintModel.paint_title
        vc.currentIndex = indexPath.item
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.view.width - 36)/3, height: (self.view.width - 36)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 6, 0, 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let contentHeight = paintModel.paint_detail.size(self.view.width - 24, 74, xsFont(10)).height
        return CGSize.init(width: self.view.width, height: 256+contentHeight)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! PicDetailHeaderStyle3View
            header.delegate = self
//            if paintModel != nil {
                header.autoPicImageView.xs_setImage(paintModel.title_url)
                header.backImageView.xs_setImage(paintModel.title_url)
                header.picTitleLabel.text = paintModel.paint_title
                header.subTitleLabel.text = paintModel.paint_detail
                header.eyeNumLabel.text = "\(paintModel.read_num)"
                header.totalNumLabel.text = "\(paintModel.picture_num)张"
                header.contentLabel.text = paintModel.paint_detail
                header.collectButton.isSelected = (paintModel.flag == 1 ? true : false)
//            }
            return header
        }
        return UICollectionReusableView.init()
    }


    func addRightNavigationBarItems(_ imageNames:[String]) {
        var imageItems : Array = [UIBarButtonItem]()
        if imageNames.count > 0 {
            for i in 0 ..< imageNames.count {
                let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 44))
                let image = UIImage.init(named: imageNames[imageNames.count - i - 1])
                button.setImage(image, for: .normal)
                button.setImage(UIImage.init(named: imageNames[imageNames.count - i - 1]), for: .highlighted)
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10)
                button.addTarget(self, action: #selector(rightNavigationBarAction(_:)), for: .touchUpInside)
                let barItem = UIBarButtonItem.init(customView: button)
                button.tag = 1000+imageNames.count - i - 1
                imageItems.append(barItem)
            }
        }
        self.navigationItem.rightBarButtonItems = imageItems
    }
    
    @objc func rightNavigationBarAction(_ sender:UIButton) {
        switch sender.tag - 1000 {
        case 0:
            print("投放")
            break
        case 1:
            print("分享")
            break
        case 2:
            print("推送")
            break
        default:
            print("")
        }
    }
    
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //SearchProtocol
    func picsStyleChangeAction(style: Int) {
        let header = self.collectionView?.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath.init(row: 0, section: 0)) as! PicDetailHeaderStyle3View

        if style == 0 {
            dataSource = paintModel.picture_H
            header.numberLabel.text = "\(paintModel.picture_H.count)张"
        }else if style == 1 {
            dataSource = paintModel.picture_arry
            header.numberLabel.text = "\(paintModel.picture_arry.count)张"
        }else if style == 2 {
            dataSource = paintModel.picture_S
            header.numberLabel.text = "\(paintModel.picture_S.count)张"
        }
        self.collectionView?.reloadData()
    }
    
    func playAction() {
        let vc = PlayViewController.player
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectAction() {
        network.requestData(.paint_collect, params: ["paint_id":self.paintModel.paint_id], finishedCallback: { [weak self](result) in
            if result["ret"] as! Int == 0 {
                let header = self?.collectionView?.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath.init(row: 0, section: 0)) as! PicDetailHeaderStyle3View
                header.collectButton.isSelected = !header.collectButton.isSelected
            }
        }, nil)
    }
    func pushAction() {
        var array = self.paintModel.picture_arry
        let header = self.collectionView?.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath.init(row: 0, section: 0)) as! PicDetailHeaderStyle3View
        if header.segmentIndex == 1 {
            array = self.paintModel.picture_arry
        }else if header.segmentIndex == 0 {
            array = self.paintModel.picture_H
        }else if header.segmentIndex == 2 {
            array = self.paintModel.picture_S
        }
        var ids: [Int] = Array()
        for model in array {
            ids.append(model.picture_id)
        }
        network.requestData(.paint_play, params: ["picture_ids":ids], finishedCallback: { (result) in
            if result["ret"] as! Int == 0 {
                HUDTool.show(.text, text: "推送成功", delay: 1, view: self.view, complete: nil)
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 1, view: self.view, complete: nil)
            }
        }, nil)
    }
    
    func shareAction() {
        //TODO:分享 未登录提示登录？
        let vc = ShareViewController.init(nibName: "ShareViewController", bundle: Bundle.main)
        vc.picUrl = paintModel.title_url
        vc.picTitle = paintModel.paint_title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func chooseMainPicAction() {
        let vc = EditPaintDetailViewController()
        vc.paintModel = self.paintModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
