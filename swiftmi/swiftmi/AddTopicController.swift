//
//  AddTopicController.swift
//  swiftmi
//
//  Created by yangyin on 15/4/23.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class AddTopicController: UIViewController {

    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var titleField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setView()
        
    }
    
    @IBAction func publishClick(sender: AnyObject) {
        
        let title = self.titleField.text
        let content = self.contentField.text
        
        if title!.isEmpty {
            Utility.showMessage("标题不能为空!")
            return
            
        }
        
        if content.isEmpty {
            Utility.showMessage("内容不能为空!")
            return
            
        }
        
        if title != nil {
            
            let btn = sender as! UIButton
            
            btn.enabled = false
          
            let params:[String:AnyObject] = ["title":title!,"content":content!,"channelId":1]
            
//            Alamofire.request(Router.TopicCreate(parameters: params)).responseJSON{
//                closureResponse in
              Alamofire.request(Router.TopicCreate(parameters: params)).responseJSON { (request, closureResponse, Result) -> Void in
                 btn.enabled = true
                if Result.isFailure {
                    
                    let alert = UIAlertView(title: "网络异常", message: "请检查网络设置", delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
                    return
                }
                
                let json = Result.value//.result.value
                
                
                
                var result = JSON(json!)
                
                if result["isSuc"].boolValue {
                    
                   self.navigationController?.popViewControllerAnimated(true)
                    
                    
                } else {
                    
                    let errMsg = result["msg"].stringValue
                    Utility.showMessage("发布失败!:\(errMsg)")
                }
            }
        }
        
    }
    private func setView() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: titleField.frame.size.height - width, width:  titleField.frame.size.width,height: width)

        border.borderWidth = width
        titleField.layer.addSublayer(border)
       titleField.layer.masksToBounds = true
        
        
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        
        
        let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let endKeyboardRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        
        
        
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
         
            
            for constraint in self.view.constraints {
                
              
                let cons = constraint as NSLayoutConstraint
                
                if let _ = cons.secondItem as? UITextView
                {
                    
                    if cons.secondAttribute == NSLayoutAttribute.Bottom {
                        
                        
                        cons.constant = 10 + endKeyboardRect.height
                        
                        
                        
                        break;
                    }
                    
                }
               
            }
          
            }, completion: nil)
    }

    func keyboardWillHide(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        
        
        let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
            
                for constraint in self.view.constraints {
                
                
                let cons = constraint as NSLayoutConstraint
                
                if let _ = cons.secondItem as? UITextView
                {
                    
                    if cons.secondAttribute == NSLayoutAttribute.Bottom {
                        
                        
                        cons.constant = 10
                        
                        
                        
                        break;
                    }
                    
                }
                
            }
        
            
            }, completion: nil)
        
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
