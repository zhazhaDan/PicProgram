//
//  AppDelegate.swift
//  Xiangshuispace
//
//  Created by 龚丹丹 on 2017/7/7.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isDone:Bool = false
    var isLetterShowed:Bool = false
//    var gifWindow:UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIBarButtonItem.appearance().tintColor = xsColor_text_black
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = BaseTabBarController()//GifViewController()
        //BaseTabBarController()// HomePageNavigationController.init(rootViewController: BaseTabBarController())
//        self.gifWindow = UIWindow.init(frame: UIScreen.main.bounds)
//        self.gifWindow?.rootViewController = GifViewController()
        self.window?.makeKeyAndVisible()
        let gitVC = GifView.init(frame: UIScreen.main.bounds)
        gitVC.buildUI()
        self.window?.addSubview(gitVC)
        return RegistThirdAppDelegate.shareDelegate.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

//    @objc func gifDone() {
//        if isDone == true {
//            return
//        }
//        UIView.animate(withDuration: 0.5, animations: {
//            self.gifWindow?.alpha = 0.2
//        }) { (finished) in
//            if finished == true {
//                self.window?.makeKeyAndVisible()
//                self.gifWindow = UIWindow.init(frame: UIScreen.main.bounds)
//                self.gifWindow?.backgroundColor = UIColor.clear
//                self.isDone = true
//            }
//        }
//    }
    
    func changeLanguage() {
        HUDTool.show(.loading, view: self.window!)
        let tabController = BaseTabBarController()
        self.window?.rootViewController = tabController
        let vc = SettingViewController()
        vc.hidesBottomBarWhenPushed = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            (tabController.selectedViewController as!UINavigationController).pushViewController(vc, animated: true)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
       appSaveContext()
    }
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "PicProgram")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
   
    
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.tianxintang.gd.test2" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "PicProgram", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            #if DEBUG
                abort()
            #else
            #endif
            
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    // MARK: - Core Data Saving support
    func saveOldContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                #if DEBUG
                    abort()
                #else
                #endif
            }
        }
    }
    
    func appSaveContext() {
        if #available(iOS 10.0, *) {
            self.saveContext()
        } else {
            self.saveOldContext()
            // Fallback on earlier versions
        }
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return RegistThirdAppDelegate.shareDelegate.application(app, open: url, options:options)
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return RegistThirdAppDelegate.shareDelegate.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
    }
    
    //notification
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        RegistThirdAppDelegate.shareDelegate.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        RegistThirdAppDelegate.shareDelegate.application(application, didRegister: notificationSettings)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        RegistThirdAppDelegate.shareDelegate.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        RegistThirdAppDelegate.shareDelegate.application(application, performFetchWithCompletionHandler: completionHandler)
    }
    
    // iOS 10        APNs                     AppDelegate.m     didReceiveRemoteNotification          SDK
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        RegistThirdAppDelegate.shareDelegate.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        RegistThirdAppDelegate.shareDelegate.application(application, didReceiveRemoteNotification: userInfo)
    }
   }

