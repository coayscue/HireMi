//
//  MyJobTableViewController.swift
//  For Hire
//
//  Created by Christian Ayscue on 2/19/15.
//  Copyright (c) 2015 coayscue. All rights reserved.
//

import UIKit
import MapKit
import MessageUI

class MyJobTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var userLocation = CLLocation()
    var map = MKMapView()
    var locManager = CLLocationManager()
    var tapGesture = UITapGestureRecognizer()
    var tapGestureAdded = false

    @IBAction func menuButtonClicked(sender: AnyObject) {
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
    }
    
    func hideMenu(){
        
        self.revealViewController().revealToggle(self)
        //if there is no gesture recognizer, add one
        self.view.removeGestureRecognizer(tapGesture)
        tapGestureAdded = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGesture = UITapGestureRecognizer(target: self, action: "hideMenu")

        //set trashcan if necessary
        if jobsType == "Your Listings"{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "removeListing")
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.cyanColor()
        }
        
        //set appearance
        navigationController?.navigationBar.tintColor = UIColor.cyanColor()
        tableView.backgroundColor = UIColor.grayColor()
        navigationItem.title = chosenJob!["Job_Name"] as? String
    }
    
    func removeListing(){
        //remove the object from the cloud
        var query = PFQuery(className: "Job")
        var error = NSError()
        query.getObjectInBackgroundWithId(chosenJob!["ParseID"] as! String, block: { (job, error) -> Void in
            if error == nil && job != nil{
                //marks the job inactive
                job["Active"] = "false"
                job.save()
            }
        })
        //deletes the object from the array
        var yourListings = NSUserDefaults.standardUserDefaults().arrayForKey("Your Listings")
        yourListings?.removeAtIndex(index!)
        NSUserDefaults.standardUserDefaults().setObject(yourListings, forKey: "Your Listings")
        NSUserDefaults.standardUserDefaults().synchronize()
        //refreshes the previous table before poping back to it
        yourJobsController!.loadView()
        self.navigationController?.popViewControllerAnimated(true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else{
            return 3
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return ""
        }else{
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 1 || indexPath.row == 2) && indexPath.section == 1{
            return 150
        }
        return 60
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //gets reuse identifier for cell
        var identifier: String
        if indexPath.section == 1{
            switch indexPath.row{
            case 0:
                identifier = "Pay"
                break;
            case 1:
                identifier = "Description"
                break;
            case 2:
                identifier = "Map"
                break;
            default:
                identifier = ""
                break;
            }
        }else{
            switch indexPath.row{
            case 0:
                identifier = "Full Name"
                break;
            case 1:
                identifier = "Cell #"
                break;
            case 2:
                identifier = "Email"
                break;
            default:
                identifier = ""
                break;
            }
        }
        
        //gets cell
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell
        
        //sets up cell
        cell.backgroundColor = UIColor.grayColor()
        
        switch identifier{
        case "Pay":
            var pay = chosenJob!["Pay"] as! String
            cell.textLabel?.text = "Pay: \(pay)"
            cell.textLabel?.textColor = UIColor.whiteColor()
            break
        case "Description":
            var description = chosenJob!["Description"] as! String
            var field = (cell.viewWithTag(9) as! UITextView)
            field.text = description
            field.font = UIFont(name: ".HelveticaNeueInterface-Regular", size: 18)
            field.backgroundColor = UIColor.grayColor()
            field.textColor = UIColor.whiteColor()
            break
        case "Map":
            //sets up map
            map = cell.viewWithTag(10) as! MKMapView
            
            //add the anotation for the location of the job and set map
            var latitude = chosenJob!["Latitude"] as! Double
            var longitude = chosenJob!["Longitude"] as! Double
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
            let mapButton = cell.viewWithTag(11) as! UIButton
            mapButton.addTarget(self, action: "openMap", forControlEvents: UIControlEvents.TouchDown)
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
            
            break
        case "Full Name":
            var fullName = chosenJob!["Full_Name"] as! String
            cell.textLabel?.text = fullName
            cell.textLabel?.textColor = UIColor.whiteColor()
            break
        case "Cell #":
            var cellNum = chosenJob!["Cell_Num"] as! String
            cell.textLabel?.text = cellNum
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.tintColor = UIColor.cyanColor()
            break
        case "Email":
            var email = chosenJob!["Email"] as! String
            cell.textLabel?.text = email
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.tintColor = UIColor.cyanColor()
            break
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0{
            
            if indexPath.row == 1{
                //sets up a text message to the job poster
                if MFMessageComposeViewController.canSendText(){
                    var picker = MFMessageComposeViewController()
                    picker.messageComposeDelegate = self
                    picker.recipients = [selectedJob!["Cell_Num"] as! String] //recipient
                    self.presentViewController(picker, animated: true, completion: nil)
                }
            }else if indexPath.row == 2{
                
                //sets up an email to the job poster
                if MFMailComposeViewController.canSendMail(){
                    var picker = MFMailComposeViewController()
                    var jobName = selectedJob!["Job_Name"] as! String
                    picker.setSubject("\(jobName) Job") //subject
                    var fullName = selectedJob!["Full_Name"] as! String
                    picker.setMessageBody("Hi \(fullName),", isHTML: false) //message body
                    picker.mailComposeDelegate = self
                    picker.setToRecipients([selectedJob!["Email"] as! String]) //recipient
                    
                    self.presentViewController(picker, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UITableViewHeaderFooterView(frame: CGRectMake(0,0, tableView.bounds.size.width, 30))
        var titleView = UILabel(frame: CGRectMake(15,-4, tableView.bounds.size.width, 30))
        if section == 0{
            titleView.text = "Contact"
        }else{
            titleView.text = "Job Info"
        }
        titleView.font = UIFont(name: ".HelveticaNeueInterface-Bold", size: 16)
        titleView.textColor = UIColor.whiteColor()
        //titleView.textAlignment = NSTextAlignment.Center
        headerView.addSubview(titleView)
        return headerView
    }

    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    

    //opens the destination in maps app
    func openMap(){
        var latitude = chosenJob!["Latitude"] as! Double
        var longitude = chosenJob!["Longitude"] as! Double
        let jobCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        var place = MKPlacemark(coordinate: jobCoordinate, addressDictionary: nil)
        var destination = MKMapItem(placemark: place)
        var items = [destination]
        var options = NSDictionary(objectsAndKeys: MKLaunchOptionsDirectionsModeWalking, MKLaunchOptionsDirectionsModeKey)
        MKMapItem.openMapsWithItems(items, launchOptions: options as [NSObject : AnyObject])
    }

}
