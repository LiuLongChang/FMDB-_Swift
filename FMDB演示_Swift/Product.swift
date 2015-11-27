//
//  Product.swift
//  FMDB演示_Swift
//
//  Created by langyue on 15/11/27.
//  Copyright © 2015年 langyue. All rights reserved.
//

import UIKit

class Product: NSObject {
    
    
    let name  : String!
    let score : String!
    let ID : String!
    
    init(name:String,score:String,ID:String) {
        
        self.name = name
        self.score = score
        self.ID = ID
        
    }
    

}
