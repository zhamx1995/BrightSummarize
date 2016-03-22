//
//  BookmarkDetailTableViewController.swift
//  BrightSummarize
//
//  Created by 查明轩 on 3/22/16.
//  Copyright © 2016 Mingxuan Zha. All rights reserved.
//

import UIKit
import CoreData

class BookmarkDetailTableViewController: UITableViewController {

	@IBOutlet weak var urlDetailTextField: UITextField!
	@IBOutlet weak var articleDetailTextField: UITextView!
	@IBOutlet weak var summaryDetailTextField: UITextView!
	
	var url:String = ""
	var article:String = ""
	var summary:String = ""
	var marks = [NSManagedObject]()
	var index = 0
	
	@IBAction func resaveBtn(sender: AnyObject) {
		let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		let cur = marks[index]
		cur.setValue(self.urlDetailTextField.text?.stringByTrimmingCharactersInSet(whitespaceSet), forKey: "urlSource")
		cur.setValue(self.articleDetailTextField.text?.stringByTrimmingCharactersInSet(whitespaceSet), forKey: "textSource")
		cur.setValue(self.summaryDetailTextField.text?.stringByTrimmingCharactersInSet(whitespaceSet), forKey: "summaryText")
		do {
			try managedContext.save()
		} catch let error as NSError  {
			print("Could not save \(error), \(error.userInfo)")
		}
		print("resaved")
		//set alert window
		let saveAlert = UIAlertController(title: "Bookmark updated", message: "", preferredStyle: UIAlertControllerStyle.Alert)
		saveAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction) in
			//empty, nothing to do
		}))
		presentViewController(saveAlert, animated: true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		view.addGestureRecognizer(tap)
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		self.urlDetailTextField.text = url
		self.articleDetailTextField.text = article
		self.summaryDetailTextField.text = summary
	}
	
	deinit {
		//stop monitoring keyboard
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	//Calls this function when the tap is recognized.
	@objc private func DismissKeyboard(){
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		view.endEditing(true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
