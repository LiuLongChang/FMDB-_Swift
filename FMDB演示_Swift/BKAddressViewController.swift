//
//  BKAddressViewController.swift
//  FMDB演示_Swift
//
//  Created by langyue on 15/11/25.
//  Copyright © 2015年 langyue. All rights reserved.
//

import UIKit

class BKAddressViewController: UITableViewController {

    
    
    var paths : NSString!
    
    var dataArray : NSMutableArray!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.view.backgroundColor = UIColor.cyanColor()
        self.tableView.registerClass(BKAddressViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Redo, target: self, action: "modifyDatabase")
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        let document = paths.objectAtIndex(0)
        let path = document.stringByAppendingPathComponent("USER.sqlite")
        self.paths = path
        
        
        self.dataArray = NSMutableArray()
        
        self.createTable()
        self.getAllDatabase()
        
    }
    
    
    
    func createTable(){
        
        let fileManager = NSFileManager.defaultManager()
        if(!fileManager.fileExistsAtPath(self.paths as String)){
            
            print("表不存在，创建表")
            let db = FMDatabase(path: self.paths as String)
            if(db.open()){
                
                let sql = "CREATE TABLE 'USER'('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'name' VARCHAR(20),'score' VARCHAR(20),'idcode' VARCHAR(30))"
                let success =  db.executeUpdate(sql, withParameterDictionary: nil) as Bool
                
                if(!success){
                    print("error when create table")
                }else{
                    print("create table succeed")
                }
                
                db.close()
                
                
                
            }else{
                print("database open error")
            }
            
            
            
        }
        
        
    }
    
    
    func getAllDatabase(){
        
        
        let db = FMDatabase(path: self.paths as String)
        if(db.open()){
            
            let sql = "SELECT * FROM USER"
            let rs = db.executeQuery(sql, withParameterDictionary: nil)
            while(rs.next()){
                
                
                var product : Product
                
                let name = rs.stringForColumn("name")
                let score = rs.stringForColumn("score")
                let ID = rs.stringForColumn("idcode")
                
                product = Product(name: name, score: score, ID: ID)
                self.dataArray.addObject(product)
               
            }
            
            BKDataFromDataBase.shareInstance().nameArrayFromClass.arrayByAddingObjectsFromArray(self.dataArray as [AnyObject] )
            
            db.close()
            self.tableView.reloadData()
            
        }
        
        
        
        
    }
    
    
    
    
    
    func modifyDatabase(){
        let indexPath = self.tableView.indexPathForSelectedRow
        if(indexPath == nil){
            
            BKAndicator.andicatorWithTitleTimeViewStyle("Data Refreshed", time: 1.5, view: self.view, style: BKAndicatorStyleSuccess)
            return
            
        }else{
            //
            
            let addUser : BKAddUserViewController = BKAddUserViewController()
            addUser.operateType = 1
            
            BKDataFromDataBase.shareInstance().nameFromClass = (self.dataArray.objectAtIndex((indexPath?.row)!-1) as! Product).name
            BKDataFromDataBase.shareInstance().IDFromClass = (self.dataArray.objectAtIndex((indexPath?.row)!-1) as! Product).ID
            BKDataFromDataBase.shareInstance().scoreFromClass = (self.dataArray.objectAtIndex((indexPath?.row)!-1) as! Product).score
            self.navigationController?.pushViewController(addUser, animated: true)
            
        }
        
    }
    
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataArray.count + 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! BKAddressViewCell
        
        
        
        
        
        if(indexPath.row == 0){
            cell.nameLabel.text = "姓名/昵称"
            cell.scoreLabel.text = "分值"
            cell.ID.text = "队员ID号"
        }else{
            
            cell.nameLabel.text = (self.dataArray.objectAtIndex(indexPath.row-1) as? Product)?.name
            cell.scoreLabel.text = (self.dataArray.objectAtIndex(indexPath.row-1) as? Product)?.score
            cell.ID.text = (self.dataArray.objectAtIndex(indexPath.row-1) as? Product)?.ID
            
        }
        
        // Configure the cell...

        return cell
    }
    

    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if(indexPath.row == 0){
            return nil
        }else{
            return indexPath
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
