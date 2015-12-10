//
//  MasterViewController.swift
//  rssfeedreader
//
//  Created by Jocelyn Harrington on 1/28/15.
//  Copyright (c) 2015 cleanmicro. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UITextFieldDelegate {

    var objects : NSArray = ["CNNWorld", "CNN", "CNNMoney", "BBC", "PCWorld"]
    var urls : NSMutableArray = ["http://rss.cnn.com/rss/cnn_world.rss", "http://rss.cnn.com/rss/cnn_topstories.rss", "http://rss.cnn.com/rss/money_latest.rss", "http://newsrss.bbc.co.uk/rss/newsonline_world_edition/americas/rss.xml", "feed://www.pcworld.com/index.rss"]
    var customInput : NSString = "http://rss.cnn.com/rss/cnn_topstories.rss"
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "RSS Feed Reader"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let section = indexPath.section
                if section == 0 {
                    (segue.destinationViewController as! DetailViewController).rssURL = urls[indexPath.row] as! NSString
                } else {
                    (segue.destinationViewController as! DetailViewController).rssURL = customInput
                }
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let section = indexPath.section
        if section == 0 {
            let object = objects[indexPath.row] as! NSString
            cell.textLabel!.text = object as String
        } else {
            cell.textLabel!.text = ""
            let textField = UITextField(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: cell.contentView.frame.height))
            textField.textAlignment = .Center
            textField.text = "https://rss.cnn.com/rss/cnn_topstories.rss"
            textField.delegate = self
            cell.contentView.addSubview(textField)
        }
        
        return cell
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }

    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text!.isEmpty {
            let errorView = UIAlertView()
            errorView.title = "Oops"
            errorView.message = "Please enter your RSS Feed. "
            errorView.addButtonWithTitle("OK")
            errorView.show()
            return false
        }
        self.customInput = textField.text!
        return true
    }
}

