//
//  WebViewController.swift
//  swiftmi
//
//  Created by yangyin on 15/5/3.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {

    internal var isPop:Bool = false
    
    internal var webUrl:String?
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.delegate = self
        if webUrl != nil {
            
            self.pleaseWait()
            
            let url = NSURL(string: webUrl!)
            let request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
        }
        if self.title == nil {
            self.title = "内容"

        }
        
        setWebViewTop()
        // Do any additional setup after loading the view.
    }

   
    private func setWebViewTop(){
        
        if self.isPop {
            for constraint in self.view.constraints {
                if constraint.firstAttribute == NSLayoutAttribute.Top {
                    let inputWrapContraint = constraint as NSLayoutConstraint
                    inputWrapContraint.constant =  UIApplication.sharedApplication().statusBarFrame.height+self.navigationController!.navigationBar.frame.height
                     
                    break;
                }
            }
            
            
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        
        setWebViewTop()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopAndClose(sender: AnyObject) {
        
        webView.stopLoading()

         self.clearAllNotice()
        if self.isPop {
            self.navigationController?.popViewControllerAnimated(true)
            
        }else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
       
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.clearAllNotice()
    }
    
    @IBAction func refreshWebView(sender: AnyObject) {
         webView.reload()
        
    }
    
    
    @IBAction func rewindWebView(sender: AnyObject) {
        
 
         webView.goBack()
    }

    @IBAction func forwardWebView(sender: AnyObject) {
        
         webView.goForward()
    }
    
    
    @IBAction func shareClick(sender: AnyObject) {
        
        let url = NSURL(fileURLWithPath:self.webView.request!.URL!.absoluteString)
        let title = self.webView.stringByEvaluatingJavaScriptFromString("document.title")
        
        let activityViewController = UIActivityViewController(activityItems: [title!,url], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true,completion:nil)
       
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
       self.clearAllNotice()
        self.pleaseWait()
        return true 
    }
    func webViewDidStartLoad(webView: UIWebView)
    {
        
    }
    func webViewDidFinishLoad(webView: UIWebView)
    {
        self.clearAllNotice()
        
        self.title =  self.webView.stringByEvaluatingJavaScriptFromString("document.title")
        
        
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
    
    
        self.clearAllNotice()
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
        self.clearAllNotice()
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
