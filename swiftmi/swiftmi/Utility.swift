//
//  Utility.swift
//  swiftmi
//
//  Created by yangyin on 15/4/21.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import UIKit


class Utility: NSObject {
   
    class func GetViewController<T>(controllerName:String)->T {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let toViewController = mainStoryboard.instantiateViewControllerWithIdentifier(controllerName) as! T
        return toViewController
        
    }
    
    class func formatDate(date:NSDate)->String {
    
        let fmt = NSDateFormatter()
         
        fmt.dateFormat = "yyyy-MM-dd"
        let dateString = fmt.stringFromDate(date)
        return dateString
    }
    
    class func showMessage(msg:String) {
        
        let alert = UIAlertView(title: "提醒", message: msg, delegate: nil, cancelButtonTitle: "确定")
        alert.show()
    }
    
    //SDKShare Show
    final class func share(title:String,desc:String,imgUrl:String?,linkUrl:String) {
        
        var img = imgUrl
        if img == nil {
            img = "http://swiftmi.qiniudn.com/swiftmi180icon.png"
        }
        
        var text = desc;
        if text == "" {
            text = title;
        }
        
        let textWithUrl = "\(title) \(linkUrl)"
    
        let shareParams = NSMutableDictionary();
        
        shareParams.SSDKSetupShareParamsByText(text, images: [img!], url: NSURL(string: linkUrl), title: title, type: SSDKContentType.Auto)
        
        shareParams.SSDKSetupWeChatParamsByText(text, title: title, url: NSURL(string:linkUrl), thumbImage: img, image: img, musicFileURL: nil, extInfo: nil, fileData: nil, emoticonData: nil, type: SSDKContentType.Image, forPlatformSubType: SSDKPlatformType.TypeWechat)
        
        shareParams.SSDKSetupCopyParamsByText(textWithUrl, images: nil, url:  NSURL(string: linkUrl), type: SSDKContentType.Text)
        
        shareParams.SSDKSetupSinaWeiboShareParamsByText(title, title: title, image: [img!], url: NSURL(string:linkUrl), latitude: 0.0, longitude: 0.0, objectID: "", type: SSDKContentType.Auto)
        
        shareParams.SSDKSetupSMSParamsByText(textWithUrl, title: textWithUrl, images: nil, attachments: nil, recipients: nil, type: SSDKContentType.Text)
        
        let items = [SSDKPlatformType.TypeSinaWeibo.rawValue,SSDKPlatformType.TypeWechat.rawValue,SSDKPlatformType.TypeSMS.rawValue,SSDKPlatformType.TypeCopy.rawValue];
        
        ShareSDK.showShareActionSheet(nil, items: items, shareParams: shareParams) { (state:SSDKResponseState, type:SSDKPlatformType, userData:[NSObject : AnyObject]!, contentEntity:SSDKContentEntity!, error:NSError!, end:Bool) -> Void in
            switch(state) {
            case SSDKResponseState.Success:
                let alert = UIAlertView(title: "提示", message:"分享成功", delegate:self, cancelButtonTitle: "ok")
                alert.show()
            case SSDKResponseState.Fail:
                let alert = UIAlertView(title: "提示", message:"分享失败：\(error)", delegate:self, cancelButtonTitle: "ok")
                alert.show()

            default:
                break;
            }
            
        }
        
     }
}
