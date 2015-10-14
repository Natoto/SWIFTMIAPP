//
//  AlamofireRequestEX.swift
//  swiftmi
//
//  Created by zeno on 15/10/14.
//  Copyright © 2015年 swiftmi. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class AlamofireRequestEX: NSObject {

}

class ResponseEX: NSObject {
    var response:NSHTTPURLResponse? = nil
    var result:Result? = Result.Success("")
}
//class ResponseEX: NSObject {
//    var response:NSHTTPURLResponse
//    var result:Result
//}

//typealias funcBlockB = (Int,Int) -> (String)->()
//extension Request
//{
//    //  Alamofire.request(Router.TopicCreate(parameters: params)).responseJSON{  closureResponse in
//    public func responseJSON(
//        options options: NSJSONReadingOptions = .AllowFragments,
//        completionHandler: (resp:ResponseEX) -> Void)
//        -> Self
//    {//closureResponse.result
//        
//        var completionHandler2 : (NSURLRequest?, NSHTTPURLResponse?, Result<AnyObject>) -> Void) =
//        (req:NSURLRequest?,resp: NSHTTPURLResponse?,res: Result<AnyObject>) -> Void)
//        {
//            
//        }
//        return response(
//            responseSerializer: Request.JSONResponseSerializer(options: options),
//            completionHandler:{
//                completionHandler.(resp: <#T##ResponseEX#>)
//            }
//        )
//    }
//}
