//
//  PostTableViewController.swift
//  swiftmi
//
//  Created by yangyin on 15/3/23.
//  Copyright (c) 2015year swiftmi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


class PostTableViewController: UITableViewController {

    internal var data:[AnyObject] = [AnyObject]()
    
    var loading:Bool = false
    
    
    private func getDefaultData(){
    
        let dalPost = PostDal()
        
        let result = dalPost.getPostList()
        
        if result != nil {
            self.data = result!
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   self.view.backgroundColor = UIColor.greenColor()
         self.tableView.estimatedRowHeight = 120;
        self.tableView.rowHeight = UITableViewAutomaticDimension
       
        
        //读取默认数据
        getDefaultData()
        
        self.tableView.addHeaderWithCallback{
            
            self.loadData(0, isPullRefresh: true)
        }
        
        self.tableView.addFooterWithCallback{
            
            if(self.data.count>0) {
                let  maxId = self.data.last!.valueForKey("postId") as! Int
                self.loadData(maxId, isPullRefresh: false)
            }
        }
        
        self.tableView.headerBeginRefreshing()
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.data.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       //let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! PostCell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostCell
        
        let item: AnyObject = self.data[indexPath.row]
        
        let commentCount = item.valueForKey("viewCount") as? Int
        
        cell.commentCount.text = "\(commentCount!)"
        
        let pubTime = item.valueForKey("createTime") as! Double
        let createDate = NSDate(timeIntervalSince1970: pubTime)
        
        cell.timeLabel.text = Utility.formatDate(createDate)
        
        //println(item.valueForKey("commentCount") as? Int)
        
        cell.title.text = item.valueForKey("title") as? String
        cell.authorName.text = item.valueForKey("authorName") as? String
        cell.channelName.text = item.valueForKey("channelName") as? String
      
        
        cell.avatar.kf_setImageWithURL(NSURL(string: item.valueForKey("avatar") as! String+"-a80")!, placeholderImage: nil)
        
        
        cell.avatar.layer.cornerRadius = 5
        cell.avatar.layer.masksToBounds = true
       // cell.avatar.set
        // Configure the cell...
        cell.selectionStyle = .None;
        cell.updateConstraintsIfNeeded()
        // cell.contentView.backgroundColor = UIColor.grayColor()

       // cell.selectedBackgroundView = cell.containerView
        
       
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostCell
        cell.containerView.backgroundColor = UIColor(red: 0.85, green: 0.85, blue:0.85, alpha: 0.9)
    }
    

    
    var prototypeCell:PostCell?
    
    private func configureCell(cell:PostCell,indexPath: NSIndexPath,isForOffscreenUse:Bool){
        
        let item: AnyObject = self.data[indexPath.row]
        cell.title.text = item.valueForKey("title") as? String
        cell.channelName.text = item.valueForKey("channelName") as? String
        cell.selectionStyle = .None;
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if prototypeCell == nil
        {
            self.prototypeCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as? PostCell
        }
        
        self.configureCell(prototypeCell!, indexPath: indexPath, isForOffscreenUse: false)
        
        self.prototypeCell?.setNeedsUpdateConstraints()
        self.prototypeCell?.updateConstraintsIfNeeded()
        self.prototypeCell?.setNeedsLayout()
        self.prototypeCell?.layoutIfNeeded()
        
        
        let size = self.prototypeCell!.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
       
        return size.height;
        
    }
     
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.data.count-1 {
          
           // self.tableView.footerBeginRefreshing()
          //  loadData(self.data[indexPath.row].valueForKey("postId") as! Int,isPullRefresh:false)
            
        }
    }
    
    func loadData(maxId:Int,isPullRefresh:Bool){
        if self.loading {
            return
        }
        self.loading = true
        Alamofire.request(Router.TopicList(maxId: maxId, count: 16)).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (request, closureResponse, Result) -> Void in
            
            self.loading = false
            
            if(isPullRefresh){
                self.tableView.headerEndRefreshing()
            }
            else{
                self.tableView.footerEndRefreshing()
            }
            if Result.isFailure {
                let alert = UIAlertView(title: "网络异常", message: "请检查网络设置", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
                return
            }
            
            
            let json = Result.value //. .result.value
            var result = JSON(json!)
            
            if result["isSuc"].boolValue {
                
                let items = result["result"].object as! [AnyObject]
               
                if(items.count==0){
                    return
                }
                
                if(isPullRefresh){
                    
                    

                    
                    let dalPost = PostDal()
                    dalPost.deleteAll()
                    
                    dalPost.addPostList(items)
                    
                    self.data.removeAll(keepCapacity: false)
                }
                
                
                for  it in items {
                    
                    self.data.append(it);
                }
                dispatch_async(dispatch_get_main_queue()) {
                  
                    
                   self.tableView.reloadData()
                }
               
                
                
            }
        }
    }
    
     /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    @IBAction func addTopic(sender: UIButton) {
    
        if KeychainWrapper.stringForKey("token") == nil {
           
            //未登录
            
            let loginController:LoginController = Utility.GetViewController("loginController")
            
            self.navigationController?.pushViewController(loginController, animated: true)
            
        }
    }
   
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
 
        if identifier == "toAddTopic" {
        
            if KeychainWrapper.stringForKey("token") == nil {
            
                //未登录
                return false
            }
        }
        return true
        
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "PostDetail" {
            
            if segue.destinationViewController is PostDetailController {
                let view = segue.destinationViewController as! PostDetailController
                let indexPath = self.tableView.indexPathForSelectedRow
                
                let article: AnyObject = self.data[indexPath!.row]
                view.article = article
                
                
            }
        }
        
        
       
        
    }
    

}
