//
//  PKHUDSquareBaseView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDSquareBaseView provides a square view, which you can subclass and add additional views to.
open class PKHUDSquareBaseView: UIView {

    static let defaultSquareBaseViewFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 178.0, height: 84.0))

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public init(image: UIImage? = nil, title: String? = nil, subtitle: String? = nil) {
        super.init(frame: PKHUDSquareBaseView.defaultSquareBaseViewFrame)
        self.imageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        if title == nil || title?.count == 0 {
            imageView.contentMode = .scaleAspectFit
        }
    }

    open let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 1
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        return imageView
    }()

    open let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textAlignment = .center
        label.font = xsFont(12)
        label.textColor = xsColor_main_yellow
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        return label
    }()

    open let subtitleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textAlignment = .center
        label.font = xsFont(12)
        label.textColor = xsColor_main_yellow
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        return label
    }()

    open override func layoutSubviews() {
        super.layoutSubviews()

        let viewWidth = bounds.size.width
        let viewHeight = bounds.size.height

        let halfHeight = CGFloat(ceilf(CFloat(viewHeight / 2.0)))
        let quarterHeight = CGFloat(ceilf(CFloat(viewHeight / 4.0)))
        let threeQuarterHeight = CGFloat(ceilf(CFloat(viewHeight / 4.0 * 3.0)))

        titleLabel.frame = CGRect(origin: CGPoint(x:0.0, y:viewHeight/2), size: CGSize(width: viewWidth, height: quarterHeight))
        imageView.frame = CGRect(origin: CGPoint(x:0.0, y:0), size: CGSize(width: viewWidth, height: halfHeight))
        subtitleLabel.frame = CGRect(origin: CGPoint(x:0.0, y:threeQuarterHeight), size: CGSize(width: viewWidth, height: quarterHeight))
        
        if titleLabel.text == nil || titleLabel.text?.count == 0 {
            imageView.frame = CGRect(origin: CGPoint(x:0.0, y:0), size: CGSize(width: viewWidth, height: viewHeight))
        }
        
    }
}
