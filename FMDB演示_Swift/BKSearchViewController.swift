//
//  BKSearchViewController.swift
//  FMDB演示_Swift
//
//  Created by langyue on 15/11/26.
//  Copyright © 2015年 langyue. All rights reserved.
//

import UIKit

class BKSearchViewController: UITableViewController,UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate {

    
    var dbPath : NSString!
    var searchResults : NSMutableArray!
    var searchAgeResult : NSMutableArray!
    var searchIDResult : NSMutableArray!
    var nameArray : NSMutableArray!
    var ageArray : NSMutableArray!
    var IDArray: NSMutableArray!
    var searchWasActive : Bool!
    var savedSearchTerm : NSString!
    
    var nameStr : NSString!
    var ageStr : NSString!
    var IDStr : NSString!
    
    var searchController : UISearchDisplayController!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        self.nameArray = NSMutableArray(capacity: 0)
        self.ageArray = NSMutableArray(capacity: 0)
        self.IDArray = NSMutableArray(capacity: 0)
        
        
        let f = 50 as CGFloat
        let search = UISearchBar(frame: CGRectMake(0, 0, self.view.bounds.size.width - f, 44))
        search.placeholder = "请输入姓名";
        search.autocorrectionType = UITextAutocorrectionType.No;//不自动纠错，貌似没啥用
        search.autocapitalizationType = UITextAutocapitalizationType.AllCharacters;//所有字母大写 ，也没啥用
        
        
        
        search.showsScopeBar = true;
        search.delegate = self;//UISearchBar设置代理
        search.keyboardType = UIKeyboardType.NamePhonePad;
        self.tableView.tableHeaderView = search;
        self.tableView.dataSource = self;
        
        
        
        
        
        
        
        searchController = UISearchDisplayController(searchBar: search, contentsController: self)
        searchController.active = false;
        searchController.delegate = self //UISearchDisplayController设置代理
        searchController.searchResultsDelegate=self;//还是代理
        searchController.searchResultsDataSource = self;//有完没完
        
        
        
        
        let document = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray).objectAtIndex(0)
        let path = document.stringByAppendingPathComponent("user.sqlite")
        self.dbPath = path
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.getAllDatabase()
        self.tableView.reloadData()
        
        
    }
    
    
    
    func getAllDatabase(){
        
        self.nameArray.removeAllObjects()
        self.ageArray.removeAllObjects()
        self.IDArray.removeAllObjects()
        
        
        let db = FMDatabase(path: self.dbPath as String)
        if(db.open()){
            
            let sql = "SELECT * FROM USER"
            let rs = db.executeQuery(sql, withArgumentsInArray: nil)
            
            while(rs.next()){
                
                let name = rs.stringForColumn("name")
                let age = rs.stringForColumn("age")
                let ID = rs.stringForColumn("idcode")
                
                self.nameArray.addObject(name)
                self.ageArray.addObject(age)
                self.IDArray.addObject(ID)
                
            }
            
            self.searchResults = NSMutableArray(array: nameArray as [AnyObject], copyItems: true)
            self.searchAgeResult = NSMutableArray(array: ageArray as [AnyObject], copyItems: true)
            self.searchIDResult = NSMutableArray(array: IDArray as [AnyObject], copyItems: true)
            
            db.close()
            
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
        var row = 0
        if(tableView.isEqual(self.searchDisplayController?.searchResultsTableView)){
            row = self.searchResults.count
        }else{
            self.nameArray.count
        }
        return row
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        
        
        
        let cellID : NSString = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID as String)
        if((cell == nil)){
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID as String)
            
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        if(tableView.isEqual(self.searchDisplayController?.searchResultsTableView)){
        
            cell?.textLabel?.text = searchResults.objectAtIndex(indexPath.row) as! String;
        
            
        }else{
        
            cell?.textLabel?.text = self.nameArray.objectAtIndex(indexPath.row) as! String
        
        }
        
        return cell!
    }
    
    override func   tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailInfo = BKDetailViewController()
        detailInfo.nameStr = self.searchResults.objectAtIndex(indexPath.row) as! NSString
        detailInfo.ageStr = self.searchAgeResult.objectAtIndex(indexPath.row) as! NSString
        detailInfo.IDsStr = self.searchIDResult.objectAtIndex(indexPath.row) as! NSString
        
        
        
        var array = self.navigationController?.viewControllers as! NSArray
        var nav = array.objectAtIndex(array.count-1) as! UIViewController
        nav.navigationController?.pushViewController(detailInfo, animated: true)
        
        
        
    }
    
    
    
    
    func filterContentForSearchTextAndScope(searchText:NSString,scope:NSString)->Void{
        self.searchBarSearchButtonClicked((self.searchDisplayController?.searchBar)!)
    }
    
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        var db = FMDatabase(path: self.dbPath as String)
        if(db.open()){
            
            
            searchResults.removeAllObjects()
            searchAgeResult.removeAllObjects()
            searchIDResult.removeAllObjects()
            
            let sql = "SELECT * FROM USER WHERE name like ?"
            var rs = db.executeQuery(sql, withArgumentsInArray: [searchBar.text!])
            while( rs.next() ){
                self.nameStr = rs.stringForColumn("name")
                self.ageStr = rs.stringForColumn("age")
                self.IDStr = rs.stringForColumn("idcode")
                
                self.searchResults.addObject(nameStr)
                self.searchAgeResult.addObject(ageStr)
                self.searchIDResult.addObject(IDStr)
                
            }
            
            
        }
        
        db.close()
        
    }
    
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        
//        let array = (self.searchDisplayController?.searchBar.scopeButtonTitles)! as NSArray
//        
//        let str = array.objectAtIndex((self.searchController?.searchBar.selectedScopeButtonIndex)!)
//        self.filterContentForSearchTextAndScope(searchString!, scope: str as! NSString )
        
        return true
        
    }
    
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        
//        self.filterContentForSearchTextAndScope((self.searchDisplayController?.searchBar.text)! as String, scope: ((self.searchDisplayController?.searchBar.scopeButtonTitles)! as NSArray).objectAtIndex(searchOption) as! NSString)
        
        return true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.getAllDatabase()
        self.tableView.reloadData()
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
