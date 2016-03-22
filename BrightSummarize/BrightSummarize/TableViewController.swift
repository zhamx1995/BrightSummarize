//
//  TableViewController.swift
//  BrightSummarize
//
//  Created by 查明轩 on 3/18/16.
//  Copyright © 2016 Mingxuan Zha. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class TableViewController: UITableViewController {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var articleTextField: UITextView!
	@IBOutlet weak var summaryTextField: UITextView!
	@IBOutlet weak var numberTextField: UITextField!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	var marks = [NSManagedObject]()
	
	func saveSummary(){
		let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
	    let entity =  NSEntityDescription.entityForName("Savedsummary", inManagedObjectContext:managedContext)
		let cur = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
		let date = NSDate();
		let datestr = self.dateToStr(date)
		cur.setValue(datestr, forKey: "dateAdded")
		cur.setValue(self.urlTextField.text?.stringByTrimmingCharactersInSet(whitespaceSet), forKey: "urlSource")
		cur.setValue(self.articleTextField.text?.stringByTrimmingCharactersInSet(whitespaceSet), forKey: "textSource")
		cur.setValue(self.numberTextField.text?.stringByTrimmingCharactersInSet(whitespaceSet), forKey: "sentenceNum")
		cur.setValue(self.summaryTextField.text?.stringByTrimmingCharactersInSet(whitespaceSet), forKey: "summaryText")
		do {
			try managedContext.save()
		} catch let error as NSError  {
			print("Could not save \(error), \(error.userInfo)")
		}
		marks.append(cur)
		print("mark saved")
	}
	
	func dateToStr(time: NSDate) ->String{
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "MMM dd, HH:mm"
		let strDate = dateFormatter.stringFromDate(time)
		return strDate
	}
	
	@IBAction func saveBtn(sender: AnyObject) {
		saveSummary()
	}
	
    @IBAction func clrBtn(sender: AnyObject) {
		//set alert window
		let clearAlert = UIAlertController(title: "Clear everything?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
		clearAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: { (action: UIAlertAction) in
			//empty, nothing to do
		}))
		clearAlert.addAction(UIAlertAction(title: "Clear", style: .Default, handler: { (action: UIAlertAction) in
			self.urlTextField.text = ""
			self.articleTextField.text = ""
			self.summaryTextField.text = ""
			self.numberTextField.text = ""
		}))
		presentViewController(clearAlert, animated: true, completion: nil)
    }
    
    @IBAction func sumBtn(sender: AnyObject) {
        let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
		if(self.numberTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) == ""){
			//require number of lines
			tableView.setContentOffset(CGPointMake(0,0), animated: true)
			self.numberTextField.becomeFirstResponder()
			//set alert window
			let inputAlert = UIAlertController(title: "Invalid input", message: "Please enter number of sentences", preferredStyle: UIAlertControllerStyle.Alert)
			inputAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction) in
				//empty, nothing to do
			}))
			presentViewController(inputAlert, animated: true, completion: nil)
		}
			
		else{
        if (self.urlTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) != "" &&
            self.articleTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) != ""){
                //invalid input alert
				let inputAlert = UIAlertController(title: "Please choose summary source", message: "", preferredStyle: UIAlertControllerStyle.Alert)
				inputAlert.addAction(UIAlertAction(title: "URL", style: .Default, handler: { (action: UIAlertAction) in
					//process with url
					self.summarizeURL()
				}))
				
				inputAlert.addAction(UIAlertAction(title: "Text", style: .Default, handler: { (action: UIAlertAction) in
					//process with text
					self.summarizeText()
				}))
				presentViewController(inputAlert, animated: true, completion: nil)
        }
			
        else if(self.urlTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) != ""){
            //process with url
			summarizeURL()
        }
        else if(self.articleTextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) != ""){
            //process with text
			summarizeText()
        }
        else{
			//no text source
			tableView.setContentOffset(CGPointMake(0,0), animated: true)
			self.urlTextField.becomeFirstResponder()
			//set alert window
			let inputAlert = UIAlertController(title: "Invalid input", message: "Please enter article URL or text", preferredStyle: UIAlertControllerStyle.Alert)
			inputAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction) in
				//empty, nothing to do
			}))
			presentViewController(inputAlert, animated: true, completion: nil)
        }
		}
    }
	
	func summarizeURL(){
		//indicate processing
		self.articleTextField.text = "N/A"
		self.activityIndicator.hidden = false
		self.activityIndicator.startAnimating()
		self.summaryTextField.text = "Loading..."
		//declare headers and request parameters
		let headers: [NSObject : AnyObject] = ["X-Mashape-Key": "eQI4VdekYKmshL4bDCymRiiaG0o2p18vYhojsnIkXyA7ZbRrhD", "Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json"]
		let parameters: [NSObject : AnyObject] = ["sentnum": self.numberTextField.text!, "url": self.urlTextField.text!]
		
		//send request under connected network
		if (Reachability.isConnectedToNetwork()){
		let _: UNIUrlConnection = UNIRest.post({(request) -> Void in
			request.url = "https://textanalysis-text-summarization.p.mashape.com/text-summarizer-url"
			request.headers = headers
			request.parameters = parameters
		}).asJsonAsync({(response, error) -> Void in
			let _: Int = response.code
			let _: [NSObject : AnyObject] = response.headers
			let _: UNIJsonNode = response.body
			let rawBody: NSData = response.rawBody
			NSOperationQueue.mainQueue().addOperationWithBlock {
//			print(rawBody)
			do{
				let result = try NSJSONSerialization.JSONObjectWithData(rawBody, options:[])
				let dataArray = result["sentences"] as! NSArray;
				var multilines = ""
				if(dataArray.count>0){
					for i in 1...dataArray.count{
						multilines = multilines+"\(i). "+(dataArray[i-1] as! String)
						if(i != dataArray.count){
							multilines = multilines+"\n"
						}
					}
				}
				else{
					multilines = "Sorry, no sentences found"
				}
				print(multilines)
				//data received, stop indicator, display summary
				self.activityIndicator.stopAnimating()
				self.activityIndicator.hidden = true
				self.summaryTextField.text = multilines
				//change label height according to summary
				self.setSummaryHeight()
				self.tableView.reloadData()
			} catch let error as NSError {
				print("json error: \(error.localizedDescription)")
			}
			}
		})
		}
		else{
			let connAlert = UIAlertController(title: "Please check network connection", message: "", preferredStyle: UIAlertControllerStyle.Alert)
			connAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction) in
				//empty, nothing to do
			}))
			self.presentViewController(connAlert, animated: true, completion: nil)
		}
	}
	
	func summarizeText(){
		//indicate processing
		self.urlTextField.text = "N/A"
		self.activityIndicator.hidden = false
		self.activityIndicator.startAnimating()
		self.summaryTextField.text = "Loading..."
		//declare headers and request parameters
		let headers: [NSObject : AnyObject] = ["X-Mashape-Key": "eQI4VdekYKmshL4bDCymRiiaG0o2p18vYhojsnIkXyA7ZbRrhD", "Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json"]
		let parameters: [NSObject : AnyObject] = ["sentnum": self.numberTextField.text!, "text": self.articleTextField.text!]
		
		//send request under connected network
		if (Reachability.isConnectedToNetwork()){
		let _: UNIUrlConnection = UNIRest.post({(request) -> Void in
			request.url = "https://textanalysis-text-summarization.p.mashape.com/text-summarizer-text"
			request.headers = headers
			request.parameters = parameters
		}).asJsonAsync({(response, error) -> Void in
			let _: Int = response.code
			let _: [NSObject : AnyObject] = response.headers
			let _: UNIJsonNode = response.body
			let rawBody: NSData = response.rawBody
			NSOperationQueue.mainQueue().addOperationWithBlock {
//			print(rawBody)
			do{
				let result = try NSJSONSerialization.JSONObjectWithData(rawBody, options:[])
				let dataArray = result["sentences"] as! NSArray;
				var multilines = ""
				if(dataArray.count>0){
					for i in 1...dataArray.count{
						multilines = multilines+"\(i). "+(dataArray[i-1] as! String)
						if(i != dataArray.count){
							multilines = multilines+"\n"
						}
					}
				}
				else{
					multilines = "Sorry, no sentences found"
				}
				print(multilines)
				//data received, stop indicator, display summary
				self.activityIndicator.stopAnimating()
				self.activityIndicator.hidden = true
				self.summaryTextField.text = multilines
				//change label height according to summary
				self.setSummaryHeight()
				self.tableView.reloadData()
			} catch let error as NSError {
				print("json error: \(error.localizedDescription)")
			}
			}
		})
		}
		else{
			let connAlert = UIAlertController(title: "Please check network connection", message: "", preferredStyle: UIAlertControllerStyle.Alert)
			connAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction) in
				//empty, nothing to do
			}))
			self.presentViewController(connAlert, animated: true, completion: nil)
		}

	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		self.activityIndicator.hidden = true
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		view.addGestureRecognizer(tap)
		self.activityIndicator.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		if(section == 3){
			return 2
		}
        return 1
    }

    var addHeight:CGFloat = 1.0
	func setSummaryHeight(){
		//default height = 58
		let newHeight = self.heightForView(self.summaryTextField.text!, tframe: self.summaryTextField.frame, font: self.summaryTextField.font!)
		//set added height if needed
		if(newHeight-58.0)>0
		{
			addHeight = newHeight-58.0
		}
		//animate size change
		tableView.beginUpdates()
		tableView.endUpdates()
	}
	
	func heightForView(text:String, tframe:CGRect, font:UIFont) -> CGFloat{
		let label:UILabel = UILabel(frame: tframe)
		label.numberOfLines = 0
		label.lineBreakMode = NSLineBreakMode.ByWordWrapping
		label.font = font
		label.text = text
		label.sizeToFit()
		return label.frame.height
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		if(indexPath.section == 3){
			if(indexPath.row == 0){
				return 32.0
			}
			return 119.0+addHeight
		}
		else if(indexPath.section == 1){
			return 107.0
		}
		else{
			return tableView.rowHeight
		}
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
