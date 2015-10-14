//
//  RegisterController.swift
//  swiftmi
//
//  Created by yangyin on 15/4/17.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


class RegisterController: UIViewController {

    
    @IBOutlet weak var username: UITextField!
   
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    
    @IBOutlet weak var btnReg: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "注册"
         self.password.secureTextEntry = true 
    }

    
    
    @IBAction func regClick(sender: AnyObject) {
        
        
        
        if username.text!.isEmpty {
            Utility.showMessage("用户名不能为空")
            return
        }
        if password.text!.isEmpty || (password.text! as NSString).length<6 {
            Utility.showMessage("密码不能为空且长度大于6位数")
            return
        }
        
        if email.text!.isEmpty {
            Utility.showMessage("email不能为空")
            return
        }
        
        
        let params:[String:AnyObject] = ["username":username.text!,"password":password.text!,"email":email.text!]
        
        self.btnReg.enabled  = false
        self.btnReg.setTitle("注册ing...", forState: UIControlState())
       
        self.pleaseWait()
        
        Alamofire.request(Router.UserRegister(parameters: params)).responseJSON { (request, closureResponse, Result) -> Void in
            self.btnReg.enabled  = true
            self.btnReg.setTitle("注册", forState: UIControlState.Normal)
            self.clearAllNotice()
            if Result.isFailure {
                let alert = UIAlertView(title: "网络异常", message: "请检查网络设置", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
                return
            }
            let json = Result.value;//.result.value
            var result = JSON(json!)
            if result["isSuc"].boolValue {
                var user = result["result"]
                let token = user["token"].stringValue
                KeychainWrapper.setString(token, forKey: "token")
                Router.token  = token
                
                let dalUser = UsersDal()
                
                dalUser.deleteAll()
                dalUser.addUser(user, save: true)
                if self.navigationController!.viewControllers.count>=3
                {
                    let toView = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count-3] as UIViewController;// 2
                    self.navigationController?.popToViewController(toView, animated: true)
                }
                else{
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
            } else {
                
                let errMsg = result["msg"].stringValue
                let alert = UIAlertView(title: "登录失败", message: "\(errMsg)", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
        }
//        Alamofire.request(Router.UserRegister(parameters: params)).responseJSON{
//            closureResponse in
//        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
