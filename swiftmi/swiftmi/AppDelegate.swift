//
//  AppDelegate.swift
//  
//
//  Created by yangyin on 15/4/10.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Router.token = KeychainWrapper.stringForKey("token")
        
    
        
        
        ShareSDK.registerApp("74dcfcc8d1d3", activePlatforms: [SSDKPlatformType.TypeCopy.rawValue, SSDKPlatformType.TypeSinaWeibo.rawValue,SSDKPlatformType.TypeWechat.rawValue,SSDKPlatformType.TypeSMS.rawValue], onImport: {
            
            (platformType:SSDKPlatformType) in
            
            switch(platformType) {
            case SSDKPlatformType.TypeSinaWeibo:
                ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
           case SSDKPlatformType.TypeWechat:
                 ShareSDKConnector.connectWeChat(WXApi.classForCoder())
            default:
                break;
                
            }
            
            }, onConfiguration:{
                
                (platformType:SSDKPlatformType,appInfo:NSMutableDictionary!)  in
                
                switch(platformType) {
                    
                 case SSDKPlatformType.TypeSinaWeibo:
                    appInfo.SSDKSetupSinaWeiboByAppKey("568898243", appSecret: "38a4f8204cc784f81f9f0daaf31e02e3", redirectUri: "http://www.sharesdk.cn", authType: SSDKAuthTypeBoth)
                    
                 case SSDKPlatformType.TypeWechat:
                    appInfo.SSDKSetupWeChatByAppId("wx4868b35061f87885", appSecret: "64020361b8ec4c99936c0e3999a9f249")
                    
                default:
                    break;
                
                
                }
        })
        
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
    
        return true;
      //  return ShareSDK.handleOpenURL(url, wxDelegate: self)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return true;
       // return ShareSDK.handleOpenURL(url, sourceApplication: sourceApplication, annotation: annotation, wxDelegate: self)
    }


}

