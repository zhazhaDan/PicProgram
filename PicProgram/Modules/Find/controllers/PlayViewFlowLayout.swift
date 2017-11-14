//
//  PlayViewFlowLayout.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/2.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class PlayViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let arr = getCopyOfAttributes(attributes: super.layoutAttributesForElements(in: rect)!)
        let centerX = (self.collectionView?.contentOffset.x)! + (self.collectionView?.width)!/2.0
        for attributes in arr {
            let distance:CGFloat = fabs(attributes.center.x - centerX)
            let factor:CGFloat = 0.001
            let scale:CGFloat = 2/(2+distance*factor)
            attributes.transform = CGAffineTransform(scaleX: 1, y: scale)
        }
        return arr
    }
    
    func getCopyOfAttributes(attributes:Array<UICollectionViewLayoutAttributes>) -> Array<UICollectionViewLayoutAttributes> {
        var arr = Array<UICollectionViewLayoutAttributes>()
        for item in attributes {
            arr.append(item.copy() as! UICollectionViewLayoutAttributes)
        }
        return arr
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let centerX = proposedContentOffset.x + (self.collectionView?.width)!/2.0
        let visibleX = proposedContentOffset.x
        let visibleY = proposedContentOffset.y
        let visibleW = self.collectionView?.width
        let visibleH = self.collectionView?.height
        
        let visibleRect = CGRect.init(x: visibleX, y: visibleY, width: visibleW!, height: visibleH!)
        let attrs = self.layoutAttributesForElements(in: visibleRect)
        var min_idx = 0
        var min_attr = attrs![min_idx]
        for i in 1 ..< (attrs?.count as! Int) {
            let distance = abs(min_attr.center.x - centerX)
            let currentAttr = attrs![i]
            let distance2 = abs(currentAttr.center.x - centerX)
            if distance2 < distance {
                min_idx = i
                min_attr = currentAttr
            }
        }
        let offsetX = min_attr.center.x - centerX
        return CGPoint.init(x: proposedContentOffset.x+offsetX, y: proposedContentOffset.y)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
