//
//  PioneerActCollectionViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/29.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let reuseHeaderIdentifier = "header"

class PicDetailActCollectionViewController: PicDetailCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func registHeader() {
        self.collectionView?.register(UINib.init(nibName: "PicDetailHeaderCollectionReusableView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.frame = CGRect.init(x: 0, y: NavigationBarBottom, width: self.view.width, height: SCREEN_HEIGHT - NavigationBarBottom)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        if self.navigationController != nil {
            (self.navigationController as! BaseNavigationController).addLeftNavigationBarItem {[weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
           self.addRightNavigationBarItems(["shangchunhuakuang","fenxiang","08wode_shebeiguanli"])
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
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
            self.pushAction()
            break
        case 1:
            print("分享")
            self.shareAction()
            break
        case 2:
            print("推送")
            self.playAction()

            break
        default:
            print("")
        }
    }
    
    
    // MARK: UICollectionViewDataSource
 
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! PicDetailHeaderCollectionReusableView
            header.delegate = self
            if paint_id != 0 {
                header.collectButton.isEnabled = true
                header.collectButton.isSelected = (paintModel.flag == 1 ? true : false)
            }else {
                header.collectButton.isUserInteractionEnabled = false
                header.collectButton.isSelected = true
            }
            header.headerImageView.xs_setImage(paintModel.title_url)
            header.eyeNumLabel.text = "\(paintModel.read_num)"
            header.numberLabel.text = "\(paintModel.picture_num)\(MRLanguage(forKey: "pages"))"
            header.numLabel.text = "\(paintModel.picture_num)\(MRLanguage(forKey: "pages"))"
            header.contentLabel.text = paintModel.paint_detail
            return header
        }
        return UICollectionReusableView.init()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let contentHeight = paintModel.paint_detail.size(self.view.width - 24, 74, xsFont(10)).height
        return CGSize.init(width: self.view.width, height: 290+contentHeight)
    }
    
    
    
    
    //SearchProtocol
    override func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func picsStyleChangeAction(style: Int) {
        // 横  横竖  竖
    }
}
