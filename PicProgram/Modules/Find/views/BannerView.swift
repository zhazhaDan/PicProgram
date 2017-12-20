

//
//  BannerView.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/7/27.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

/**
 定义手指滑动方向枚举
 
 - DirecNone:  没有动
 - DirecLeft:  向左
 - DirecRight: 向右
 */
enum BannerViewDirec {
    case none
    case left
    case right
}


class BannerView: BaseView,UIScrollViewDelegate {
    fileprivate var images:Array <String>! = Array()
    fileprivate var currentImageView:UIImageView = UIImageView()
    fileprivate var leftImageView:UIImageView = UIImageView()
    fileprivate var rightImageView:UIImageView = UIImageView()
    fileprivate var pageControl:UIPageControl!
    fileprivate var timer:Timer!
    var currentIndex:Int!
    fileprivate var isHidenPageControl:Bool = false
    fileprivate var tapGesture:UITapGestureRecognizer!
    weak open var delegate:BannerViewProtocol?
    weak open var show_delegate:BannerViewProtocol?
    var auto:Bool = false
    var isBannerAuto:Bool = true
    var scrollView:UIScrollView?
    init(frame: CGRect,_ isHidenPageControl:Bool = false,_ auto:Bool = true) {
        super.init(frame: frame)
        self.buildUI()
        self.isHidenPageControl = isHidenPageControl
        self.pageControl.isHidden = isHidenPageControl
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func buildUI() {
        self.backgroundColor = xsColor_placeholder_grey
        super.buildUI()
        scrollView = UIScrollView.init(frame: self.bounds)
        scrollView?.isPagingEnabled = true
        scrollView?.bounces = false
        self.addSubview(scrollView!)
        pageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: self.height - 20, width: self.width, height: 2))
        pageControl.pageIndicatorTintColor = xsColor("ffffff", alpha: 0.5)
        pageControl.currentPageIndicatorTintColor = xsColor_main_white
        pageControl.numberOfPages = images.count
        pageControl.hidesForSinglePage = true
        self.addSubview(pageControl)
        currentIndex = 0
        scrollView?.contentOffset = CGPoint.init(x: (scrollView?.width)!, y: 0)
    }
    
    
    func updateUI() {
        
        for view in (scrollView?.subviews)! {
            view.removeFromSuperview()
        }
        var count = 0
        var imageViews = [leftImageView,currentImageView,rightImageView]
        if images.count <= 0 {
            return
        }else if images.count == 1 {
            count = 1
        }else {
            count = 3
        }
        for i in 0 ..< count {
            let imageName = images[i % images.count]
            imageViews[i].frame = CGRect.init(x: CGFloat(i)*self.width, y: 0, width: self.width, height: self.height)
            imageViews[i].backgroundColor = xsColor_main_yellow
            imageViews[i].contentMode = .scaleAspectFill
            imageViews[i].clipsToBounds = true
            imageViews[i].xs_setImage(imageName, imageSize: .image_957)
            imageViews[i].isUserInteractionEnabled = true
            scrollView?.addSubview(imageViews[i])
        }
        scrollView?.backgroundColor = xsColor_main_yellow
        scrollView?.contentSize = CGSize.init(width: self.width * CGFloat(count), height: self.height)
        if count > 1 {
            if tapGesture == nil {
                tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(chooseActivity))
            }
            currentImageView.addGestureRecognizer(tapGesture)
            scrollView?.delegate = self
            pageControl.numberOfPages = images.count
            reloadImages()
            if isBannerAuto == true {
                initTimer()
            }
        }else {
            pageControl.numberOfPages = 0
            scrollView?.delegate = nil
            if tapGesture == nil {
                tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(chooseActivity))
            }
            leftImageView.addGestureRecognizer(tapGesture)
        }
        pageControl.isHidden = isHidenPageControl
    }
    
    
    fileprivate func initTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(autoChangeImageViews), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
    }
    
    @objc func autoChangeImageViews() {
            auto = true
            UIView.animate(withDuration: 1) {
                self.scrollView?.setContentOffset(CGPoint.init(x: (self.scrollView?.width)! * CGFloat(2), y: 0), animated: false)
            }
        
    }
    
    
    
    @objc func chooseActivity() {
        if ((delegate?.bannerViewDidSelected) != nil) {
            delegate?.bannerViewDidSelected!(view: self, currentIndex)
        }
    }
    
    var bannerImages:Array <String> {
        set(newValue) {
            images = newValue
            updateUI()
        }
        get {
            return images
        }
    }
    
    
    var index:Int {
        set(newValue){
            currentIndex = newValue
            pageControl.currentPage = newValue
        }
        get {
            return currentIndex
        }
    }
    
   fileprivate  func reloadImages() {
        leftImageView.xs_setImage(images[(currentIndex-1+images.count)%images.count], imageSize: .image_957)
        currentImageView.xs_setImage(images[currentIndex], imageSize: .image_957)
        rightImageView.xs_setImage(images[(currentIndex + 1)%images.count], imageSize: .image_957)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (Int(scrollView.contentOffset.x) % Int(scrollView.width)) == 0 && auto == true {
            
            UIView.animate(withDuration: 1, animations: {
                self.scrollView?.setContentOffset(CGPoint.init(x: (self.scrollView?.width)! * CGFloat(2), y: 0), animated: false)
                
            }, completion: { (finished) in
                if finished == true {
                    self.scrollViewDidEndDecelerating(scrollView)
                }
            })
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer.invalidate()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isBannerAuto == true {
            initTimer()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        auto = false
        if scrollView.contentOffset.x == 0 {
            index = ((currentIndex - 1) + images.count )%images.count
        }else if scrollView.contentOffset.x == scrollView.width * 2 {
            index = (currentIndex + 1 )%images.count
        }
        reloadImages()
        scrollView.setContentOffset(CGPoint.init(x: scrollView.width, y: 0), animated: false)
        if ((show_delegate?.bannerViewAutoChangeAt) != nil) {
            show_delegate?.bannerViewAutoChangeAt!(view: self, currentIndex)
        }
    }
}

@objc protocol BannerViewProtocol:NSObjectProtocol {
    @objc optional func bannerViewDidSelected(view:BannerView,_ index:Int)
    @objc optional func bannerViewAutoChangeAt(view:BannerView,_ index:Int)
}
