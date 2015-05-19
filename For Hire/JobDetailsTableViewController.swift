//
//  JobDetailsTableViewController.swift
//  For Hire
//
//  Created by Christian Ayscue on 2/11/15.
//  Copyright (c) 2015 coayscue. All rights reserved.
//

import UIKit
import MapKit

class JobDetailsTableViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var userLocation = CLLocation()
    var locManager = CLLocationManager()
    
    @IBAction func accept(sender: AnyObject) {
        //create storeable job object add the job to the "Accepted Jobs" array
        //convert location to a latitude and longitude strings
        
        var query = PFQuery(className: "Job")
        var error = NSError()
        query.getObjectInBackgroundWithId(selectedJob!.objectId as String, block: { (job, error) -> Void in
            if error == nil && job != nil{
                //marks the job as! inactive
                var cInfo = NSUserDefaults.standardUserDefaults().dictionaryForKey("Contact Info")
                job["Acceptor"] = cInfo!["Email"] as! String
                job["Active"] = "false"
                job.save()
            }
        })

        var newestJob: [String:AnyObject] = ["Job_Name":selectedJob!["Job_Name"],"Pay_Type":selectedJob!["Pay_Type"], "Pay":selectedJob!["Pay"],"Description":selectedJob!["Description"],"Full_Name":selectedJob!["Full_Name"],"Cell_Num":selectedJob!["Cell_Num"],"Email":selectedJob!["Email"],"Latitude":(selectedJob!["Location"] as! PFGeoPoint).latitude, "Longitude":(selectedJob!["Location"] as! PFGeoPoint).longitude]
        
        var acceptedJobs = NSUserDefaults.standardUserDefaults().arrayForKey("Accepted Jobs") as! [[String:AnyObject]]?
        if acceptedJobs != nil {
            acceptedJobs!.insert(newestJob, atIndex: 0)
        }else{
            acceptedJobs = [newestJob]
        }
        NSUserDefaults.standardUserDefaults().setObject(acceptedJobs, forKey: "Accepted Jobs")
        
        //starts a chain of segues to show the contact info for this job
//        var rootVC = navigationController?.viewControllers[0] as! SideMenuTableViewController
//        rootVC.goToAcceptedJobName = selectedJob!["Job_Name"] as! String
//        navigationController?.popToRootViewControllerAnimated(false)
        
        jobsType = "Accepted Jobs"
        chosenJob = newestJob
        //do a custom segue
        self.performSegueWithIdentifier("Accepted", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = selectedJob!["Job_Name"] as? String
        
        //gets rid of superfluous trailing cells
        tableView.tableFooterView = UIView(frame:CGRectZero)
        
        //set appearance
        tableView.backgroundColor = UIColor.grayColor()
        navigationController?.navigationBar.tintColor = UIColor.cyanColor()
        
//        //allows a swipe gesture to show the side menu
//        var revealViewController = self.revealViewController
//        if ( revealViewController != nil )
//        {
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //gets reuse identifier for cell
        var identifier: String
        switch indexPath.row{
        case 0:
            identifier = "Pay"
            break;
        case 1:
            identifier = "Description"
            break;
//        case 2:
//            identifier = "Distance"
//            break;
        case 2:
            identifier = "Map"
            break;
        default:
            identifier = ""
            break;
        }
        
        //gets prototype cell
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell

        //sets up cell
        cell.backgroundColor = UIColor.grayColor()
        switch identifier{
        case "Pay":
            var pay = selectedJob!["Pay"] as! String
//            if(selectedJob!["Pay_Type"] as! String == "Hourly Pay"){
//                cell.textLabel?.text = "\(pay) per hour"
//            }else{
                cell.textLabel?.text = "Pay: \(pay)"
                cell.textLabel?.textColor = UIColor.whiteColor()
//            }
            break
        case "Description":
            var description = selectedJob!["Description"] as! String
            var textView = (cell.viewWithTag(9) as! UITextView)
            textView.text = description
            (cell.viewWithTag(9) as! UITextView).font = UIFont(name: ".HelveticaNeueInterface-Regular", size: 18)
            textView.backgroundColor = UIColor.grayColor()
            textView.textColor = UIColor.whiteColor()
            break
        case "Distance":
            let jobPoint = selectedJob!["Location"] as! PFGeoPoint
            let ourloc = PFGeoPoint(location: userLocation)
            var distance = ourloc.distanceInMilesTo(jobPoint)
            cell.textLabel?.text = String(format: "Distance Away: %.2f miles", distance)
            cell.textLabel?.textColor = UIColor.whiteColor()
            break
        case "Map":
            //sets up map
            let map = cell.viewWithTag(10) as! MKMapView
            let jobPoint = selectedJob!["Location"] as! PFGeoPoint
            var latitude = jobPoint.latitude
            var longitude = jobPoint.longitude
            let jobCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
            var latDelta: CLLocationDegrees = 0.01
            var lonDelta: CLLocationDegrees = 0.01
            var coordSpan: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            var coordRegion: MKCoordinateRegion = MKCoordinateRegionMake(jobCoordinate, coordSpan)
            map.setRegion(coordRegion, animated: false)
            var jobLocAnnotation = MKPointAnnotation()
            jobLocAnnotation.coordinate = jobCoordinate
            map.addAnnotation(jobLocAnnotation)
            
            //sets up button
//            let mapButton = cell.viewWithTag(11) as! UIButton
//            mapButton.addTarget(self, action: "openMap", forControlEvents: UIControlEvents.TouchDown)
            
            map.showsUserLocation = true
            map.delegate = self
            //get current location
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.distanceFilter = 20
            if locManager.respondsToSelector("requestWhenInUseAuthorization") {
                locManager.requestWhenInUseAuthorization()
            }
            locManager.startUpdatingLocation()
            
        default:
            break
        }
        
        return cell
    }
    
    //opens the destination in maps app
    func openMap(){
        let jobPoint = selectedJob!["Location"] as! PFGeoPoint
        var latitude = jobPoint.latitude
        var longitude = jobPoint.longitude
        let jobCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        var place = MKPlacemark(coordinate: jobCoordinate, addressDictionary: nil)
        var destination = MKMapItem(placemark: place)
        var items = [destination]
        var options = NSDictionary(objectsAndKeys: MKLaunchOptionsDirectionsModeWalking, MKLaunchOptionsDirectionsModeKey)
        MKMapItem.openMapsWithItems(items, launchOptions: options as! [NSObject : AnyObject])
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 1 || indexPath.row == 2{
            return 150
        }
        return 60
    }

}
