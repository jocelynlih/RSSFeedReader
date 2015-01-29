//
//  DetailViewController.swift
//  rssfeedreader
//
//  Created by Jocelyn Harrington on 1/28/15.
//  Copyright (c) 2015 cleanmicro. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController, MWFeedParserDelegate {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    var rssURL: NSString!
    var items = [MWFeedItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //add the refresh control 
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "fetchRequest", forControlEvents: .ValueChanged)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fetchRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchRequest() {
        let URL = NSURL(string: self.rssURL)
        let rssParser = MWFeedParser(feedURL: URL)
        rssParser.delegate = self
        rssParser.parse()
    }
    
    func feedParserDidStart(parser: MWFeedParser) {
        spinner.startAnimating()
    }
    
    func feedParserDidFinish(parser: MWFeedParser) {
        self.refreshControl?.endRefreshing()
        spinner.stopAnimating()
        self.tableView.reloadData()
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
        self.title = info.title
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        self.items.append(item)
    }

    func feedParser(parser: MWFeedParser, didFailWithError error: NSError) {
        self.title = "Error"
        self.refreshControl?.endRefreshing()
        spinner.stopAnimating()
        let errorView = UIAlertView()
        errorView.title = "Oops"
        errorView.message = error.description
        errorView.addButtonWithTitle("OK")
        errorView.show()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DCell", forIndexPath: indexPath) as UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let item = self.items[indexPath.row] as MWFeedItem
        let titleLabel = cell.viewWithTag(11) as UILabel
        titleLabel.text = item.title
        
        let detailLabel = cell.viewWithTag(12) as UILabel
        detailLabel.text = item.summary
        
        let projectURL = item.link.componentsSeparatedByString("?")[0]
        let processImgURL = (string: projectURL + "/cover_image?style=200x200#")
        if item.imageURL == nil {
            item.imageURL = processImgURL
        }
        let imgURL: NSURL? = NSURL(string: item.imageURL)
        if imgURL != nil {
            let thumbnailImg = cell.viewWithTag(10) as UIImageView
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                let imageData = NSData(contentsOfURL:imgURL!)
                dispatch_async(dispatch_get_main_queue(), {
                    if (imageData?.length != nil) {
                        thumbnailImg.image = UIImage(data:imageData!);
                    }
                });
            })
        }
    }

}

