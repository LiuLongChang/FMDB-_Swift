//
//  MainTableViewController.swift
//  FMDB演示_Swift
//
//  Created by langyue on 15/11/27.
//  Copyright © 2015年 langyue. All rights reserved.
//

import UIKit

class MainTableViewController: BaseTableViewController,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating {

    
    
    enum RestorationKeys : String{
        case viewControllerTitle
        case searchControllerIsActive
        case searchBarText
        case searchBarIsFirstResponder
    }
    
    
    struct searchControllerRestorableState{
        var wasActive = false
        var wasFirstResponder = false
    }
    
    
    
    var dbPath : String!
    
    //var products = [Product]()
    
    var products : NSMutableArray!
    
    
    var searchController : UISearchController!
    var resultsTabController : ResultTableViewController!
    var restoredState = searchControllerRestorableState()
    
    
    
    var searchResultArray: NSMutableArray!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.view.backgroundColor = UIColor.magentaColor()
        
        
        self.products = NSMutableArray()
        self.searchResultArray = NSMutableArray()
        
        
        resultsTabController = ResultTableViewController()
        resultsTabController.tableView.delegate = self
        searchController = UISearchController(searchResultsController: resultsTabController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        
        definesPresentationContext = true
        
        
        let document = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray).objectAtIndex(0)
        let path = document.stringByAppendingPathComponent("user.sqlite")
        self.dbPath = path
        
        
        self.getAllDatabase()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.getAllDatabase()
        
    }
    
    
    func getAllDatabase(){

        products.removeAllObjects()
        
        let db = FMDatabase(path: self.dbPath as String)
        
        if(db.open()){
            
            let sql = "SELECT * FROM USER"
            let rs = db.executeQuery(sql, withArgumentsInArray: nil)
            
            while(rs.next()){
                
                let name = rs.stringForColumn("name")
                let score = rs.stringForColumn("score")
                let ID = rs.stringForColumn("idcode")
                let product = Product(name: name, score: score, ID: ID)
                self.products.addObject(product)
                
            }
            
            
           // self.searchResultArray.addObjectsFromArray(self.products as [AnyObject])
            
            db.close()
            
        }
        
        self.tableView.reloadData()
        
    }

    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if(restoredState.wasActive){
            
            searchController.active = restoredState.wasActive
            restoredState.wasActive = false
            
            if(restoredState.wasFirstResponder){
                searchController.searchBar.becomeFirstResponder()
                restoredState.wasFirstResponder = false
            }
            
        }
        
        
        
    }
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func presentSearchController(searchController: UISearchController) {
        
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let searchResults = products
        
        
        let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
        let strippedString = searchController.searchBar.text?.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
        let searchItems = (strippedString?.componentsSeparatedByString(" "))! as [String]
        
        
        
        let andMatchPredicates : [NSPredicate] = searchItems.map { searchString in
            
            
            var searchItemsPredicate = [NSPredicate]()
            
            let titleExpression = NSExpression(forKeyPath: "name")
            let searchStringExpression = NSExpression(forConstantValue: searchString)
            let titleSearchCompasisonPredicate = NSComparisonPredicate(leftExpression: titleExpression, rightExpression: searchStringExpression, modifier: .DirectPredicateModifier, type: .ContainsPredicateOperatorType, options: .CaseInsensitivePredicateOption)
            
            searchItemsPredicate.append(titleSearchCompasisonPredicate)
            
            let orMatchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
            return orMatchPredicate
            
        }
    
        let finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
        let filteredResults = searchResults.filter{ finalCompoundPredicate.evaluateWithObject($0) }  as! [Product]
        let resultsController = searchController.searchResultsController as! ResultTableViewController
        resultsController.filteredProducts = filteredResults
        resultsController.tableView.reloadData()
        
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
        return products.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(BaseTableViewController.tableViewCellIdentifier, forIndexPath: indexPath)
    
        
        let product = products[indexPath.row]
        configureCell(cell, forProduct: product as! Product)
        
        // Configure the cell...
        
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let selectedProduct: Product
        
        if(tableView === self.tableView){
            selectedProduct = products[indexPath.row] as! Product
        }else{
            selectedProduct = resultsTabController.filteredProducts[indexPath.row]
        }
        
        let detailInfo = BKDetailViewController()
        
        detailInfo.nameStr = selectedProduct.name
        detailInfo.scoreStr = selectedProduct.score
        detailInfo.IDsStr = selectedProduct.ID
        
        self.navigationController?.pushViewController(detailInfo, animated: true)
        
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
