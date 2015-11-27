//
//  BKDataFromDataBase.swift
//  FMDB演示_Swift
//
//  Created by langyue on 15/11/25.
//  Copyright © 2015年 langyue. All rights reserved.
//

import UIKit



class BKDataFromDataBase: NSObject {
    
    
    var nameFromClass : NSString!
    var scoreFromClass : NSString!
    var IDFromClass : NSString!
    var nameArrayFromClass : NSMutableArray!
    
    
    
    
    class func shareInstance()->BKDataFromDataBase!{
        
        struct bkSingle{
            static var predicate: dispatch_once_t = 0
            static var instance: BKDataFromDataBase? = nil
        }
        
        dispatch_once(&bkSingle.predicate) { () -> Void in
            bkSingle.instance = BKDataFromDataBase()
        }
        
        return bkSingle.instance
        
        
    }
    
    
    override init() {
        
        nameFromClass = ""
        scoreFromClass = ""
        IDFromClass = ""
        nameArrayFromClass = NSMutableArray(capacity: 0)
        
    }
    
    
    
    
    
    

}
