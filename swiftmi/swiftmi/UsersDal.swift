//
//  UsersDal.swift
//  swiftmi
//
//  Created by yangyin on 15/4/18.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON


class UsersDal: NSObject {
    
    
    
    func addUser(obj:JSON,save:Bool)->Users? {
        
        
        let context=CoreDataManager.shared.managedObjectContext;
        
        
        let model = NSEntityDescription.entityForName("Users", inManagedObjectContext: context)
        
        let user = Users(entity: model!, insertIntoManagedObjectContext: context)
        
        if model != nil {
           
            let addUser = self.JSON2Object(obj, user: user)
            
            if(save)
            {
                CoreDataManager.shared.save()
                
            }
            
            return addUser
        }
        return nil
    }
    
    internal func deleteAll(){
        
        CoreDataManager.shared.deleteTable("Users")
    }
    
   internal  func save(){
        let context=CoreDataManager.shared.managedObjectContext;
        do {
            try context.save()
        } catch _ {
        }
    }
    
   internal  func getCurrentUser()->Users? {
        
        let request = NSFetchRequest(entityName: "Users")
        request.fetchLimit = 1
        
    
        let result = CoreDataManager.shared.executeFetchRequest(request)
        if let users = result {
            
            if (users.count > 0 ){
                 return users[0] as? Users
            }
            return nil
           
        }
        else {
            return nil
        }
        
    }
    
    internal func JSON2Object(obj:JSON,user:Users) -> Users{
        
        var data = obj
        
        let userId = data["userId"].int64!
        let username = data["username"].string!
        let email = data["email"].string
        let following_count = data["following_count"].int32!
        let follower_count = data["follower_count"].int32!
        let points = data["points"].int32!
        
        let signature = data["signature"].string
        let profile = data["profile"].string
        let isAdmin = data["isAdmin"].int32!
        let avatar = data["avatar"].string
        let createTime =  data["createTime"].int64!
        let updateTime = data["updateTime"].int64!
       
        
        user.userId = userId
        user.username = username
        user.email = email
        user.follower_count = follower_count
        user.following_count = following_count
        user.points = points
        user.signature = signature
        user.profile = profile
        user.isAdmin = isAdmin
        user.avatar = avatar
        user.createTime = createTime
        user.updateTime = updateTime
        
        return user;
    }
}
