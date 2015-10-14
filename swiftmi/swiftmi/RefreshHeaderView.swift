//
//  RefreshHeaderView.swift
//  RefreshExample
//
//  Created by SunSet on 14-6-24.
//  Copyright (c) 2014 zhaokaiyuan. All rights reserved.
//

import UIKit
class RefreshHeaderView: RefreshBaseView {
    class func footer()->RefreshHeaderView{
        let footer:RefreshHeaderView  = RefreshHeaderView(frame: CGRectMake(0, 0,   UIScreen.mainScreen().bounds.width,  CGFloat(RefreshViewHeight)))
        return footer
    }
    
    // 最后的更新时间
    var lastUpdateTime:NSDate = NSDate(){
    willSet{
        
    }
    didSet{
        NSUserDefaults.standardUserDefaults().setObject(lastUpdateTime, forKey: RefreshHeaderTimeKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        self.updateTimeLabel()
    }
    }
    
    // 最后的更新时间lable
    var lastUpdateTimeLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lastUpdateTimeLabel = UILabel()
        lastUpdateTimeLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        lastUpdateTimeLabel.font = UIFont.boldSystemFontOfSize(12)
        lastUpdateTimeLabel.textColor = RefreshLabelTextColor
        lastUpdateTimeLabel.backgroundColor = UIColor.clearColor()
        lastUpdateTimeLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(lastUpdateTimeLabel);
        
        if  (NSUserDefaults.standardUserDefaults().objectForKey(RefreshHeaderTimeKey) == nil)  {
            self.lastUpdateTime = NSDate()
        } else {
          self.lastUpdateTime = NSUserDefaults.standardUserDefaults().objectForKey(RefreshHeaderTimeKey) as! NSDate
        }
        self.updateTimeLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let statusX:CGFloat = 0
        let statusY:CGFloat = 0
        let statusHeight:CGFloat = self.frame.size.height * 0.5
        let statusWidth:CGFloat = self.frame.size.width
        //状态标签
        self.statusLabel.frame = CGRectMake(statusX, statusY, statusWidth, statusHeight)
        //时间标签
        let lastUpdateY:CGFloat = statusHeight
        let lastUpdateX:CGFloat = 0
        let lastUpdateHeight:CGFloat = statusHeight
        let lastUpdateWidth:CGFloat = statusWidth
        self.lastUpdateTimeLabel.frame = CGRectMake(lastUpdateX, lastUpdateY, lastUpdateWidth, lastUpdateHeight);
    }
    
    override func willMoveToSuperview(newSuperview: UIView!) {
        super.willMoveToSuperview(newSuperview)
         // 设置自己的位置和尺寸
        var rect:CGRect = self.frame
        rect.origin.y = -self.frame.size.height
        self.frame = rect
    }
    
    func updateTimeLabel(){
        //更新时间字符串
       ///let calendar:NSCalendar = NSCalendar.currentCalendar()
        
        
        //let unitFlags:NSCalendarUnit = [NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day, NSCalendarUnit.Hour,NSCalendarUnit.Minute]
        
       
       // let cmp1:NSDateComponents = calendar.components(unitFlags, fromDate:lastUpdateTime)
        //let cmp2:NSDateComponents = calendar.components(unitFlags, fromDate: NSDate())
        let formatter:NSDateFormatter = NSDateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let time:String = formatter.stringFromDate(self.lastUpdateTime)
        self.lastUpdateTimeLabel.text = "刷新时间:"+time
        
    }
    
    //监听UIScrollView的contentOffset属性
    override  func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        if (!self.userInteractionEnabled || self.hidden){
            return
        }
        if (self.State == RefreshState.Refreshing) {
            return
        }
        if RefreshContentOffset == keyPath {
            self.adjustStateWithContentOffset()
        }
    }
    
   
    
   
    
    //调整状态
    func adjustStateWithContentOffset()
    {
        let currentOffsetY:CGFloat = self.scrollView.contentOffset.y
        let happenOffsetY:CGFloat = -self.scrollViewOriginalInset.top
        if (currentOffsetY >= happenOffsetY) {
            return
        }
        if self.scrollView.dragging{
            let normal2pullingOffsetY:CGFloat = happenOffsetY - self.frame.size.height
            if  self.State == RefreshState.Normal && currentOffsetY < normal2pullingOffsetY{
                self.State = RefreshState.Pulling
            }else if self.State == RefreshState.Pulling && currentOffsetY >= normal2pullingOffsetY{
                self.State = RefreshState.Normal
            }
            
        } else if self.State == RefreshState.Pulling {
            self.State = RefreshState.Refreshing
        }
    }
    
    //设置状态
    override  var State:RefreshState {
    willSet {
        if  State == newValue{
            return;
        }
        oldState = State
        setState(newValue)
    }
    didSet{
        switch State{
        case .Normal:
            self.statusLabel.text = RefreshHeaderPullToRefresh
            if RefreshState.Refreshing == oldState {
                self.arrowImage.transform = CGAffineTransformIdentity
                self.lastUpdateTime = NSDate()
                UIView.animateWithDuration(RefreshSlowAnimationDuration, animations: {
                    var contentInset:UIEdgeInsets = self.scrollView.contentInset
                    contentInset.top = self.scrollViewOriginalInset.top
                    self.scrollView.contentInset = contentInset
                    })
                
            }else {
                UIView.animateWithDuration(RefreshSlowAnimationDuration, animations: {
                     self.arrowImage.transform = CGAffineTransformIdentity
                    })
            }
            break
        case .Pulling:
            self.statusLabel.text = RefreshHeaderReleaseToRefresh
            UIView.animateWithDuration(RefreshSlowAnimationDuration, animations: {
                 self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI ))
                })
            break
        case .Refreshing:
            self.statusLabel.text =  RefreshHeaderRefreshing;
            
            UIView.animateWithDuration(RefreshSlowAnimationDuration, animations: {
                let top:CGFloat = self.scrollViewOriginalInset.top + self.frame.size.height
                var inset:UIEdgeInsets = self.scrollView.contentInset
                inset.top = top
                self.scrollView.contentInset = inset
                var offset:CGPoint = self.scrollView.contentOffset
                offset.y = -top
                self.scrollView.contentOffset = offset
                })
            break
        default:
            break
            
        }
    }
    }
    
    func addState(state:RefreshState){
        self.State = state
    }
}
    