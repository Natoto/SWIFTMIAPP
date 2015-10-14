//
//  ShareCode.swift
//  swiftmi
//
//  Created by yangyin on 15/4/2.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import UIKit
import CoreData


@objc(ShareCode)
class ShareCode: NSManagedObject {
   
    @NSManaged var author:String?
    @NSManaged var categoryId:Int64
    @NSManaged var categoryName:String?
    @NSManaged var codeId:Int64
    @NSManaged var commentCount:Int32
    @NSManaged var content:String?
    @NSManaged var contentLength:Double
    @NSManaged var createTime:Int64
    @NSManaged var desc:String?
    @NSManaged var devices:String?
    @NSManaged var downCount:Int32
    @NSManaged var downUrl:String
    @NSManaged var isHtml:Int32
    @NSManaged var keywords:String?
    @NSManaged var lastCommentId:Int64
    @NSManaged var lastCommentTime:Int64
    @NSManaged var licence:String?
    @NSManaged var platform:String?
    @NSManaged var preview:String
    @NSManaged var sourceName:String
    @NSManaged var sourceType:Int32
    @NSManaged var sourceUrl:String
    @NSManaged var state:Int32
    @NSManaged var tags:String?
    @NSManaged var title:String?
    @NSManaged var updateTime:Int64
    @NSManaged var userId:Int64
    @NSManaged var username:String
    @NSManaged var viewCount:Int32
    
}
