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
        }else if time is Date {
            return dateFormatter.string(from: time as! Date)
        }
        return "00:00:00"
    }
    func getDayOfWeek()->String{
        
        let myCalendar:NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))!
        let myComponents = myCalendar.components(NSCalendar.Unit.weekday, from: self)
        let weekDay = myComponents.weekday
        if BaseBundle.language == EN {
            let weedDays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
            return weedDays[weekDay!-1]
        }else if BaseBundle.language == CNS {
            let weedDays = ["日","一","二","三","四","五","六"]
            return "星期"+weedDays[weekDay!-1]
        }
        let weedDays = ["日","一","二","三","四","五","六"]
        return "星期"+weedDays[weekDay!-1]
    }
    func getUpperDate()->String{
        
        let myCalendar:NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))!
        let myComponents = myCalendar.components(NSCalendar.Unit.month, from: self)
        var myMonths = myCalendar.components(NSCalendar.Unit.day, from: self)
       
        if BaseBundle.language == EN {
            let days =  ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th","13th","14th","15th","16th","17th","18th","19th","20th","21th","22th","23th","24th","25th","26th","27th","28th","29th","30th","31th"]
            let months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
            return  days[myMonths.day! - 1] + "," + months[myComponents.month! - 1]
        }
        let days =  ["一","二","三","四","五","六","七","八","九","十","十一","十二","十三","十四","十五","十六","十七","十八","十九","二十","二十一","二十二","二十三","二十四","二十五","二十六","二十七","二十八","二十九","三十","三十一"]
        return days[myComponents.month! - 1] + "月" + days[myMonths.day! - 1] + "日"
    }
    
}
