//
//  BKDetailViewController.swift
//  FMDB演示_Swift
//
//  Created by langyue on 15/11/26.
//  Copyright © 2015年 langyue. All rights reserved.
//

import UIKit

class BKDetailViewController: UIViewController {
    
    var dbPath : NSString!
    var nameStr : NSString!
    var scoreStr : NSString!
    var IDsStr : NSString!
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        
        self.title = "详细信息"
        let array = NSArray(objects: "姓名","分值","ID:")
        let array2 = NSArray(objects: self.nameStr,self.scoreStr,self.IDsStr)
        
        
        for index in 0...2{
            
            let label  = UILabel(frame: CGRectMake(70,CGFloat(index)*40+134,100,30))
            label.text = array.objectAtIndex(index) as? String
            self.view.addSubview(label)
            
            let label2 = UILabel(frame: CGRectMake(140,CGFloat(index)*40+135,100,30))
            label2.text = array2.objectAtIndex(index) as? String
            self.view.addSubview(label2)
            
        }
        
        
        let document = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray).objectAtIndex(0)
        let path = document.stringByAppendingPathComponent("USER.sqlite")
        self.dbPath = path
        
        let deleteButton = UIBarButtonItem(title: "删除", style: UIBarButtonItemStyle.Done, target: self, action: "deleteFromDatabase")
        self.navigationItem.rightBarButtonItem = deleteButton
        
        
        
        
    }

    
    func deleteFromDatabase(){
        
        
        let db = FMDatabase(path: self.dbPath as String)
        if(db.open()){
            
            let sql = "DELETE FROM USER WHERE name = ? and score = ? and idcode = ?"
            if(self.nameStr.length != 0 && self.scoreStr.length != 0 && self.IDsStr.length != 0){
            
                
                if( db.executeUpdate(sql, withArgumentsInArray: [self.nameStr,self.scoreStr,self.IDsStr]) ){
                    BKAndicator.andicatorWithTitleTimeViewStyle("删除成功", time: 1, view: self.view, style: BKAndicatorStyleSuccess)
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    BKAndicator.andicatorWithTitleTimeViewStyle("删除失败", time: 1, view: self.view, style: BKAndicatorStyleFail)
                }
                
                
                
                
            }
            
            
        }
        
        
        db.close()
        
        
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
