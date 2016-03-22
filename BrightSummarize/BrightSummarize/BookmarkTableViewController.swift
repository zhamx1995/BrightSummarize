//
//  BookmarkTableViewController.swift
//  BrightSummarize
//
//  Created by 查明轩 on 3/21/16.
//  Copyright © 2016 Mingxuan Zha. All rights reserved.
//

import UIKit
import CoreData

class BookmarkTableViewController: UITableViewController {

	var marks = [NSManagedObject]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: "Savedsummary")
		do {
			let results = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
			if let curResult = results{
				marks = curResult
			}
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		self.tableView.reloadData()
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
        return marks.count
    }

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell:BookmarkTableViewCell! = tableView.dequeueReusableCellWithIdentifier("markCell", forIndexPath: indexPath) as! BookmarkTableViewCell
		let curObject = marks[marks.count-1-indexPath.row]
		let curSum = curObject.valueForKey("summaryText") as! String
		cell.sumText.text = curSum
		let curDate = curObject.valueForKey("dateAdded") as! String
		cell.dateLabel.text = curDate
        return cell
    }
	

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

	//slide to delete
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == UITableViewCellEditingStyle.Delete {
			let deleteAlert = UIAlertController(title: "Delete this bookmark?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
			//remove delete button
			deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
				//empty, nothing to do
			}))
			//delete cell and reply
			deleteAlert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (action: UIAlertAction) in
				// remove the deleted item from the model
				let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
				let managedContext = appDelegate.managedObjectContext
				managedContext.deleteObject(self.marks[self.marks.count-1-indexPath.row] as NSManagedObject)
				self.marks.removeAtIndex(self.marks.count-1-indexPath.row)
				do {
					try managedContext.save()
				} catch _ {
				}
				// remove the deleted item from the `UITableView`
				self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			}))
			presentViewController(deleteAlert, animated: true, completion: nil)
		}
	}

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

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "toDetail"{
			let indexPath = tableView.indexPathForSelectedRow;
			let bookmarkDetailTableViewController = segue.destinationViewController as! BookmarkDetailTableViewController
			let curMark = marks[marks.count-1-indexPath!.row]
			bookmarkDetailTableViewController.url = curMark.valueForKey("urlSource") as! String
			bookmarkDetailTableViewController.article = curMark.valueForKey("textSource") as! String
			bookmarkDetailTableViewController.summary = curMark.valueForKey("summaryText") as! String
			bookmarkDetailTableViewController.marks = self.marks
			bookmarkDetailTableViewController.index = marks.count-1-indexPath!.row
		}
    }


}
