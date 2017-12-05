//
//  AppDelegate+RegistThirdAppKeys.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/7/25.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
import UIKit

class RegistThirdAppDelegate: UIResponder {
    
    var wx_token:String?
    //单例
    class var shareDelegate: RegistThirdAppDelegate {
        struct Singleton {
            static let instance = RegistThirdAppDelegate()
        }
        return Singleton.instance
    }
    
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        
        ShareSDK.registerActivePlatforms(
            [SSDKPlatformType.typeSinaWeibo.rawValue,SSDKPlatformType.typeWechat.rawValue,SSDKPlatformType.typeTwitter.rawValue,SSDKPlatformType.typeFacebook.rawValue],
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform
                {
                case SSDKPlatformType.typeSinaWeibo:
                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                case SSDKPlatformType.typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                default:
                    break
                }
        },
            onConfiguration: {(platform : SSDKPlatformType , appInfo : NSMutableDictionary?) -> Void in
                switch platform
                {
                case SSDKPlatformType.typeSinaWeibo:
                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                    appInfo?.ssdkSetupSinaWeibo(byAppKey: "568898243",
                                                appSecret: "38a4f8204cc784f81f9f0daaf31e02e3",
                                                redirectUri: "http://www.sharesdk.cn",
                                                authType: SSDKAuthTypeBoth)
                    
                case SSDKPlatformType.typeWechat:
                    //设置微信应用信息
                    appInfo?.ssdkSetupWeChat(byAppId: "wx4868b35061f87885",
                                             appSecret: "64020361b8ec4c99936c0e3999a9f249")
                case SSDKPlatformType.typeTwitter:
                    appInfo?.ssdkSetupTwitter(byConsumerKey: "", consumerSecret: "", redirectUri: "")
                default:
                    break
                }
        })
        UserInfo.user.readUserDefaults()

        return true
    }
    
    
    func networkStatusListener() {
        let reachability = Reachability()!
        reachability.whenUnreachable = {
            reachability in
            DispatchQueue.main.async {
                
            }
        }
        do {
            try reachability.startNotifier()
        }catch {
            
        }
    }
    
    
     func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return true
    }
     func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return self.application(application, open: url, options: [:])
    }
    
    //notification
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
    }
 
    func isOnlineResponse(_ response: [AnyHashable : Any]!) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        networkStatusListener()
    }
    
}
