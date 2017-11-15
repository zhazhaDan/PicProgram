//
//  PlayViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/30.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit


private let reuseIdentifier = "PicDetailCollectionViewCell"

class PlayViewController: BaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {

    var currentIndex:NSInteger = 0
    var dragStartX:CGFloat = 0
    var dragEndX:CGFloat = 0
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource:Array<PictureModel> = Array()
    @IBAction func playStyleAction(_ sender: Any) {
    }
    @IBAction func tipsAction(_ sender: Any) {
        let vc = TipsViewController.init(nibName: "TipsViewController", bundle: Bundle.main)
        vc.picModel = self.dataSource[0]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func pushAction(_ sender: Any) {
        
    }
    
    @IBAction func TiningAction(_ sender: Any) {
        let vc = LiningViewController.init(nibName: "LiningViewController", bundle: Bundle.main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func moreAction(_ sender: Any) {
        let moreView = Bundle.main.loadNibNamed("PlayMoreView", owner: nil, options: nil)?.first as! PlayMoreView
        moreView.frame = (self.navigationController?.view.bounds)!
        self.navigationController?.view.addSubview(moreView)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.register(UINib.init(nibName: "PicDetailCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)
        let layout = collectionView.collectionViewLayout as! PlayViewFlowLayout
        layout.scrollDirection = .horizontal
    }
    
    //单例
    class var player: PlayViewController {
        struct Singleton {
            static let instance = PlayViewController.init(nibName: "PlayViewController", bundle: Bundle.main)
        }
        return Singleton.instance
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.collectionView.width - 64, height: self.collectionView.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PicDetailCollectionViewCell
        cell.model = dataSource[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PictureDetailViewController.init(nibName: "PictureDetailViewController", bundle: Bundle.main)
        vc.model = dataSource[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 32, 0, 32)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dragStartX = scrollView.contentOffset.x
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dragEndX = scrollView.contentOffset.x
        DispatchQueue.main.async {
            self.fixCellToCenter()
        }
    }

    func fixCellToCenter() {
        let dragMiniDistance = self.collectionView.bounds.width/20
        if dragStartX - dragEndX >= dragMiniDistance {
            currentIndex -= 1
        }else if dragEndX - dragStartX >= dragMiniDistance {
            currentIndex += 1
        }
        let maxIndex = collectionView.numberOfItems(inSection: 0) - 1
        currentIndex = currentIndex <= 0 ? 0 : currentIndex
        currentIndex = currentIndex >= maxIndex ? maxIndex : currentIndex
        collectionView.scrollToItem(at: NSIndexPath.init(row: currentIndex, section: 0) as IndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
}
