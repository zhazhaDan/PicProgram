//
//  ShareThirdAppTool.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/8/17.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit
let WXAPPID = "wx3ed1c44f65cb2ec7"
let WBAPPKEY = "1695158483"
let WBAPPSECRET = "da72736fd76eac3d4342cf99733dfa16"
let WBRedirectURL = "https://api.weibo.com/oauth2/default.html"

class ShareThirdAppTool: NSObject,WXApiDelegate,WeiboSDKDelegate {
    
     var title:String!
     var webUrl:String!
    var sharePath:String!
     var desc:String!
     var share_icon:UIImage!
    //单例
    var shareComplete:((Bool) -> Void)!
    class var share: ShareThirdAppTool {
        struct Singleton {
            static let instance = ShareThirdAppTool()
        }
        return Singleton.instance
    }
    
    
    func shareToWX(_ chatOrline:WXScene) {
        let ext=WXImageObject()
        ext.imageData=UIImagePNGRepresentation(share_icon)
        
        let message=WXMediaMessage()
        message.title=nil
        message.description=nil
        message.mediaObject=ext
        message.mediaTagName="MyPic"
        //生成缩略图 
        UIGraphicsBeginImageContext(CGSize.init(width: 100, height: 100))
        #imageLiteral(resourceName: "login_logo").draw(in: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        let thumbImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        message.thumbData=UIImagePNGRepresentation(thumbImage!)
        
        let imageObj = WXImageObject.init()
        imageObj.imageData = UIImagePNGRepresentation(share_icon)
        message.mediaObject = imageObj
        let req=SendMessageToWXReq()
        req.text=nil
        req.message=message
        req.bText=false
        req.scene = Int32(chatOrline.rawValue)
        WXApi.send(req)
    }
    
    
    func shareToWeibo() {
        let wbmesObj = WBMessageObject.message() as! WBMessageObject
//        let webpage = WBWebpageObject.object() as! WBWebpageObject
//        webpage.objectID = "identifier1";
//        webpage.title = title
//        webpage.description = desc
        let imageObj = WBImageObject()
        imageObj.imageData = UIImagePNGRepresentation(share_icon)
        wbmesObj.imageObject = imageObj
//        if WeiboSDK.isCanShareInWeiboAPP() {
//            let image = UIImage.init(named: share_icon)
//            webpage.thumbnailData = UIImagePNGRepresentation(#imageLiteral(resourceName: "logo"))
//            webpage.webpageUrl = webUrl
//            wbmesObj.mediaObject = webpage;
//        }else {
//            wbmesObj.text = "\(title as! String)\(webUrl as! String)"
            
//            let image = UIImage.init(named: share_icon)
//            wbmesObj.imageObject = WBImageObject.object() as! WBImageObject
//            wbmesObj.imageObject.imageData = UIImagePNGRepresentation(image!)
//        }
        let authRequest = WBAuthorizeRequest.init()
        authRequest.redirectURI = WBRedirectURL;
        authRequest.scope = "all";

       
        let request = WBSendMessageToWeiboRequest.request(withMessage: wbmesObj, authInfo: authRequest, access_token: RegistThirdAppDelegate.shareDelegate.wx_token) as! WBSendMessageToWeiboRequest
        request.userInfo = ["ShareMessageFrom": "InviteViewController",
                            "Other_Info_1": 123,
                            "Other_Info_2": ["obj1", "obj2"],
                            "Other_Info_3": ["key1": "obj1", "key2": "obj2"]]
        if (WeiboSDK.send(request)) {
        }
    }
    func shareToTencent() {
//        let image = UIImage.init(named: share_icon)
        let data = UIImagePNGRepresentation(share_icon!)
//        let obj = QQApiNewsObject(url: URL.init(string: webUrl), title: title, description: desc, previewImageData: data, targetContentType: QQApiURLTargetTypeNews)
//        let req = SendMessageToQQReq(content: obj)
//        // 分享到QQ
//        QQApiInterface.send(req)
    }
    
    
    func onResp(_ resp: BaseResp!) {
        if resp.errCode < 0 {
//            shareResult(text: resp.errStr)
        }else {
            shareResult("分享成功")
            
        }
    }
    
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        /*
         WeiboSDKResponseStatusCodeSuccess = 0,
         WeiboSDKResponseStatusCodeUserCancel = -1,
         WeiboSDKResponseStatusCodeSentFail = -2,
         WeiboSDKResponseStatusCodeAuthDeny = -3,
         WeiboSDKResponseStatusCodeUserCancelInstall = -4,
         WeiboSDKResponseStatusCodeUnsupport = -99,
         WeiboSDKResponseStatusCodeUnknown = -100,
         */
        
        if response.statusCode == .userCancel {
            shareResult("用户取消")
        }else if response.statusCode == .success{
            shareResult("分享成功")
        }else{
            shareResult("分享失败")
        }
    
    
    }
    
    func shareResult(_ text:String = "分享成功") {
        let alert = BaseAlertController.init(text, message: nil, confirmText: "确定", nil, subComplete: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
