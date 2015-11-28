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
    var scoreTextField : UITextField!
    var IDTextField : UITextField!
    var operateType : NSInteger!
    
    var operateType1: NSInteger!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        operateType = 0
        operateType1 = 0
        
        
        
        
        self.view.backgroundColor = UIColor(white: 0.5, alpha:0.5);
        let doc = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray).objectAtIndex(0)
        let path = doc.stringByAppendingPathComponent("user.sqlite")
        self.dbPath = path
        
        let array = NSArray(objects: "昵称/姓名","分值","队员ID")
        
        
        for(var index : Int = 0;index < array.count; index++){
            
            
            let label = UILabel(frame: CGRectMake(70, CGFloat(index) * 40 + 134,100,30))
            label.text = array.objectAtIndex(index) as? String
            self.view.addSubview(label)
            
        }
        
        
        
        nameTextField = UITextField(frame: CGRectMake(150,138,150,30))
        nameTextField.borderStyle = UITextBorderStyle.RoundedRect
        nameTextField.placeholder = "请输入姓名/昵称"
        nameTextField.delegate = self
        self.view.addSubview(nameTextField)
        
        
        scoreTextField = UITextField(frame: CGRectMake(150,178,150,30))
        scoreTextField.borderStyle = UITextBorderStyle.RoundedRect
        scoreTextField.placeholder = "请输入分值"
        scoreTextField.delegate = self
        self.view.addSubview(scoreTextField)
        
        
        
        IDTextField = UITextField(frame: CGRectMake(150,218,150,30))
        IDTextField.borderStyle = UITextBorderStyle.RoundedRect
        IDTextField.placeholder = "请输入队员ID"
        IDTextField.delegate = self
        self.view.addSubview(IDTextField)
        
        
        if(operateType == 1){
            nameTextField.text = BKDataFromDataBase.shareInstance().nameFromClass as NSString as String
            IDTextField.text = BKDataFromDataBase.shareInstance().IDFromClass as NSString as String
            scoreTextField.text = BKDataFromDataBase.shareInstance().scoreFromClass as NSString as String
            IDTextField.enabled = false
        }
        
        
        
        if(operateType == 0){
            
            let addBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "addNewUserInfo")
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
            
            if((nameTextField.text! as NSString).length == 0 || (scoreTextField.text! as NSString).length == 0 || (IDTextField.text! as NSString).length == 0){
                
                BKAndicator.andicatorWithTitleTimeViewStyle("请完成填写信息", time: 1.5, view: self.view, style: BKAndicatorStyleFail)
                
            }else{
             
                
                
                
                print("姓名：%@,年龄：%@,ID:%@",nameTextField.text,scoreTextField.text,IDTextField.text)
                var sql : String = ""
                if(self.operateType == 0){
                    sql = "INSERT INTO USER (name,score,idcode) VALUES (?,?,?)"
                }else if(self.operateType == 1){
                    sql = "UPDATE USER SET name = ?,score = ? where idcode = ?"
                }
                
                let res = db.executeUpdate(sql, withArgumentsInArray: [nameTextField.text!,scoreTextField.text!,IDTextField.text!]) as Bool
                
                
                if(!res){
                    
                    BKAndicator.andicatorWithTitleTimeViewStyle("数据插入错误", time: 1.5, view: self.view, style: BKAndicatorStyleFail)
                    
                }else{
                    
                    BKAndicator.andicatorWithTitleTimeViewStyle("数据插入成功", time: 1.5, view: self.view, style: BKAndicatorStyleSuccess)
                    
                }
                
            }
            
        }else{
            print("数据库打开失败")
        }
        
        
        
        if(operateType1 == 0){
            
            nameTextField.resignFirstResponder()
            scoreTextField.resignFirstResponder()
            IDTextField.resignFirstResponder()
            nameTextField.text = ""
            scoreTextField.text = ""
            IDTextField.text = ""
            self.navigationController?.popViewControllerAnimated(true)
            
        }
        
        
        
        
        
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        nameTextField.resignFirstResponder()
        scoreTextField.resignFirstResponder()
        IDTextField.resignFirstResponder()
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        nameTextField.text = ""
        scoreTextField.text = ""
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
