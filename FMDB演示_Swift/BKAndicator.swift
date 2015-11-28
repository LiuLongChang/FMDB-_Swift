//
//  BKNotices.swift
//  FMDB演示_Swift
//
//  Created by langyue on 15/11/25.
//  Copyright © 2015年 langyue. All rights reserved.
//

import UIKit


typealias MyInt = Int


let BKAndicatorStyleSuccess : MyInt = 0
let BKAndicatorStyleFail : MyInt = 1



class BKAndicator: UIView {
    
    var image:UIImageView!
    var message:UILabel!
    var dic:NSDictionary!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.dc_setupView()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func dc_setupView(){
        
        self.backgroundColor = UIColor(white: 0.3, alpha: 0.9)
        self.image = UIImageView()
        image?.frame = CGRectMake(34, 10, 32, 32);
        image?.image = UIImage(named: "success");
        self.addSubview(image)
        
        
        self.message = UILabel()
        message.frame = CGRectMake(10, 45, 80, 30)
        message.textAlignment = NSTextAlignment.Center
        message.textColor = UIColor.whiteColor()
        message.numberOfLines = 0;
        self.addSubview(message)
        
    }
    
    
    class func andicatorWithTitleTimeViewStyle(title:NSString,time:NSTimeInterval,view:UIView,style:MyInt)->Void{
        
        let notice : BKAndicator = BKAndicator(frame: CGRectMake(0,0,100,80));
        
        switch(style){
            case 0:
                notice.image.image = UIImage(named: "success")
                break
            
            case 1:
                notice.image.image = UIImage(named: "fail")
                break
           
            
            default:
                break
        }
        
        
        notice.center = CGPointMake(view.bounds.size.width / 2 , view.bounds.size.height / 2 - 100)
        notice.layer.masksToBounds = true
        notice.layer.cornerRadius = 15
        notice.dic = NSDictionary(object: notice, forKey: "dd")
        notice.message.text = title as String
        notice.message.font = UIFont.systemFontOfSize(12)
        notice.alpha = 0
        UIView.animateWithDuration(0.5) { () -> Void in
            
            notice.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height/2 - 100)
            view.addSubview(notice)
            notice.alpha = 0.7
            
        }
        
        
        
        NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "timeAction:", userInfo: notice.dic, repeats: false)
        
    }
    
    
    
    class func timeAction(sender:NSTimer)->Void{
        
        let notices : BKAndicator = (sender.userInfo?.valueForKey("dd"))! as! BKAndicator
        
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            notices.alpha = 0;
            
            }) { (finished) -> Void in
                
            notices.removeFromSuperview()
                
        }
        
    }
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
