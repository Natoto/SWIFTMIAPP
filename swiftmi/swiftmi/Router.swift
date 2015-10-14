//
//  Router.swift
//  swiftmi
//
//  Created by yangyin on 15/4/23.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import UIKit
import Alamofire



enum Router: URLRequestConvertible {
   
    static var token: String?
    
    //Restfull api
    case TopicComment(parameters:[String: AnyObject])
    case TopicCreate(parameters:[String: AnyObject])
    case TopicList(maxId:Int,count:Int)
    case TopicDetail(topicId:Int)
    case CodeList(maxId:Int,count:Int)
    case CodeDetail(codeId:Int)
    case BookList(type:Int,maxId:Int,count:Int)
    case UserRegister(parameters:[String: AnyObject])
    case UserLogin(parameters:[String: AnyObject])
    
    var method: Alamofire.Method {
        switch self {
        case .TopicComment:
            return .POST
        case .TopicCreate:
            return .POST
        case .TopicDetail:
            return .GET
            
        case .TopicList:
            return .GET
        case .CodeList:
            return .GET
        case .CodeDetail:
            return .GET
        case .BookList:
            return .GET
        case .UserRegister:
            return .POST
        case .UserLogin:
            return .POST
        }
        
    }
    
    
    var path: String {
        switch self {
        case .TopicComment:
            return ServiceApi.getTopicCommentUrl()
        
        case .TopicCreate:
            return ServiceApi.getCreateTopicUrl()
            
        case .TopicDetail(let topicId):
            
            return ServiceApi.getTopicDetail(topicId)
            
        case .TopicList(let maxId,let count):
            return ServiceApi.getTopicUrl(maxId,count:count)
        case .CodeList(let maxId,let count):
            return ServiceApi.getCodeUrl(maxId,count:count)
        case .BookList(let type,let maxId,let count):
            return ServiceApi.getBookUrl(type, maxId: maxId, count: count)
        case .UserLogin(_):
            return ServiceApi.getLoginUrl()
        case .UserRegister(_):
            return ServiceApi.getRegistUrl()
        case .CodeDetail(let codeId):
            return ServiceApi.getCodeDetailUrl(codeId)
        }
    }
    
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: path)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = method.rawValue
        
        if let token = Router.token {
            mutableURLRequest.setValue("\(token)", forHTTPHeaderField: "token")
        }
        switch self {
        case .TopicComment(let parameters):
            
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .TopicCreate(let parameters):
            
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .UserRegister(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .UserLogin(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            
        default:
            return mutableURLRequest
        }
    }
}
