//
//  ShareThirdAppTool.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/8/17.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit
import FBSDKShareKit
import TwitterKit

let WXAPPID = "wx4f0a156d8bb04f93"//"wxd477edab60670232"//"wx4f0a156d8bb04f93"
//let WXAPPSECRET = "4c7fd889d4f2902c0ca4108dc06dd422"
let WBAPPKEY = "1695158483"
let WBAPPSECRET = "da72736fd76eac3d4342cf99733dfa16"
let WBRedirectURL = "https://api.weibo.com/oauth2/default.html"

let TwitterAPPKEY = "Y54ikILtTwI9hiUVkebzxK9bU"
let TwitterAPPSECRET = "APQ8mhqcdXxcRENfsMowmIMKf52y81F9o9Mdsby3tugo65MsXL"


class ShareThirdAppTool: NSObject,WXApiDelegate,WeiboSDKDelegate,FBSDKSharingDelegate,UIDocumentInteractionControllerDelegate {
    
     var title:String!
     var webUrl:String!
    var sharePath:String!
     var desc:String!
     var share_icon:UIImage!
    //单例
    var shareComplete:((Bool) -> Void)!
    var documentController:UIDocumentInteractionController!
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
        let imageObj = WBImageObject()
        imageObj.imageData = UIImagePNGRepresentation(share_icon)
        wbmesObj.imageObject = imageObj
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
    
    func shareToFacebook() {
        let instagramUrl = URL.init(string: "fbshareextension://")
        if UIApplication.shared.canOpenURL(instagramUrl!) {
            let content = FBSDKSharePhotoContent.init()
            let photo = FBSDKSharePhoto.init(image: share_icon, userGenerated: true)
            content.photos = [photo]
            let dialog = FBSDKShareDialog.show(from: UIApplication.shared.keyWindow?.rootViewController, with: content, delegate: self)
            dialog?.mode = FBSDKShareDialogMode.native
            
        }else {
            HUDTool.show(.text, nil, text: MRLanguage(forKey: "Not installed app"), delay: 0/8, view: (UIApplication.shared.keyWindow?.rootViewController?.view)!, complete: nil)
        }
        
        
    }
    
    func shareToTwitter() {
        let instagramUrl = URL.init(string: "twitterauth://")
        if UIApplication.shared.canOpenURL(instagramUrl!) {
            Twitter.sharedInstance().start(withConsumerKey: TwitterAPPKEY, consumerSecret: TwitterAPPSECRET)
//        Twitter.sharedInstance().logIn { (session, error) in
//            if session == nil {
//                HUDTool.show(.text, nil, text: error?.localizedDescription, delay: 1, view: (UIApplication.shared.keyWindow?.rootViewController?.view)!, complete: nil)
//                return
//            }
            let composer = TWTRComposer.init()
//            composer.setText("分享")
            composer.setImage(self.share_icon)
//            composer.setURL(URL.init(string: "https://www.baidu.com"))
            composer.show(from: (UIApplication.shared.keyWindow?.rootViewController)!) { (result) in
                if result == TWTRComposerResult.cancelled {
                    self.shareResult("用户取消")
                }else if result == TWTRComposerResult.done {
                    self.shareResult("分享成功")
                }
            }
//        }
        
        }else {
            HUDTool.show(.text, nil, text: MRLanguage(forKey: "Not installed app"), delay: 0/8, view: (UIApplication.shared.keyWindow?.rootViewController?.view)!, complete: nil)
        }
       
    }
    
    func shareToInstagram() {
        let instagramUrl = URL.init(string: "instagram://app")
        if UIApplication.shared.canOpenURL(instagramUrl!) {
//            UIApplication.shared.openURL(instagramUrl!)
            let documentDirectory = NSHomeDirectory() + "/Documents/Image.igo"
            let imageData = UIImagePNGRepresentation(share_icon) as! NSData
            imageData.write(toFile: documentDirectory, atomically: true)
            let imageUrl = URL.init(fileURLWithPath: documentDirectory)
            documentController = UIDocumentInteractionController.init(url: imageUrl)
            documentController.delegate = self
            documentController.annotation = ["InstagramCaption":"Testing"]
            documentController.uti = "com.instagram.photo"//"com.instagram.exclusivegram"
            let vc = UIApplication.shared.keyWindow?.rootViewController
            documentController.presentOpenInMenu(from: CGRect.zero, in:(vc?.view)!, animated: true)
            
        }else {
            HUDTool.show(.text, nil, text: MRLanguage(forKey: "Not installed app"), delay: 0/8, view: (UIApplication.shared.keyWindow?.rootViewController?.view)!, complete: nil)
        }
    }
    
    
    // 微信分享回调
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
       BaseAlertController.inits(text, message: nil, confirmText: "确定", nil, subComplete: nil)
//        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    // FBSDKSharingDelegate
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        let postId = results["postId"]
        let dialog = sharer as! FBSDKShareDialog
        if dialog.mode == FBSDKShareDialogMode.browser && (postId == nil || postId as! String == "" ){
            // 如果使用webview分享的，但postId是空的，
            // 这种情况是用户点击了『完成』按钮，并没有真的分享
            NSLog("Cancel");
        }else {
            shareResult("分享成功")
        }
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        let dialog = sharer as! FBSDKShareDialog
        if error == nil  && dialog.mode == FBSDKShareDialogMode.native {
            dialog.mode = FBSDKShareDialogMode.browser
            dialog.show()
        }else {
            shareResult("分享失败")
        }
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        shareResult("用户取消")
    }
    
    
}
