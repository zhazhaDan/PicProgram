//
//  ClassifyEmotionDetailListViewController.swift
//  PicProgram
//
//  Created by sliencio on 2017/11/26.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PicDetailCollectionViewCell"

class ClassifyEmotionDetailListViewController: BaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var subTitle:String!
    var pictures:[PictureModel] = Array()
    var last_id:Int32 = 0
    var model:PaintModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleButton.setTitle(subTitle, for: .normal)
        collectionView.register(UINib.init(nibName: "PicDetailCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier:reuseIdentifier)
        // Do any additional setup after loading the view.
        collectionView.xs_addRefresh(refresh: .normal_header_refresh) {
            self.last_id = 0
            self.requestData()
        }
        collectionView.xs_addRefresh(refresh: .normal_footer_refresh) {
            self.requestData()
        }
    }
    
    override func requestData() {
        HUDTool.show(.loading, view: self.view)
        network.requestData(.paint_info, params: ["paint_id":self.model.paint_id,"last_id":last_id], finishedCallback: { [weak self](result) in
            HUDTool.hide()
            self?.collectionView.xs_endRefreshing()
            if result["ret"] as! Int == 0 {
                
                if self?.last_id == 0 {
                    self?.model = nil
                }
                let info = result["paint_detail"] as! [String : Any]
                if self?.model != nil {
                    self?.model.setValue(info["picture_info"], forKey: "picture_info")
                }else {
                    self?.model = PaintModel.init(dict: info)
                }
                if result["last_id"] != nil {
                    self?.last_id = result["last_id"] as! Int32
                }else {
                    self?.last_id = -1
                    self?.collectionView.xs_endRefreshingWithNoMoreData()
                }
                self?.pictures = (self?.model.picture_arry)!
                self?.collectionView?.reloadData()
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 0.8, view: (self?.view)!, complete: nil)
            }
            }, nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (SCREEN_WIDTH - 48)/3, height: (SCREEN_WIDTH - 48)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(12, 12, 12, 12)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if UserInfo.user.checkUserLogin() {
            let vc = PlayViewController.player
            vc.dataSource = pictures
            vc.title = self.title
            vc.currentIndex = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let sb = UIStoryboard.init(name: "Mine", bundle: Bundle.main)
            let login = sb.instantiateViewController(withIdentifier: "SBLoginViewController")
            self.present(HomePageNavigationController.init(rootViewController:login), animated: true, completion: nil)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        let cell = cell as! PicDetailCollectionViewCell
        let item = pictures[indexPath.row]
        cell.model = item
    }
    

}
