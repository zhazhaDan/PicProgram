//
//  URLEncode+String.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/8/3.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
extension String {
    var urlEncode:String? {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'\\\\\"();:@&=+$,/?%#[]% ").inverted)
    }
    var urlDecode :String? {
        return self.removingPercentEncoding
    }
}
