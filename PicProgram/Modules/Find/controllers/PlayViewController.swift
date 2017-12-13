//
//  PlayViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/30.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "PicDetailCollectionViewCell"

class PlayViewController: BaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,PlayMoreProtocol,CollectPaintsListProtocol,UIGestureRecognizerDelegate,AddEmotionProtocol {

    var currentIndex:NSInteger = 0
    var dragStartX:CGFloat = 0
    var dragEndX:CGFloat = 0
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource:Array<PictureModel> = Array()
    @IBAction func playStyleAction(_ sender: Any) {
    }
    @IBAction func tipsAction(_ sender: Any) {
        let vc = TipsViewController.init(nibName: "TipsViewController", bundle: Bundle.main)
        vc.picModel = self.dataSource[currentIndex]
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
        moreView.delegate = self
        moreView.frame = (self.navigationController?.view.bounds)!
        self.navigationController?.view.addSubview(moreView)
        
        let pic = Picture.fetchPicture(forPicId: Int64(Int(dataSource[currentIndex].picture_id)))
        if pic == nil {
            moreView.isCollected = false
        }else {
            moreView.isCollected = (pic?.paint == nil ? false : true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.register(UINib.init(nibName: "PicDetailCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)
        let layout = collectionView.collectionViewLayout as! PlayViewFlowLayout
        layout.scrollDirection = .horizontal
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.scrollToItem(at: IndexPath.init(row: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
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
    
    
    //PlayMoreProtocol
    func detailInfo() {
        let vc = PictureDetailViewController.init(nibName: "PictureDetailViewController", bundle: Bundle.main)
        vc.model = dataSource[currentIndex]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectPicture() {
        let cView = Bundle.main.loadNibNamed("CollectPaintsListView", owner: self, options: nil)?.first as! CollectPaintsListView
        cView.frame = (self.navigationController?.view.bounds)!
        cView.delegate = self
        cView.picModel = dataSource[currentIndex]
        self.navigationController?.view.addSubview(cView)
    }
    
    func cancelCollectPicture() {
        let pic = Picture.fetchPicture(forPicId: Int64(Int(dataSource[currentIndex].picture_id)))
        let paint = pic?.paint
        paint?.removeFromPics(pic!)
        do {
            try appDelegate.managedObjectContext.save()
            HUDTool.show(.text, text: "取消收藏成功", delay: 1, view: (self.navigationController?.view)!, complete: nil)
        }catch {}

    }
    
    func addEmotion() {
        let maskView:UIView = UIView.init(frame: (self.navigationController?.view.bounds)!)
        maskView.backgroundColor = xsColor("000000", alpha: 0.6)
        maskView.tag = 100
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_ :)))
        maskView.addGestureRecognizer(tapGesture)
        let emotionView = AddEmotionView.init(frame: CGRect.init(x: 0, y: (self.navigationController?.view.height)! - 249, width: self.view.width, height: 249))
        emotionView.delegate = self
        maskView.addSubview(emotionView)
        self.navigationController?.view.addSubview(maskView)
    }
    
    @objc func tapAction(_ tapGesture:UITapGestureRecognizer?) {
        let maskView = self.navigationController?.view.viewWithTag(100)
        maskView?.removeFromSuperview()
    }
    
    
    func playTimeSetting(time: Int) {
        HUDTool.show(.text, text: "播放时间设置成功", delay: 1, view: self.view, complete: nil)
    }
    
    func playModeSetting(mode: Int) {
        HUDTool.show(.text, text: "播放模式设置成功", delay: 1, view: self.view, complete: nil)
    }
    
    
    /// CollectPaintsListProtocol
    func collectionPaintsListAddPaint() {
        let vc = NewPintNameViewController.init(nibName: "NewPintNameViewController", bundle: Bundle.main)
        self.navigationController?.present(HomePageNavigationController.init(rootViewController:vc), animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func emotionChoosed(emotionView:AddEmotionView,sender: UIButton, emotionIndex index: Int) {
        let currentPic_id = dataSource[currentIndex].picture_id
        let pic = Picture.fetchPicture(forPicId: Int64(currentPic_id))
        pic?.coverProperties(model: dataSource[currentIndex])
        let paint = Emotion.fetchEmotionPaint(forEmotionName: sender.title(for: .normal)!)
        paint?.addToPictures(pic!)
        pic?.emotion = paint
        do {
            try appDelegate.managedObjectContext.save()
            HUDTool.show(.text, text: "心情添加成功", delay: 1, view: (self.navigationController?.view)!, complete: {[weak self] in
                self?.tapAction(nil)
            })
        } catch  {
            
        }
        
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer.view?.isKind(of: AddEmotionView.self))! {
            return false
        }
        return true
    }
}
