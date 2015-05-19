//
//  SideMenuTableViewController.swift
//  For Hire
//
//  Created by Christian Ayscue on 2/18/15.
//  Copyright (c) 2015 coayscue. All rights reserved.
//

import UIKit

var jobsType: String? = nil

class SideMenuTableViewController: UITableViewController {
    
    var goToAcceptedJobName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController!.navigationBar.barTintColor = UIColor.greenColor()
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.backgroundColor = UIColor.grayColor()
    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        //sets up the next view controller to perform a segue
//        if segue.identifier == "Jobs1" && goToAcceptedJobName != ""{
//            var listVC = segue.destinationViewController as! YourJobsTableViewController
//            listVC.goToAcceptedJobName = goToAcceptedJobName
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.backgroundColor = UIColor.grayColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        switch indexPath.row{
        case 0:
            cell.imageView?.image = UIImage(named: "briefcase1.png")
            cell.textLabel?.text = "Available Jobs"
            break;
        case 1:
            cell.imageView?.image = UIImage(named: "plus1.png")
            cell.textLabel?.text = "List a Job"
            break;
        case 2:
            cell.imageView?.image = UIImage(named: "check1.png")
            cell.textLabel?.text = "Accepted Jobs"
            break;
        case 3:
            cell.imageView?.image = UIImage(named: "list1.png")
            cell.textLabel?.text = "Your Listings"
            break;
        case 4:
            cell.imageView?.image = UIImage(named: "phone1.png")
            cell.textLabel?.text = "Your Info"
            break;
        case 5:
            cell.imageView?.image = UIImage(named: "about1.png")
            cell.textLabel?.text = "About"
            break;
        default:
            break;
        }
        
        //makes the icons smaller
        var itemSize = CGSizeMake(30, 30)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.mainScreen().scale);
        var imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        cell.imageView?.image?.drawInRect(imageRect)
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //makes the seperatr go all the way
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0:
            //self.performSegueWithIdentifier("Home", sender: self)
            self.performSegueWithIdentifier("Home", sender: self)

            break;
        case 1:
            //self.performSegueWithIdentifier("New Listing", sender: self)
            self.performSegueWithIdentifier("New Listing", sender: self)

        case 2:
            jobsType = "Accepted Jobs"
            //self.performSegueWithIdentifier("Jobs", sender: self)
            self.performSegueWithIdentifier("Jobs", sender: self)

            break;
        case 3:
            jobsType = "Your Listings"
            //self.performSegueWithIdentifier("Jobs", sender: self)
            self.performSegueWithIdentifier("Jobs", sender: self)

            break;
        case 4:
            //self.performSegueWithIdentifier("Contact Info", sender: self)
            self.performSegueWithIdentifier("Contact Info", sender: self)

            break;
        case 5:
            //self.performSegueWithIdentifier("About", sender: self)
            self.performSegueWithIdentifier("About", sender: self)

            break
        default:
            break;
        }
    }
    
    

    
}
