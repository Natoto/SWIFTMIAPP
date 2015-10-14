//
//  CodeDal.swift
//  swiftmi
//
//  Created by yangyin on 15/4/30.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class CodeDal: NSObject {
   
    func addList(items:JSON) {
        
        for po in items {
            
            self.addCode(po.1, save: false)
        }
        
        CoreDataManager.shared.save()
    }
    
    func addCode(obj:JSON,save:Bool){
        
        
        let context=CoreDataManager.shared.managedObjectContext;
        
        
        let model = NSEntityDescription.entityForName("Codedown", inManagedObjectContext: context)
        
        let codeDown = ShareCode(entity: model!, insertIntoManagedObjectContext: context)
        
        if model != nil {
            
            self.obj2ManagedObject(obj, codeDown: codeDown)
            
            if(save)
            {
                CoreDataManager.shared.save()
                
            }
        }
    }
    
    func deleteAll(){
        
        CoreDataManager.shared.deleteTable("Codedown")
    }
    
    func save(){
        
        let context=CoreDataManager.shared.managedObjectContext;
        do {
            try context.save()
        } catch _ {
        }
    }
    
    func getCodeList()->[AnyObject]? {
        
        let request = NSFetchRequest(entityName: "Codedown")
        let sort1=NSSortDescriptor(key: "createTime", ascending: false)
        
        // var sort2=NSSortDescriptor(key: "postId", ascending: false)
        request.fetchLimit = 30
        request.sortDescriptors = [sort1]
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        let result = CoreDataManager.shared.executeFetchRequest(request)
        return result
        
    }
    
    
    func obj2ManagedObject(obj:JSON,codeDown:ShareCode) -> ShareCode{
        
        var data = obj
        
        codeDown.author = data["author"].string
        codeDown.categoryId = data["categoryId"].int64Value
        codeDown.categoryName = data["categoryName"].string
        codeDown.codeId = data["codeId"].int64Value
        codeDown.commentCount = data["commentCount"].int32Value
        codeDown.content = data["content"].string
        codeDown.contentLength  = data["contentLength"].doubleValue
        codeDown.createTime = data["createTime"].int64Value
        codeDown.desc = data["desc"].string
        codeDown.devices = data["devices"].string
        codeDown.downCount = data["downCount"].int32Value
        codeDown.downUrl = data["downUrl"].stringValue
        codeDown.isHtml = data["isHtml"].int32Value
        codeDown.keywords = data["keywords"].string
        if data["lastCommentId"].int64 != nil {
            codeDown.lastCommentId = data["lastCommentId"].int64Value
            
        }
        codeDown.lastCommentTime = data["lastCommentTime"].int64Value
        codeDown.licence = data["licence"].string
        codeDown.platform = data["platform"].string
        codeDown.preview = data["preview"].stringValue
        codeDown.sourceName = data["sourceName"].stringValue
        codeDown.sourceType = data["sourceType"].int32Value
        codeDown.sourceUrl = data["sourceUrl"].stringValue
        codeDown.state = data["state"].int32Value
        codeDown.tags = data["tags"].string
        codeDown.title = data["title"].string
        codeDown.updateTime = data["updateTime"].int64Value
        codeDown.userId = data["userId"].int64Value
        codeDown.username = data["username"].stringValue
        codeDown.viewCount = data["viewCount"].int32Value
        
        return codeDown
        
        
    
     }
}
