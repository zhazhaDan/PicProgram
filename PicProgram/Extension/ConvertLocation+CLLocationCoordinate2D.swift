//
//  ChangeCoornade.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/8/2.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit
import MapKit
extension  CLLocationCoordinate2D{
    
    /**
     * 腾讯经纬度(中国经纬度)转百度经纬度
     */
    func convert_GCJ02_To_BD09() -> CLLocationCoordinate2D{
        let x_pi = 2.14159265358979324 * 3000.0 / 180.0
        let x = longitude
        let y = latitude
        let z = sqrt(x*x+y*y) + 0.00002 * sin(y*x_pi)
        let theta = atan2(y, x) + 0.000003 * cos(x*x_pi)
        let longi = z * cos(theta) + 0.0065
        let lati = z * sin(theta) + 0.006
        return CLLocationCoordinate2D.init(latitude: lati, longitude: longi)
    }
    
    /**
     * 百度经纬度转腾讯经纬度(中国经纬度)
     */
    
    func convert_BD09_To_GCJ02() -> CLLocationCoordinate2D{
        let x = longitude - 0.0065
        let y = latitude - 0.006
        let x_pi = 3.14159265358979324 * 3000.0 / 180.0
        let z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi)
        let theta = atan2(y,x) - 0.000003 * cos(x*x_pi)
        let longi = z*cos(theta)
        let lati = z*sin(theta)
        return CLLocationCoordinate2D.init(latitude: lati, longitude: longi)
    }
    
    /**
     * 计算两个经纬度之间的距离
     */
    func getRad(_ d:Double) -> Double{
        return d * Double.pi / 180.0;
    }
    func getDistance(_ lat2:Double, lng2:Double) -> Int{
        let EARTH_RADIUS = 6378137.0
        let lat1 = getRad(latitude)
        let lon1 = getRad(longitude)
        let lat2 = getRad(lat2)
        let lon2 = getRad(lng2)
        let dlon = lon2 - lon1
        let dlat = lat2 - lat1
        let a = pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2)
        return Int(2.0 * asin(sqrt(a)) * EARTH_RADIUS)
    }
    
    func showDistance(distance:Int) -> String {
        if distance >= 1000 {
            return "\(Double(distance) / 1000.0)千"
        }else {
            return "\(distance)"
        }
    }
    
}
