//
//  PostDetailController.swift
//  swiftmi
//
//  Created by yangyin on 15/4/4.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class PostDetailController: UIViewController,UIScrollViewDelegate,UIWebViewDelegate,UITextViewDelegate {

    @IBOutlet weak var webView: UIWebView! 
    @IBOutlet weak var inputWrapView: UIView!
    
    @IBOutlet weak var inputReply: UITextView!
    var article:AnyObject?
    
    var postId:Int?
    
    var postDetail:JSON = nil
    
    var keyboardShow = false
    
     
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        //center.addObserver(self, selector:"keyboardWillChangeFrame:", name:UIKeyboardWillChangeFrameNotification,object:nil)
    
       
        self.setViews()
        
        
        self.inputReply.layer.borderWidth = 1
        self.inputReply.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue:0.85, alpha: 0.9).CGColor
        // Keyboard stuff.

        //
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.userActivity = NSUserActivity(activityType: "com.swiftmi.handoff.view-web")
        self.userActivity?.title = "view article on mac"
        self.userActivity?.webpageURL  =  NSURL(string: ServiceApi.getTopicShareDetail(article!.valueForKey("postId") as! Int))
        self.userActivity?.becomeCurrent()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
       NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    
        self.userActivity?.invalidate()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
       
        
        let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let endKeyboardRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        
        
      
        
        var frame = self.view.frame
        frame.origin.y = -endKeyboardRect.height
         
        
    UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.webView.stringByEvaluatingJavaScriptFromString("$('body').css({'padding-top':'\(endKeyboardRect.height)px'});")
            
        for constraint in self.inputWrapView.constraints {
            if constraint.firstAttribute == NSLayoutAttribute.Height {
                let inputWrapContraint = constraint as NSLayoutConstraint
                inputWrapContraint.constant = 80
               // self.inputWrapView.updateConstraintsIfNeeded()
                break;
            }
        }
        
            self.view.frame = frame
            
            }, completion: nil)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        
        
        
         let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        
        
        var frame = self.view.frame
        frame.origin.y = 0 // keyboardHeight
        
        
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.webView.stringByEvaluatingJavaScriptFromString("$('body').css({'padding-top':'0px'});")
                self.view.frame = frame
            
            for constraint in self.inputWrapView.constraints {
                if constraint.firstAttribute == NSLayoutAttribute.Height {
                    let inputWrapContraint = constraint as NSLayoutConstraint
                    inputWrapContraint.constant = 50
                    // self.inputWrapView.updateConstraintsIfNeeded()
                    break;
                }
            }
            
            }, completion: nil)

    }
    
    
    private func GetLoadData() -> JSON {
        
        if postDetail != nil {
            return self.postDetail
        }
    
        var json:JSON = ["comments":[]]
        
        json["topic"] =  JSON(self.article!)
     
        return json
    }

    func loadData(){
        
//        Alamofire.request(Router.TopicDetail(topicId: (article!.valueForKey("postId") as! Int))).responseJSON{
//            closureResponse in
        
        Alamofire.request(Router.TopicDetail(topicId: (article!.valueForKey("postId") as! Int))).responseJSON { (request, closureResponse, Result) -> Void in
            if Result.isFailure {
                
                let alert = UIAlertView(title: "网络异常", message: "请检查网络设置", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
                
            }
            else {
                
                let json = Result.value//.result.value
                
                let result = JSON(json!)
                
                if result["isSuc"].boolValue {
                    
                    self.postDetail =  result["result"]
                    
                }
                
            }
           
            
            let path=NSBundle.mainBundle().pathForResource("article", ofType: "html")
            
            let url=NSURL.fileURLWithPath(path!)
            let request = NSURLRequest(URL:url)
            dispatch_async(dispatch_get_main_queue()) {
                self.inputWrapView.hidden = false
                self.webView.loadRequest(request)
            }

        }
        
    }
    
     func setViews(){
        
        self.view.backgroundColor=UIColor.whiteColor()
     
        self.webView.backgroundColor=UIColor.clearColor()
        
        self.inputReply.resignFirstResponder()
        self.webView.delegate=self
        self.webView.scrollView.delegate=self
        
        
      
                
      //  self.inputView
        
        self.startLoading()
        self.inputWrapView.hidden = true
        self.title="主题贴"
        self.loadData()
        
    
       
    }
    
    @IBAction func replyClick(sender: AnyObject) {
        
        let msg = inputReply.text;
        inputReply.text = "";
        if msg != nil {
            
            let postId  = article!.valueForKey("postId") as! Int
            let params:[String:AnyObject] = ["postId":postId,"content":msg]
            
            
//            Alamofire.request(Router.TopicComment(parameters: params)).responseJSON{
//                closureResponse in
        Alamofire.request(Router.TopicComment(parameters: params)).responseJSON { (request, closureResponse, Result) -> Void in
                if Result.isFailure {
                    
                    self.notice("网络异常", type: NoticeType.error, autoClear: true)
                    return
                }
                 
                let json = Result.value//.result.value
                let result = JSON(json!)
                
                if result["isSuc"].boolValue {
                    
                    self.notice("评论成功!", type: NoticeType.success, autoClear: true)
                    
                    self.webView.stringByEvaluatingJavaScriptFromString("article.addComment("+result["result"].rawString()!+");")
                    
                    
                    
                } else {
                    
                     self.notice("评论失败!", type: NoticeType.error, autoClear: true)
                }
            }
        }
    }
    
    
    func startLoading(){
        self.pleaseWait()
        self.webView.hidden=true
        
        
    }
    
    func stopLoading(){
        self.webView.hidden=false
        self.clearAllNotice()
    }


    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        let reqUrl=request.URL!.absoluteString
        let params = reqUrl.componentsSeparatedByString("://")
        
        dispatch_async(dispatch_get_main_queue(),{
            
            
           
            if(params.count>=2){
                if(params[0].compare("html")==NSComparisonResult.OrderedSame && params[1].compare("docready") ==  NSComparisonResult.OrderedSame ){
                  
                    
                    let data = self.GetLoadData()
                   
                    self.webView.stringByEvaluatingJavaScriptFromString("article.render("+data.rawString()!+");")
                    
                    
                }
                else if(params[0].compare("html")==NSComparisonResult.OrderedSame && params[1].compare("contentready")==NSComparisonResult.OrderedSame){
                   
                    //doc content ok
                    self.stopLoading()
                }
                else if params[0].compare("http") == NSComparisonResult.OrderedSame || params[0].compare("https") == NSComparisonResult.OrderedSame  {
                    
                    let webViewController:WebViewController = Utility.GetViewController("webViewController")
                    webViewController.webUrl = reqUrl
                    self.presentViewController(webViewController, animated: true, completion: nil)
                    
                }
                
                
            }
            
            })
        
        if params[0].compare("http") == NSComparisonResult.OrderedSame || params[0].compare("https") == NSComparisonResult.OrderedSame {
            return false
        }
        return true;
    }
     func webViewDidStartLoad(webView: UIWebView)
    {
        
    }
     func webViewDidFinishLoad(webView: UIWebView)
     {
        
    }
     func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
     {
        
    }


    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareClick(sender: AnyObject) {
        
        share()
    }
    
    private func share() {
        
        let data = GetLoadData()
        let title = data["topic"]["title"].stringValue
        let url = ServiceApi.getTopicShareDetail(data["topic"]["postId"].intValue)
        let desc = data["topic"]["desc"].stringValue
        
        let img = self.webView.stringByEvaluatingJavaScriptFromString("article.getShareImage()")
        
        
        Utility.share(title, desc: desc, imgUrl: img, linkUrl: url)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
        self.clearAllNotice()
    }
    

}
