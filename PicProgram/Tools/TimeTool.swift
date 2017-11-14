//
//  TimeTool.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/7/19.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
class TimeTool: NSObject {
    open static func showCountTime(_ timeCount:Int) -> String {
        if (timeCount < 0) {
            return "00:00:00"
        }
        let  seconds = Int(floor(Double(timeCount % 60)))
        let  minutes = Int(floor(Double(timeCount / 60 % 60)))
        let  hours = Int(floor(Double(timeCount / 60 / 60)))
        let hours_str = hours < 10 ? ("0"+"\(hours)") : "\(hours)"
        let minutes_str = minutes < 10 ? ("0" + "\(minutes)") : "\(minutes)"
        let seconds_str = seconds < 10 ? ("0" + "\(seconds)") : "\(seconds)"
        return hours_str + ":" + minutes_str + ":" + seconds_str
    }
}
