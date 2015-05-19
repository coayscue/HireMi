//
//  JobsTableViewController.swift
//  For Hire
//
//  Created by Christian Ayscue on 2/11/15.
//  Copyright (c) 2015 coayscue. All rights reserved.
//

import UIKit
import CoreLocation

var selectedJob: PFObject? = nil
var jobsArray: [PFObject] = []


class JobsTableViewController: UITableViewController, CLLocationManagerDelegate {

    var locManager = CLLocationManager()
    var refresher = UIRefreshControl()
    var loadingLocView = UIImageView()
    var userLocation = CLLocation()
    var spinner = UIActivityIndicatorView()
    var tapGesture = UITapGestureRecognizer()
    var tapGestureAdded = false
    
    @IBAction func showSideMenu(sender: AnyObject) {
        self.revealViewController().revealToggle(self)
        //if there is no gesture recognizer for view click when slid out, add one
            if tapGestureAdded
            {
                self.view.removeGestureRecognizer(tapGesture)
                tapGestureAdded = false
            }else{
                self.view.addGestureRecognizer(tapGesture)
                tapGestureAdded = true
            }
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGesture = UITapGestureRecognizer(target: self, action: "hideMenu")
        
        navigationController?.navigationBar.tintColor = UIColor.cyanColor()
        self.tableView.backgroundColor = UIColor.grayColor()
                
        //creates a refresher
        refresher.addTarget(self, action: "refreshData", forControlEvents:UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
        //get current location
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        if locManager.respondsToSelector("requestWhenInUseAuthorization") {
            locManager.requestWhenInUseAuthorization()
        }
        
        locManager.startUpdatingLocation()
        //scales in loadingWarning
        loadingLocView.frame = CGRectMake(self.view.frame.width/2, self.view.frame.height/2-35, 0, 0)
        self.navigationController?.navigationBar.addSubview(loadingLocView)

//        //allows a swipe gesture to show side menu
//        var revealViewController = self.revealViewController
//        if ( revealViewController != nil )
//        {
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//            
//        }
        
    }
    
    func hideMenu(){
        
        self.revealViewController().revealToggle(self)
        //if there is no gesture recognizer, add one
        self.view.removeGestureRecognizer(tapGesture)
        tapGestureAdded = false
    }
    
    func refreshData(){
        println("refreshing")
        if userLocation.coordinate.latitude != 0{
            //create a query of jobs within 2 miles of user's location
            var query = PFQuery(className: "Job")
            let curLocation = userLocation
            var geoPoint = PFGeoPoint(location: curLocation)
            query.whereKey("Location", nearGeoPoint: geoPoint, withinMiles: 2)
            query.whereKey("Active", containsString: "true")
            var error = NSError()
            query.findObjectsInBackgroundWithBlock { (jobs, error) -> Void in
                //for every job in the list of jobs returned,
                if jobs != nil && error == nil{
                    jobsArray = []
                    for job in jobs!{
                        jobsArray.append(job as! PFObject)
                    }
                }
                self.tableView.reloadData()
                if !self.refresher.refreshing{
                }else{
                    self.refresher.endRefreshing()
                }
            }
        }
    }
    
    //sets user's location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        userLocation = locations[0] as! CLLocation
        if userLocation.coordinate.latitude != 0{
            refreshData()
            
            manager.stopUpdatingLocation()
            spinner.stopAnimating()
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobsArray.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Job Cell", forIndexPath: indexPath) as! UITableViewCell
        var job = jobsArray[indexPath.row]
        cell.backgroundColor = UIColor.grayColor()
        
        //set the detail text label to hourly pay and number of hours
        
        var pay = job["Pay"] as! String
        //var hours = job["Hours"] as! String
//        if (job["Pay_Type"] as! String == "Hourly_Pay"){
//            cell.detailTextLabel?.text = " \(pay) per hour   -   \(hours) hours"
//        }else{
            cell.detailTextLabel?.text = "\(pay)"
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
//    }
        //set the text label to the job name
        cell.textLabel?.text = job["Job_Name"] as? String
        cell.textLabel?.frame.origin.y -= 20
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedJob = jobsArray[indexPath.row]
        self.performSegueWithIdentifier("showDetails", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails"{
            var viewController = segue.destinationViewController as! JobDetailsTableViewController
            viewController.userLocation = self.userLocation
        }
    }
    
//    override func viewDidAppear(animated: Bool) {
//        self.refresher.beginRefreshing()
//    }

}
