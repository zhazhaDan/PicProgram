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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleButton.setTitle(subTitle, for: .normal)
        collectionView.register(UINib.init(nibName: "PicDetailCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier:reuseIdentifier)
        // Do any additional setup after loading the view.
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
        let vc = PlayViewController.player
        vc.dataSource = pictures
        vc.title = self.title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        let cell = cell as! PicDetailCollectionViewCell
        let item = pictures[indexPath.row]
        cell.model = item
    }
    

}
