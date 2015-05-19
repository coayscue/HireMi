//
//  YourJobsTableViewController.swift
//  For Hire
//
//  Created by Christian Ayscue on 2/18/15.
//  Copyright (c) 2015 coayscue. All rights reserved.
//

import UIKit

var chosenJob: [String:AnyObject]? = nil
var index: Int? = nil
var yourJobsController: UITableViewController? = nil

class YourJobsTableViewController: UITableViewController {

    @IBAction func showSideMenu(sender: AnyObject) {
        self.revealViewController().revealToggle(self)
        //self.navigationController?.popViewControllerAnimated(true)
        //if there is no gesture recognizer for view click when slid out, add one
        if tapGestureAdded
        {
            self.view.removeGestureRecognizer(tapGesture)
            tapGestureAdded = false
        }else{
            self.view.addGestureRecognizer(tapGesture)
            tapGestureAdded = true
        }
    }
    
    var jobsToShow: [[String:AnyObject]]? = nil
    var goToAcceptedJobName = ""
    var tapGesture = UITapGestureRecognizer()
    var tapGestureAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.grayColor()
        tapGesture = UITapGestureRecognizer(target: self, action: "hideMenu")

        //set the appearance
        navigationController?.navigationBar.tintColor = UIColor.cyanColor()
        tableView.backgroundColor = UIColor.grayColor()


//        //allows a swipe gesture to show the side menu
//        var revealViewController = self.revealViewController
//        if ( revealViewController != nil )
//        {
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
        
        if jobsType! == "Your Listings"{
            jobsToShow = NSUserDefaults.standardUserDefaults().arrayForKey("Your Listings") as! [[String:AnyObject]]?
        }else{
            jobsToShow = NSUserDefaults.standardUserDefaults().arrayForKey("Accepted Jobs") as! [[String:AnyObject]]?
        }
        
        self.navigationItem.title = jobsType!
    }
    
    func hideMenu(){
        
        self.revealViewController().revealToggle(self)
        //if there is no gesture recognizer, add one
        self.view.removeGestureRecognizer(tapGesture)
        tapGestureAdded = false
    }
    
    override func viewWillAppear(animated: Bool) {
        if goToAcceptedJobName != ""{
            chosenJob = jobsToShow!.last
            index = jobsToShow!.count-1
            yourJobsController = self
            goToAcceptedJobName = ""
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
            var destinationVC = mainStoryboard.instantiateViewControllerWithIdentifier("yourjobs") as! YourJobsTableViewController
            self.navigationController?.pushViewController(destinationVC, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if jobsType! == "Your Listings"{
            jobsToShow = NSUserDefaults.standardUserDefaults().arrayForKey("Your Listings") as! [[String:AnyObject]]?
        }else{
            jobsToShow = NSUserDefaults.standardUserDefaults().arrayForKey("Accepted Jobs") as! [[String:AnyObject]]?
        }
        
        if jobsToShow != nil{
            return jobsToShow!.count
        }else{
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Job Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.backgroundColor = UIColor.grayColor()
        //if this is running, jobsToShow is known to exist, as! well as! a value at the given index path
        var job = jobsToShow![indexPath.row] as [String:AnyObject]
    
        //set the text label to the job name
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.text = job["Job_Name"] as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        chosenJob = jobsToShow![indexPath.row]
        index = indexPath.row
        yourJobsController = self
        self.performSegueWithIdentifier("Job Info", sender: self)
    }
    
}
