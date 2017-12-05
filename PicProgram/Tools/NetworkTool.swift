//
//  NetworkManager.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/7/7.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
import Alamofire

#if DEBUG
let baseApi = "http://dev.xiangshuispace.com:9988/api/"
//let baseApi = "https://www.xiangshuispace.com/api/"
    
#else
let baseApi = "https://www.xiangshuispace.com/api/"
    
#endif
enum Method {
    case get
    case post
}

enum RequestAPIType {
    case discovery_recommend
    case discovery_poineer
    case discovery_cqlist
    case discovery_mqlove
    case paint_info
    case paint_list
    case paint_collect
    case paint_play
    case paint_tips
    case paint_lining
    case search_hotwords
    case search_info
    case picture_info
    case user_register
    case user_login
    case user_send_code
    case user_verify_code
    case user_reset_password
    case user_logout
    case user_info
    case user_get_device
    case user_get_device_info
    case classify_get_art_home
    case classify_get_scene_home
    case default_api
}



let network = NetworkTool.network

class  NetworkTool{
    //单例
    class var network: NetworkTool {
        struct Singleton {
            static let instance = NetworkTool()
        }
        return Singleton.instance
    }
    
    var downloadRequest:DownloadRequest!
    var destinationPath:DownloadRequest.DownloadFileDestination!
    var cancelledData:Data?
    
    //网络请求
    func requestData(_ apiType: RequestAPIType, params:[String: Any]?=nil,finishedCallback: ((_ result : [String:Any])->())? = nil,_ failCallBack:(()->Void)? = nil) {
        if params != nil {
            print("requst params is \(params)")
        }
        var method = Method.post
        var apiString = ""
        var realParams = params
        switch apiType {
        case .discovery_recommend:
            method = .get
            apiString = "discovery/get_recommend_home"
        case .discovery_poineer:
            method = .get
            apiString = "discovery/get_pioneer_home"
        case .discovery_cqlist:
            method = .get
            apiString = "discovery/get_cq_list"
        case .discovery_mqlove:
            apiString = "discovery/mq_love"
        case .paint_info:
            method = .get
            let paint_id:Int = params!["paint_id"] as! Int
            apiString = "painting/\(paint_id)/info"
            realParams = nil
        case .paint_list:
            method = .get
            let type = params!["type_id"] as! Int
            apiString = "painting/\(type)/paint_list"
            realParams = nil
        case .paint_collect:
            apiString = "painting/collect"
        case .search_hotwords:
            method = .get
            apiString = "search/get_hot_words"
            realParams = nil
        case .search_info:
            method = .get
            let kw = params!["kw"] as! String
            apiString = "search/info?kw=\(kw)"
            realParams = nil
        case .picture_info:
            method = .get
            let picture_id = params!["picture_id"] as! Int
            apiString = "painting/picture/\(picture_id)/info"
            realParams = nil
        case .paint_play:
            apiString = "painting/play"
        case .paint_tips:
            apiString = "painting/add_tips"
        case .paint_lining:
            apiString = "painting/add_frame"
        case .user_register:
            apiString = "user/register"
        case .user_login:
            apiString = "user/login"
        case .user_send_code:
            apiString = "user/send_code"
        case .user_verify_code:
            apiString = "user/verify_code"
        case .user_reset_password:
            apiString = "user/reset_password"
        case .user_logout:
            method = .get
            apiString = "user/logout"
        case .user_info:
            method = .get
            apiString = "user/get_info"
        case .classify_get_art_home:
            method = .get
            apiString = "classify/get_art_home"
        case .classify_get_scene_home:
            method = .get
            apiString = "classify/get_scene_home"
        case .user_get_device:
            method = .get
            apiString = "user/get_bind_device"
        case .user_get_device_info:
            method = .get
            apiString = ""
        default:
            apiString = ""
            method = .get
        }
        baseRequest(method, api: apiString, params: realParams, finishedCallback: { (result) in
            if finishedCallback != nil{
                finishedCallback!(result)
            }
        }) {
            HUDTool.show(.error, text: "网络开小差了", delay: 1, view: UIApplication.shared.keyWindow!, complete: nil)
            if failCallBack != nil {
                failCallBack!()
            }
        }
    }
    
    
    fileprivate func baseRequest(_ type: Method, api:String, params:[String: Any]?=nil,finishedCallback: ((_ result : [String:Any])->())? = nil,_ failCallBack:(()->Void)? = nil) {
        var method  = HTTPMethod.get
        let corApi = baseApi + api
        let url:URL = URL.init(string: corApi.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        switch type {
        case .get:
            method = .get
        case  .post:
            method = .post
        }
        print("\(corApi)")
        var headerDict = ["content-type": "application/json","User-Uin": "\(UserInfo.user.uin)","Req-From": "iOS-app"]
        if UserInfo.user.token.count > 0 {
            headerDict["Client-Token"] = UserInfo.user.token
        }
        print(headerDict)
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default,headers:headerDict)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("进度: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // 自定义的校验闭包, 现在加上了 `data` 参数(允许你提前转换数据以便在必要时挖掘到错误信息)
                return .success
            }
            .responseJSON{(response) in
                print(response.result.value as Any)
                guard let result = response.result.value else {
                    failCallBack!()
                    return
                }
                let resultDict = result as! [String : Any]
               
                    finishedCallback!(resultDict)
               
                
        }
    }
    
    func downloadRequest(_ type: Method, api:String, params:[String: Any]?=nil, progressCallback: ((_ progress: Double)->Void)? = nil,_ finishedCallback:((_ successed:Bool)->Void)? = nil){
        self.destinationPath = {_, response in
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileUrl = documentsPath.appendingPathComponent(response.suggestedFilename!)
            print("\(fileUrl)")
            return (fileUrl,[.removePreviousFile, .createIntermediateDirectories])
        }
        
        if let cancelledData = self.cancelledData {
            self.downloadRequest = Alamofire.download(resumingWith: cancelledData, to: destinationPath)
        }else {
            downloadRequest = Alamofire.download(api, to: destinationPath)
        }
        
        self.downloadRequest.downloadProgress(queue: DispatchQueue.main) { (progress) in
            progressCallback!(progress.fractionCompleted)
        }
        
        self.downloadRequest.responseData { (response) in
            switch response.result {
            case .success(_):
                finishedCallback!(true)
            case .failure:
                finishedCallback!(false)
                self.cancelledData = response.resumeData
            }
        }
    }
    
}

