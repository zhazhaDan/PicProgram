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
//let baseApi = "http://app.atmoran.com/api/"
let baseApi = "http://dev.xiangshuispace.com:9988/api/"
//let baseApi = "https://www.xiangshuispace.com/api/"
    
#else
//let baseApi = "http://47.94.245.138:9090/api/"
let baseApi = "http://app.atmoran.com/api/"

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
    case paint_play_style
    case paint_picPlay
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
    case user_set_header
    case user_set_back
    case user_get_device
    case user_get_device_info
    case user_set_info
    case user_collect_list
    case user_bind_device
    case user_set_play_device
    case user_delete_device
    case user_master_solve_device
    case classify_get_art_home
    case classify_get_scene_home
    case user_report
    case user_third_login
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
            method = .post
            let paint_id:Int64 = params!["paint_id"] as! Int64
            apiString = "painting/\(paint_id)/info"
            realParams?.removeValue(forKey: "paint_id")
//            realParams = nil
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
        case .paint_picPlay:
            apiString = "painting/picture_play"
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
            let device_id = params!["device_id"]
            apiString = "master/\(device_id as! String)/get_device_info"
            realParams = nil
        case .user_bind_device:
            apiString = "user/device_bind"
        case .user_set_info:
            apiString = "user/set_info"
        case .user_collect_list:
            method = .get
            apiString = "painting/mylist"
        case .user_master_solve_device:
            apiString = "master/process_device_bind"
        case .user_delete_device:
            apiString = "user/delete_bind"
        case .paint_play_style:
            apiString = "painting/modify_play_type"
        case .user_set_header:
            apiString = "imgs/upload/user_head"
        case .user_set_back:
            apiString = "imgs/upload/backend_img"
        case .user_set_play_device:
            apiString = "device/set_play_device"
        case .user_report:
            apiString = "user/proposal"
        case .user_third_login:
            apiString = "user/bind_thirdparty"
        default:
            apiString = ""
            method = .get
        }
        baseRequest(method, api: apiString, params: realParams, finishedCallback: { (result) in
            if finishedCallback != nil{
                finishedCallback!(result)
            }
        }) {
//            HUDTool.show(.error, text: "网络开小差了", delay: 1, view: UIApplication.shared.keyWindow!, complete: nil)
//            if failCallBack != nil {
//                failCallBack!()
//            }
            let vc = NoWifiViewController()
            appDelegate.window?.rootViewController?.present(vc, animated: true, completion: {
                if failCallBack != nil {
                    failCallBack!()
                } 
            })
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
        if BaseBundle.language == EN {
            headerDict["en"] = "1"
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
               
                if (((resultDict["ret"] as! Int) < -100) && ((resultDict["ret"] as! Int) > -200)) {
                    UserInfo.user.localLogout()
                    HUDTool.hide()
                }else {
                    finishedCallback!(resultDict)
                }
               
                
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
    //图片上传
    func uploadPic(image:UIImage,apiType: RequestAPIType,finishedCallback: ((_ result : [String:Any])->())? = nil) {
        var apiString = ""
        switch apiType {
        case .user_set_header:
            apiString = "imgs/upload/user_head"
        case .user_set_back:
            apiString = "imgs/upload/backend_img"
        default:
            apiString = ""
        }
        
        let imageData = resetSizeOfImageData(source_image: image, maxSize: 512) as Data
        var headerDict = ["content-type": "application/json","User-Uin": "\(UserInfo.user.uin)","Req-From": "iOS-app"]
        if UserInfo.user.token.count > 0 {
            headerDict["Client-Token"] = UserInfo.user.token
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: "file", fileName: "tmp.jpg", mimeType: "image/jpeg")
        },usingThreshold:UInt64.init(), to: "\(baseApi)\(apiString)", method:.post,headers: headerDict, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let JSON = response.result.value {
                        let dict = JSON as! [String:Any]
                        //这里处理JSON数据
                        var item:[String:Any] = [:]
                        item["url"] = dict["url"]
                        item["image"] = image
                        item["ret"] = 0
                        finishedCallback!(item)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                var item:[String:Any] = [:]
                item["err"] = "图片上传失败"
                item["ret"] = -1
                finishedCallback!(item)
            }
        })
    }
    
    
    // MARK: - 降低质量
    func resetSizeOfImageData(source_image: UIImage!, maxSize: Int) -> NSData {
        
        //先判断当前质量是否满足要求，不满足再进行压缩
        var finallImageData = UIImageJPEGRepresentation(source_image,1.0)
        let sizeOrigin      = finallImageData?.count
        let sizeOriginKB    = sizeOrigin! / 1024
        if sizeOriginKB <= maxSize {
            return finallImageData! as NSData
        }
        
        //先调整分辨率
        var defaultSize = CGSize(width: 1024, height: 1024)
        let newImage = self.newSizeImage(size: defaultSize, source_image: source_image)
        
        finallImageData = UIImageJPEGRepresentation(newImage,1.0);
        
        //保存压缩系数
        let compressionQualityArr = NSMutableArray()
        let avg = CGFloat(1.0/250)
        var value = avg
        
        var i = 250
        repeat {
            i -= 1
            value = CGFloat(i)*avg
            compressionQualityArr.add(value)
        } while i >= 1
        
        
        /*
         调整大小
         说明：压缩系数数组compressionQualityArr是从大到小存储。
         */
        //思路：使用二分法搜索
        finallImageData = self.halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], image: newImage, sourceData: finallImageData!, maxSize: maxSize)
        //如果还是未能压缩到指定大小，则进行降分辨率
        while finallImageData?.count == 0 {
            //每次降100分辨率
            if defaultSize.width-100 <= 0 || defaultSize.height-100 <= 0 {
                break
            }
            defaultSize = CGSize(width: defaultSize.width-100, height: defaultSize.height-100)
            let image = self.newSizeImage(size: defaultSize, source_image: UIImage.init(data: UIImageJPEGRepresentation(newImage, compressionQualityArr.lastObject as! CGFloat)!)!)
            finallImageData = self.halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], image: image, sourceData: UIImageJPEGRepresentation(image,1.0)!, maxSize: maxSize)
        }
        
        return finallImageData! as NSData
    }
    
    // MARK: - 调整图片分辨率/尺寸（等比例缩放）
    func newSizeImage(size: CGSize, source_image: UIImage) -> UIImage {
        var newSize = CGSize(width: source_image.size.width, height: source_image.size.height)
        let tempHeight = newSize.height / size.height
        let tempWidth = newSize.width / size.width
        
        if tempWidth > 1.0 && tempWidth > tempHeight {
            newSize = CGSize(width: source_image.size.width / tempWidth, height: source_image.size.height / tempWidth)
        } else if tempHeight > 1.0 && tempWidth < tempHeight {
            newSize = CGSize(width: source_image.size.width / tempHeight, height: source_image.size.height / tempHeight)
        }
        
        UIGraphicsBeginImageContext(newSize)
        source_image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    // MARK: - 二分法
    func halfFuntion(arr: [CGFloat], image: UIImage, sourceData finallImageData: Data, maxSize: Int) -> Data? {
        var tempFinallImageData = finallImageData
        
        var tempData = Data.init()
        var start = 0
        var end = arr.count - 1
        var index = 0
        
        var difference = Int.max
        while start <= end {
            index = start + (end - start)/2
            
            tempFinallImageData = UIImageJPEGRepresentation(image, arr[index])!
            
            let sizeOrigin = tempFinallImageData.count
            let sizeOriginKB = sizeOrigin / 1024
            
            print("当前降到的质量：\(sizeOriginKB)\n\(index)----\(arr[index])")
            
            if sizeOriginKB > maxSize {
                start = index + 1
            } else if sizeOriginKB < maxSize {
                if maxSize-sizeOriginKB < difference {
                    difference = maxSize-sizeOriginKB
                    tempData = tempFinallImageData
                }
                if index<=0 {
                    break
                }
                end = index - 1
            } else {
                break
            }
        }
        return tempData
    }
    
}

