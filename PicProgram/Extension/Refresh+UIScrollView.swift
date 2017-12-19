//
//  RefreshTool.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/8/11.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
import UIKit

enum ScrollViewRefreshType {
    case normal_header_refresh
    case normal_footer_refresh
}

extension UIScrollView {

    func xs_addRefresh(refresh type:ScrollViewRefreshType, action: @escaping () -> Void){
        switch type {
        case .normal_header_refresh:
            let header = ESRefreshHeaderView(frame: CGRect.zero, handler: {
                if self.es_footer != nil && self.es_footer?.noMoreData == true {
                    self.es_resetNoMoreData()
                }
                action()

            })
            let headerH = header.animator.executeIncremental
            refreshIdentifier = "下拉刷新"
            header.frame = CGRect.init(x: 0.0, y: -headerH /* - contentInset.top */, width: bounds.size.width, height: headerH)
            addSubview(header)
            es_header = header

        case .normal_footer_refresh:
            self.es_addInfiniteScrolling {
                action()
            }

        }
    }
    func xs_endRefreshing() {
        if (self.es_header?.isRefreshing)! {
            self.es_header?.stopRefreshing()
        }
        if self.es_footer != nil && (self.es_footer?.isRefreshing)! {
            self.es_footer?.stopRefreshing()
        }
    }
    
    
    func xs_endRefreshingWithNoMoreData() {
        self.es_noticeNoMoreData()
    }
    
    
}
