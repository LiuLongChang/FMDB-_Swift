//
//  BKAddUserViewController.swift
//  FMDB演示_Swift
//
//  Created by langyue on 15/11/26.
//  Copyright © 2015年 langyue. All rights reserved.
//

import UIKit

class BKAddUserViewController: UIViewController,UITextFieldDelegate {

    
    
    var textFieldArray : NSMutableArray!
    var dbPath : NSString!
    var nameTextField : UITextField!
    var ageTextField : UITextField!
    var IDTextField : UITextField!
    var operateType : NSInteger!
    
    var operateType1: NSInteger!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        operateType = 0
        operateType1 = 0
        
        
        
        
        self.view.backgroundColor = UIColor.whiteColor();
        let doc = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray).objectAtIndex(0)
        let path = doc.stringByAppendingPathComponent("user.sqlite")
        self.dbPath = path
        
        let array = NSArray(objects: "姓名","年龄","ID")
        
        
        for(var index : Int = 0;index < array.count; index++){
            
            
            let label = UILabel(frame: CGRectMake(70, CGFloat(index) * 40 + 134,100,30))
            label.text = array.objectAtIndex(index) as? String
            self.view.addSubview(label)
            
        }
        
        
        
        nameTextField = UITextField(frame: CGRectMake(150,138,100,30))
        nameTextField.borderStyle = UITextBorderStyle.RoundedRect
        nameTextField.placeholder = "请输入姓名"
        nameTextField.delegate = self
        self.view.addSubview(nameTextField)
        
        
        ageTextField = UITextField(frame: CGRectMake(150,178,100,30))
        ageTextField.borderStyle = UITextBorderStyle.RoundedRect
        ageTextField.placeholder = "请输入年龄"
        ageTextField.delegate = self
        self.view.addSubview(ageTextField)
        
        
        
        IDTextField = UITextField(frame: CGRectMake(150,218,100,30))
        IDTextField.borderStyle = UITextBorderStyle.RoundedRect
        IDTextField.placeholder = "请输入ID"
        IDTextField.delegate = self
        self.view.addSubview(IDTextField)
        
        
        if(operateType == 1){
            nameTextField.text = BKDataFromDataBase.shareInstance().nameFromClass as NSString as String
            IDTextField.text = BKDataFromDataBase.shareInstance().IDFromClass as NSString as String
            ageTextField.text = BKDataFromDataBase.shareInstance().ageFromClass as NSString as String
            IDTextField.enabled = false
        }
        
        
        
        if(operateType == 0){
            
            let addBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addNewUserInfo")
            self.navigationItem.rightBarButtonItem = addBtn;
            
        }
        
        
        
        if(operateType == 1){
            
            let addBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "addNewUserInfo")
            self.navigationItem.rightBarButtonItem = addBtn;
            
        }
        
        
        
        
    }
    
    
    
    func addNewUserInfo(){
        
        let db = FMDatabase(path: self.dbPath as String)
        if(db.open()){
            
            if((nameTextField.text! as NSString).length == 0 || (ageTextField.text! as NSString).length == 0 || (IDTextField.text! as NSString).length == 0){
                
                BKNotices.noticeWithTitleTimeViewStyle("请完成填写信息", time: 1.5, view: self.view, style: BKNoticeStyleFail)
                
            }else{
             
                
                
                
                print("姓名：%@,年龄：%@,ID:%@",nameTextField.text,ageTextField.text,IDTextField.text)
                var sql : String = ""
                if(self.operateType == 0){
                    sql = "INSERT INTO USER (name,age,idcode) VALUES (?,?,?)"
                }else if(self.operateType == 1){
                    sql = "UPDATE USER SET name = ?,age = ? where idcode = ?"
                }
                
                let res = db.executeUpdate(sql, withArgumentsInArray: [nameTextField.text!,ageTextField.text!,IDTextField.text!]) as Bool
                
                
                if(!res){
                    
                    BKNotices.noticeWithTitleTimeViewStyle("数据插入错误", time: 1.5, view: self.view, style: BKNoticeStyleFail)
                    
                }else{
                    
                    BKNotices.noticeWithTitleTimeViewStyle("数据插入成功", time: 1.5, view: self.view, style: BKNoticeStyleSuccess)
                    
                }
                
            }
            
        }else{
            print("数据库打开失败")
        }
        
        
        
        if(operateType1 == 0){
            
            nameTextField.resignFirstResponder()
            ageTextField.resignFirstResponder()
            IDTextField.resignFirstResponder()
            nameTextField.text = ""
            ageTextField.text = ""
            IDTextField.text = ""
            self.navigationController?.popViewControllerAnimated(true)
            
        }
        
        
        
        
        
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        nameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        IDTextField.resignFirstResponder()
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        nameTextField.text = ""
        ageTextField.text = ""
        IDTextField.text = ""
        
        
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
