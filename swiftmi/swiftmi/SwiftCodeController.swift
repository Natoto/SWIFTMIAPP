//
//  SwiftCodeController.swift
//  swiftmi
//
//  Created by yangyin on 15/4/1.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

let reuseIdentifier = "CodeCell"

class SwiftCodeController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
 
    let sectionInsets = UIEdgeInsets(top:6, left: 6, bottom: 6, right: 6)
    
    internal var data:[AnyObject] = [AnyObject]()
    
    var loading:Bool = false
 
    
    private func getDefaultData(){
        
        let dalCode = CodeDal()
        
        let result = dalCode.getCodeList()
        
        if result != nil {
            
            self.data = result!
            self.collectionView?.reloadData()
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.collectionViewLayout.collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.collectionView?.addHeaderWithCallback{
            self.loadData(0, isPullRefresh: true)
        }
      
                
       // (self.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize =   CGSize(width: width, height: 380)
        
        self.collectionView?.addFooterWithCallback{
            
            if(self.data.count>0) {
                let  maxId = self.data.last!.valueForKey("codeId") as! Int
                self.loadData(maxId, isPullRefresh: false)
            }
        }
        
        getDefaultData()
        
        self.collectionView?.headerBeginRefreshing()

    }
    
    



    func loadData(maxId:Int,isPullRefresh:Bool){
        if self.loading {
            return
        }
        self.loading = true
        
        
//        Alamofire.request(Router.CodeList(maxId: maxId, count: 12)).responseJSON{
//            closureResponse in
        Alamofire.request(Router.TopicList(maxId: maxId, count: 16)).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (request, closureResponse, Result) -> Void in
            
            self.loading = false
            
            if(isPullRefresh){
                
                 self.collectionView?.headerEndRefreshing()
            }
            else{
                self.collectionView?.footerEndRefreshing()
            }
            if Result.isFailure {
                self.notice("网络异常", type: NoticeType.error, autoClear: true)
                return
            } 
            
            let json = Result.value//.result.value;
            
            let result = JSON(json!)
            
            if result["isSuc"].boolValue {
                
                let items = result["result"]
                
                if(items.count==0){
                    return
                }
                
                if(isPullRefresh){
                    
                    
                    let dalCode = CodeDal()
                    dalCode.deleteAll()
                    
                    dalCode.addList(items)
                    
                    self.data.removeAll(keepCapacity: false)
                }
                
                 
                for  it in items {
                    
                    self.data.append(it.1.object);
                    
                   // println("data length \(self.data.count)")
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.collectionView!.reloadData()
                    
                }
                
                
                
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        var item = self.collectionView?.indexPathsForSelectedItems()
        
        if item?.count > 0 {
            
            let indexPath = item![0] 
            
            if segue.destinationViewController is CodeDetailViewController {
                let view = segue.destinationViewController as! CodeDetailViewController
                
                let code: AnyObject = self.data[indexPath.row]
                view.shareCode = code
                
                
            }
        }
        
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.data.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView!.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CodeCell
     
    
        let item: AnyObject = self.data[indexPath.row]
        
        // Configure the cell
        var preview = item.valueForKey("preview") as? String
        if preview != nil {
            if (preview!.hasPrefix("http://img.swiftmi.com")){
                preview = "\(preview!)-code"
            }
            cell.preview.kf_setImageWithURL(NSURL(string: preview!)!, placeholderImage: nil)
        }
        
        let pubTime = item.valueForKey("createTime") as! Double
        let createDate = NSDate(timeIntervalSince1970: pubTime)
        
        cell.timeLabel.text = Utility.formatDate(createDate)
        
        cell.title.text = item.valueForKey("title") as? String
       
       
       //cell.addShadow()
        
        

        
        
        return cell
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let frame  = self.view.frame;
        var width = frame.width

        
        if (frame.width > frame.height) {
            width = frame.height
        }
        width = CGFloat(Int((width-18)/2))
       // println("width....\(width)")
        return CGSize(width: width, height: 380)
        
    }
    

    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 6
    }
    
     func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
     {
         return 6
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return sectionInsets
    }
 
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        collectionView.layer.shadowOpacity = 0.8 
        return true
    }
    
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    

}