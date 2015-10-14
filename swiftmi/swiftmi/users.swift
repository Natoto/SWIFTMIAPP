//
//  users.swift
//  swiftmi
//
//  Created by yangyin on 15/4/18.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import UIKit
import CoreData

@objc(Users)
class Users: NSManagedObject {
   
    @NSManaged var userId:Int64
    @NSManaged var username:String
    @NSManaged var following_count:Int32
    @NSManaged var follower_count:Int32
    @NSManaged var points:Int32
    @NSManaged var signature:String?
    @NSManaged var profile:String?
    @NSManaged var isAdmin:Int32
    @NSManaged var email:String?
    @NSManaged var avatar:String?
    @NSManaged var createTime:Int64
    @NSManaged var updateTime:Int64
    
}
