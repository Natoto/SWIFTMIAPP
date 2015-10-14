//
//  CodeDetailViewController.swift
//  swiftmi
//
//  Created by yangyin on 15/4/28.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


class CodeDetailViewController: UIViewController,UIWebViewDelegate {


    var shareCode:AnyObject?
    
    var newShareCode:JSON?
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViews()
        
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        
        
        self.userActivity = NSUserActivity(activityType: "com.swiftmi.handoff.view-web")
        self.userActivity?.title = "view source on mac"
        self.userActivity?.webpageURL  =  NSURL(string: ServiceApi.getCodeShareDetail(shareCode!.valueForKey("codeId") as! Int))
        self.userActivity?.becomeCurrent()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setViews(){
        
        self.view.backgroundColor=UIColor.whiteColor()
        self.webView.backgroundColor=UIColor.clearColor()
        self.webView.delegate = self
        self.startLoading()
        
        self.loadData()
         
    }
    
    private func startLoading(){
        self.pleaseWait()
        self.webView.hidden=true
        
        
    }
    
   private func stopLoading(){
        self.webView.hidden=false
        self.clearAllNotice()
    }
    
    
    private func GetLoadData() -> JSON {
        
        if newShareCode != nil {
            return self.newShareCode!
        }
        
        var json:JSON = ["comments":[]]
        json["code"] =  JSON(self.shareCode!)
        
        return json
    }
    

   private func loadData(){
        
//        Alamofire.request(Router.CodeDetail(codeId: shareCode!.valueForKey("codeId") as! Int)).responseJSON{
//            closureResponse in
    
    Alamofire.request(Router.CodeDetail(codeId: shareCode!.valueForKey("codeId") as! Int)).responseJSON { (request, closureResponse, Result) -> Void in
            if(Result.isFailure){
                
                self.notice("网络异常", type: NoticeType.error, autoClear: true)
            }
            else {
                let json = Result.value;//.result.value
                
                let result = JSON(json!)
                
                if result["isSuc"].boolValue {
                    
                    self.newShareCode =  result["result"]
                    
                }
                
            }
            
            
            let path=NSBundle.mainBundle().pathForResource("code", ofType: "html")
            
            let url=NSURL.fileURLWithPath(path!)
            let request = NSURLRequest(URL:url)
            dispatch_async(dispatch_get_main_queue()) {
                
                self.webView.loadRequest(request)
            }
            
        }
        
    }
    
    
    

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
       
        let reqUrl=request.URL!.absoluteString
        var params = reqUrl.componentsSeparatedByString("://")
        
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
    
    
    @IBAction func shareClick(sender: AnyObject) {
        
        share()
    }
    
    private func share() {
        
        var data = GetLoadData()
        let title = data["code"]["title"].stringValue
        let url = ServiceApi.getCodeShareDetail(data["code"]["codeId"].intValue)
        let desc = data["code"]["desc"].stringValue
        
        var preview = data["code"]["preview"].stringValue
        
        if preview != "" {
            
            if (preview.hasPrefix("http://img.swiftmi.com")){
                preview = "\(preview)-code"
            }
        }
        
        
        Utility.share(title, desc: desc, imgUrl: preview, linkUrl: url)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        self.clearAllNotice()
        
        self.userActivity?.invalidate()
        
        
        super.viewDidDisappear(animated)
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
