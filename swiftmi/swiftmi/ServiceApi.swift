//
//  ServiceApi.swift
//  swiftmi
//
//  Created by yangyin on 15/4/4.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import UIKit

class ServiceApi: NSObject {
   
    static var host:String = "http://demo.swiftmi.com"
    
     internal class func getTopicUrl(maxId:Int,count:Int) -> String {
        
        return "\(host)/api/topic/list2/\(maxId)/\(count)"
    }
    
    internal class func getTopicDetail(topicId:Int) -> String {
        
        return "\(host)/api/topic/\(topicId)"
    }
    
    internal class func getTopicShareDetail(topicId:Int) -> String {
        
        return "\(host)/topic/\(topicId).html"
    }
    
    internal class func getCodeShareDetail(codeId:Int) -> String {
        
        return "\(host)/code4swift/\(codeId).html"
    }
    
    internal class func getCodeUrl(maxId:Int,count:Int) -> String {
        
        return "\(host)/api/sharecode/list/\(maxId)/\(count)"
    }
    
    internal class func getCodeDetailUrl(codeId:Int) -> String {
        
        return "\(host)/api/sharecode/\(codeId)"
    }
    
    internal class func getBookUrl(type:Int,maxId:Int,count:Int) -> String{
        
        let url="\(host)/api/books/\(type)/\(maxId)/\(count)"
        return url
    }
    
    class func getLoginUrl()->String {
        let url = "\(host)/api/user/login"
        return url;
    }
    
    class func getRegistUrl() -> String {
        
        let url = "\(host)/api/user/reg"
        return url;
    }
    class func getTopicCommentUrl() -> String {
        
        let url = "\(host)/api/topic/comment"
        return url;
    }
    
    class func getCreateTopicUrl() -> String {
        
        let url = "\(host)/api/topic/create"
        return url;
    }
}
