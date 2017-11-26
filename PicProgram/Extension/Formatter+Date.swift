//
//  Formatter+Date.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/7/24.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation

enum TimeFormatterType:String {
    case YYYY_MM_DD_HH_mm = "YYYY-MM-dd HH:mm"
    case YYYY_MM_DD = "YYYY-MM-dd"
    case YYYY = "YYYY"
}

extension Date {
    static func formatterDateString(_ time:AnyObject, formatter:TimeFormatterType = TimeFormatterType.YYYY_MM_DD) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter.rawValue
        if time is String {
            return dateFormatter.string(for: time)!
        }else if time is NSNumber {
            let timeInterval:TimeInterval = TimeInterval(time as! NSNumber)
            let date = Date.init(timeIntervalSince1970: timeInterval)
            return dateFormatter.string(from: date)
        }
        return "00:00:00"
    }
    func getDayOfWeek()->String{
        
        let myCalendar:NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))!
        let myComponents = myCalendar.components(NSCalendar.Unit.weekday, from: self)
        let weekDay = myComponents.weekday
        let weedDays = ["日","一","二","三","四","五","六"]
        return "星期"+weedDays[weekDay!-1]
    }
    func getUpperDate()->String{
        
        let myCalendar:NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))!
        let myComponents = myCalendar.components(NSCalendar.Unit.month, from: self)
        var myMonths = myCalendar.components(NSCalendar.Unit.day, from: self)
        let days =  ["一","二","三","四","五","六","七","八","九","十","十一","十二","十三","十四","十五","十六","十七","十八","十九","二十","二十一","二十二","二十三","二十四","二十五","二十六","二十七","二十八","二十九","三十","三十一"]
        return days[myComponents.month! - 1] + "月" + days[myMonths.day! - 1] + "日"
    }
    
}
