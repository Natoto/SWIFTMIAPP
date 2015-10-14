//
//  Post.swift
//  swiftmi
//
//  Created by yangyin on 15/3/28.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import Foundation
import CoreData

@objc(Post)
public class Post:NSManagedObject {
    
    @NSManaged var postId:Int64
    @NSManaged var title:String?
    @NSManaged var content:String?
    @NSManaged var createTime:Int64
    @NSManaged var updateTime:Int64
    @NSManaged var channelId:Int64
    @NSManaged var channelName:String?
    @NSManaged var commentCount:Int32
    @NSManaged var lastCommentId:Int64
    @NSManaged var lastCommentTime:Int64
    @NSManaged var viewCount:Int32
    @NSManaged var authorId:Int64
    @NSManaged var authorName:String?
    @NSManaged var avatar:String?
    @NSManaged var cmtUserId:Int64
    @NSManaged var cmtUserName:String?
    @NSManaged var desc:String?
    @NSManaged var isHtml:Int32
    
    
    
}