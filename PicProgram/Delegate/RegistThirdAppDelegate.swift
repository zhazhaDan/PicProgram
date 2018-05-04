//
//  AppDelegate+RegistThirdAppKeys.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/7/25.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import UserNotifications
import TwitterKit



let GTAPPKEY = "MxomNCKZml9NclLWPz9kl6"
let GTAPPID = "AaFCgeHNR47biqwmDyRJd7"
let GTAPPSECRET = "ISgE6b9pLM7xFcr8gWpNU7"

class RegistThirdAppDelegate: UIResponder,GeTuiSdkDelegate,UNUserNotificationCenterDelegate {
    
    var wx_token:String?
    //单例
    class var shareDelegate: RegistThirdAppDelegate {
        struct Singleton {
            static let instance = RegistThirdAppDelegate()
        }
        return Singleton.instance
    }
    
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        WXApi.registerApp(WXAPPID)
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp(WBAPPKEY)
        GeTuiSdk.start(withAppId: GTAPPID, appKey: GTAPPKEY, appSecret: GTAPPSECRET, delegate: self)
        registRemoteNotifications()
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
    
    func registRemoteNotifications() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options:[.alert,.badge,.sound,.carPlay], completionHandler: { (granted, error) in
                print("request result\(granted) ,\(error?.localizedDescription)")
            })
            UIApplication.shared.registerForRemoteNotifications()
            let settings = UIUserNotificationSettings.init(types: [.alert,.badge,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        } else if #available(iOS 8.0, *){
            // Fallback on earlier versions
            UIApplication.shared.registerForRemoteNotifications()
            let settings = UIUserNotificationSettings.init(types: [.alert,.badge,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
     func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == "response" {//微博
            let rootVC = appDelegate.window?.rootViewController?.presentedViewController?.childViewControllers.first
            if (rootVC != nil && (rootVC?.isKind(of: SBLoginViewController.self))!) {
                WeiboSDK.handleOpen(url, delegate: rootVC as! WeiboSDKDelegate)
            }else {
                WeiboSDK.handleOpen(url, delegate: ShareThirdAppTool.share)
            }

        }else if url.host == "platformId=wechat" {//微信分享
            WXApi.handleOpen(url, delegate: ShareThirdAppTool.share as WXApiDelegate)
        }else if url.host == "oauth" {//微信分享
            let nvc = (UIApplication.shared.keyWindow?.rootViewController as! BaseTabBarController).selectedViewController as! UINavigationController
            WXApi.handleOpen(url, delegate: nvc.visibleViewController as! WXApiDelegate)
        }else if url.absoluteString.hasPrefix("twitterkit-Y54ikILtTwI9hiUVkebzxK9bU") {
            Twitter.sharedInstance().application(app, open: url, options: options)
        }
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
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceToken_ns = NSData.init(data: deviceToken)    // 转换成NSData类型
        var token = deviceToken_ns.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>"));
        token = token.replacingOccurrences(of: " ", with: "")
        // [ GTSdk ]：向个推服务器注册deviceToken
        GeTuiSdk.registerDeviceToken(token)
        print("\n>>>[DeviceToken Success]:%@\n\n",token)
        
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        GeTuiSdk.resume()
        completionHandler(.newData)
    }
    
    // iOS 10        APNs                     AppDelegate.m     didReceiveRemoteNotification          SDK
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        GeTuiSdk.handleRemoteNotification(userInfo)
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        GeTuiSdk.handleRemoteNotification(userInfo)
    }
    
    //iOS10
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        GeTuiSdk.handleRemoteNotification(response.notification.request.content.userInfo)
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }
    
    
    //getuiSdk delegate
    func geTuiSdkDidRegisterClient(_ clientId: String!) {
        print("getui -->>>>> \(clientId)")
        UserInfo.user.client_id = clientId
        if UserInfo.user.checkUserLogin() {
            UserInfo.user.updateIgetuiClient(clientId: clientId)
        }
    }
    
    func geTuiSdkDidOccurError(_ error: Error!) {
        print(error.localizedDescription)
    }
    
    func geTuiSdkDidReceivePayloadData(_ payloadData: Data!, andTaskId taskId: String!, andMsgId msgId: String!, andOffLine offLine: Bool, fromGtAppId appId: String!) {
        let payload = NSData.init(data: payloadData);
        //        let alert = XSAlertController.init("推送内容", message: String.init(data: payload as Data, encoding: .utf8), confirmText: "确认", nil, subComplete: nil)
        //        (UIApplication.shared.keyWindow?.rootViewController as! XSNavigationController).present(alert, animated: true, completion: nil)// 转换成NSData类型
        //        if offLine {
        //            return
        //        }
        do {
            let dict = try JSONSerialization.jsonObject(with: payloadData, options: .allowFragments) as! [String : Any]
            print(dict)
        }catch {
            
        }
        //        let msg = NSString.init(data: payloadData, encoding: String.Encoding.utf8.rawValue)
        //        print("taskId=\(taskId),messageId:\(msgId),payloadMsg :\(msg as! String)\(offLine ? "<离线消息>" : "<在线消息>")")
    }
 
    func isOnlineResponse(_ response: [AnyHashable : Any]!) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        networkStatusListener()
    }
    
}
