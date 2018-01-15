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

class PlayViewController: BaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,PlayMoreProtocol,CollectPaintsListProtocol,AddEmotionProtocol {

    var currentIndex:NSInteger = 0
    var dragStartX:CGFloat = 0
    var dragEndX:CGFloat = 0
    var playStyle:Int = 0
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource:Array<PictureModel> = Array()
    @IBAction func playStyleAction(_ sender: UIButton) {
        let styleImages = [#imageLiteral(resourceName: "danduye_danzhangbofanganniu"),#imageLiteral(resourceName: "danduye_sunxuxunhuan"),#imageLiteral(resourceName: "danduye_suijibofanganniu")]
        let styleHints = [MRLanguage(forKey: "Single cycle"),MRLanguage(forKey: "Play In Order"),MRLanguage(forKey: "Shuffle Play")]
        playStyle = (playStyle+1)%3
        sender.setBackgroundImage(styleImages[playStyle], for: .normal)
        network.requestData(.paint_play_style, params: ["play_type":3 - playStyle], finishedCallback: { (result) in
            if result["ret"] as! Int == 0{
                HUDTool.show(.text, text: styleHints[self.playStyle], delay: 0.5, view: self.view, complete: nil)
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 0.6, view: self.view, complete: nil)
            }
        }, nil)
    }
    @IBAction func tipsAction(_ sender: Any) {
        let vc = TipsViewController.init(nibName: "TipsViewController", bundle: Bundle.main)
        vc.picModel = self.dataSource[currentIndex]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func pushAction(_ sender: Any) {
        network.requestData(.paint_picPlay, params: ["picture_id":dataSource[currentIndex].picture_id], finishedCallback: { (result) in
            if result["ret"] as! Int == 0{
                HUDTool.show(.text, text: MRLanguage(forKey: "Submitted"), delay: 0.6, view: self.view, complete: nil)
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 0.6, view: self.view, complete: nil)
            }
        }, nil)
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
        if pic == nil || (pic?.paint == nil) || (pic?.paint?.paint_type != 1) {
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
        self.baseNavigationController?.addRightNavigationBarItems(["fenxiang"], ["fenxiang"], nil, rightCallBack: { (tag) in
            let shareView = ShareViewController.init(nibName: "ShareViewController", bundle: Bundle.main)
            shareView.picUrl = self.dataSource[self.currentIndex].detail_url
            shareView.picTitle = self.dataSource[self.currentIndex].title
            self.navigationController?.pushViewController(shareView, animated: true)
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if dataSource.count == 0 {
            let paint = Paint.fetchPaint(key: .name, value: HistoryPaintName, create: false, painttype: 3)
            dataSource = (paint?.pictureModels)!
        }
        collectionView.reloadData()
        if dataSource.count > 0 {
            collectionView.scrollToItem(at: IndexPath.init(row: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationBar.barTintColor = xsColor("fcf9eb")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:xsColor_main_text_blue,NSAttributedStringKey.font:xsFont(17)]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if dataSource.count > 0 {
            collectionView.scrollToItem(at: IndexPath.init(row: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    //单例
    class var player: PlayViewController {
        struct Singleton {
            static let instance = PlayViewController.init(nibName: "PlayViewController", bundle: Bundle.main)
        }
        if Singleton.instance.currentIndex > Singleton.instance.dataSource.count {
            Singleton.instance.currentIndex = 0
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
        return CGSize.init(width: SCREEN_WIDTH - 64, height: self.view.height - 75 - 84)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PicDetailCollectionViewCell
        cell.isDetail = true
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
//        self.title = dataSource[currentIndex].title
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
            HUDTool.show(.text, text: MRLanguage(forKey: "Cancel save successful"), delay: 1, view: (self.navigationController?.view)!, complete: nil)
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
        network.requestData(.paint_play_style, params: ["play_type":10+time], finishedCallback: { (result) in
            if result["ret"] as! Int == 0{
                HUDTool.show(.text, text: MRLanguage(forKey: "Setting Successful"), delay: 1, view: (self.navigationController?.view)!, complete: nil)
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 0.6, view: (self.navigationController?.view)!, complete: nil)
            }
        }, nil)
    }
    
    func playModeSetting(mode: Int) {
        network.requestData(.paint_play_style, params: ["play_type":20 + mode], finishedCallback: { (result) in
            if result["ret"] as! Int == 0{
                HUDTool.show(.text, text: MRLanguage(forKey: "Setting Successful"), delay: 1, view: (self.navigationController?.view)!, complete: nil)
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 0.6, view: (self.navigationController?.view)!, complete: nil)
            }
        }, nil)
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
            HUDTool.show(.text, text: MRLanguage(forKey: "Add Mood successful"), delay: 1, view: (self.navigationController?.view)!, complete: {[weak self] in
                self?.tapAction(nil)
            })
        } catch  {
            
        }
        
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer.view?.isKind(of: AddEmotionView.self))! {
            return false
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}
