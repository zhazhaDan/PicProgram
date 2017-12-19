//
//  ESRefreshHeaderView.swift
//
//  Created by egg swift on 16/4/7.
//  Copyright (c) 2013-2016 ESPullToRefresh (https://github.com/eggswift/pull-to-refresh)
//  Icon from http://www.iconfont.cn
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import QuartzCore
import UIKit

open class ESRefreshHeaderAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol, ESRefreshImpactProtocol {
    open var pullToRefreshDescription = "下拉刷新..." {
        didSet {
            if pullToRefreshDescription != oldValue {
                titleLabel.text = pullToRefreshDescription;
            }
        }
    }
    open var releaseToRefreshDescription = "松手刷新"
    open var loadingDescription = "正在刷新数据中..."

    open var view: UIView { return self }
    open var insets: UIEdgeInsets = UIEdgeInsets.zero
    open var trigger: CGFloat = 60.0
    open var executeIncremental: CGFloat = 60.0
    open var state: ESRefreshViewState = .pullToRefresh

    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView.init()
        if #available(iOS 8, *) {
            imageView.image = UIImage(named: "icon_pull_to_refresh_arrow", in: Bundle(for: ESRefreshHeaderAnimator.self), compatibleWith: nil)
        } else {
            imageView.image = UIImage(named: "icon_pull_to_refresh_arrow")
        }
        return imageView
    }()
    
    fileprivate let loadingImageView: UIImageView = {
        let loadingImageView = UIImageView.init()
        var images:[UIImage] = Array()
        for i in 0 ..< 47 {
            if #available(iOS 8, *) {
                images.append(UIImage(named: "loading_\(i)", in: Bundle(for: ESRefreshHeaderAnimator.self), compatibleWith: nil)!)
            } else {
                images.append(UIImage(named: "loading_\(i)")!)
            }
        }
        loadingImageView.animationDuration = 2
        loadingImageView.animationImages = images
       
        return loadingImageView
    }()
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = xsFont(14)
        label.textColor = xsColor_placeholder_grey//xsColor_main_yellow
        label.textAlignment = .left
        return label
    }()
    
    fileprivate let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = pullToRefreshDescription
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(loadingImageView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func refreshAnimationBegin(view: ESRefreshComponent) {
        loadingImageView.startAnimating()
        loadingImageView.isHidden = false
        imageView.isHidden = true
        titleLabel.text = loadingDescription
        titleLabel.isHidden = true
        imageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(M_PI))
    }
  
    open func refreshAnimationEnd(view: ESRefreshComponent) {
        loadingImageView.stopAnimating()
        loadingImageView.isHidden = true
        imageView.isHidden = false
        titleLabel.isHidden = false
        titleLabel.text = pullToRefreshDescription
        imageView.transform = CGAffineTransform.identity
    }
    
    open func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        // Do nothing
        
    }
    
    open func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        
        switch state {
        case .refreshing, .autoRefreshing:
            titleLabel.text = loadingDescription
            self.setNeedsLayout()
            break
        case .releaseToRefresh:
            titleLabel.text = releaseToRefreshDescription
            self.setNeedsLayout()
            self.impact()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                [weak self] in
                self?.imageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(M_PI))
            }) { (animated) in }
            break
        case .pullToRefresh:
            titleLabel.text = pullToRefreshDescription
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                [weak self] in
                self?.imageView.transform = CGAffineTransform.identity
            }) { (animated) in }
            break
        default:
            break
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let s = self.bounds.size
        let w = s.width
        let h = s.height
        
        UIView.performWithoutAnimation {
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint.init(x: w / 2.0, y: h / 2.0)
            loadingImageView.frame = CGRect.init(x: titleLabel.x - 50, y: (h - 48)/2, width: 48, height: 48)
            loadingImageView.center = CGPoint.init(x: w / 2.0, y: h / 2.0)
            imageView.frame = CGRect.init(x: titleLabel.frame.origin.x - 28.0, y: (h - 18.0) / 2.0, width: 18.0, height: 18.0)
        }
    }
    
}
