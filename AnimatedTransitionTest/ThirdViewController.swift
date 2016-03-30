//
//  ThirdViewController.swift
//  AnimatedTransitionTest
//

import UIKit

class ThirdViewController: UITableViewController {
    
    var tableData = ["item1", "item2", "item3", "item4"];
    let tableCellId = "cell_Id"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(tableCellId, forIndexPath: indexPath)
        
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel?.text = self.tableData[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("dismissMe3", sender: nil)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let itemCount = tableData.count - 1
        let color = (CGFloat(indexPath.row) / CGFloat(itemCount)) * 0.6
        cell.backgroundColor =  UIColor(red: 1.0, green: color, blue: 0.0, alpha: 1.0)
    }
    
}
