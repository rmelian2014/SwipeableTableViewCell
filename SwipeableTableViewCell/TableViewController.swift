//
//  TableViewController.swift
//  SwipeableTableViewCell
//
//  Created by Błażej Wdowikowski on 01/06/2016.
//  Copyright © 2016 47 Center, Inc. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    
    let labels:[String] = ["Pippi Longstocking", "Austin Powers", "Spider-Man", "James Bond",
                           "Lisbeth Salander", "Donald Duck", "Luke Skywalker", "Lara Croft",
                           "Frodo Baggins", "Hermione Granger", "Dexter Morgan", "Ted Mosby",
                           "Homer Simpson", "John Connor", "Arya Stark", "Captain Kirk"]
    let blue:UIColor = UIColor(red: 0.23, green: 0.34, blue: 0.58, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private
    
    private func tickle() {
        let alert = UIAlertController(title: "Tee-hee", message: "Stop it!", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Okay 😀", style: .Default,handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: UIScrollVieDelegate
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        SwipeableTableViewCell.closeAllCells()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIndentifier = "randomCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath) as! SwipeableTableViewCell
        
        let tickleAction = SwipeRowAction(title: "Tickle", image: nil, backgroundColor: blue, width: 100) { _ in
            self.tickle()
        }
        
        let moreAction = SwipeRowAction(title: "More", image: nil, backgroundColor: UIColor.lightGrayColor(), width: 80) { _ in
            print("More button tapped")
        }
        
        let deleteAction = SwipeRowAction(title: nil, image: UIImage(named: "trash"), backgroundColor: UIColor.redColor(), width: 80) { _ in
            print("Delete button tapped")
        }
        
        cell.leftActions = [tickleAction]
        cell.rightActions = [moreAction,deleteAction]
        cell.textLabel?.text = labels[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected \(indexPath.row)")
    }
 

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}
