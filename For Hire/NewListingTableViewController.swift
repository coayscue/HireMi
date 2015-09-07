//
//  NewListingTableViewController.swift
//  For Hire
//
//  Created by Christian Ayscue on 2/11/15.
//  Copyright (c) 2015 coayscue. All rights reserved.
//

import UIKit
import MapKit

class NewListingTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate{
    
    //helper variables
    var payType = String()
    var selection = UISegmentedControl()
    var payTextField = UITextField()
    var payLabel = UILabel()
    var payNums = 0
    var payValue = 0
    var locManager = CLLocationManager()
    
    var jobField = UITextField()
    var descriptionField = UITextView()
    var nameField = UITextField()
    var cellField = UITextField()
    var emailField = UITextField()
    var userLocationButton = UIButton()
    var map = MKMapView()
    
    var tapGesture = UITapGestureRecognizer()
    var tapGestureAdded = false
    
    
    //shows the side menu
    @IBAction func showSideMenu(sender: AnyObject) {
        self.revealViewController().revealToggle(self)
        //self.navigationController?.popViewControllerAnimated(true)
        //if there is no gesture recognizer for view click when slid out, add one
        self.view.endEditing(true)
        
        if tapGestureAdded{
            self.view.removeGestureRecognizer(tapGesture)
            payTextField.removeGestureRecognizer(tapGesture)
            jobField.removeGestureRecognizer(tapGesture)
            descriptionField.removeGestureRecognizer(tapGesture)
            nameField.removeGestureRecognizer(tapGesture)
            cellField.removeGestureRecognizer(tapGesture)
            emailField.removeGestureRecognizer(tapGesture)
            tapGestureAdded = false
        }else{
            self.view.addGestureRecognizer(tapGesture)
            payTextField.addGestureRecognizer(tapGesture)
            jobField.addGestureRecognizer(tapGesture)
            descriptionField.addGestureRecognizer(tapGesture)
            nameField.addGestureRecognizer(tapGesture)
            cellField.addGestureRecognizer(tapGesture)
            emailField.addGestureRecognizer(tapGesture)
            tapGestureAdded = true
        }
    }
    
    //create the listing
    @IBAction func createListing(sender: AnyObject) {
        
        self.resignFirstResponder()
        
        //saving indication
        var grayView = UIView(frame: self.view.frame)
        grayView.tintColor = UIColor.grayColor()
        grayView.alpha = 0
        var activityIndicator = UIActivityIndicatorView(frame: CGRectMake(self.view.frame.width/2, self.view.frame.height/2, 0, 0))
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            grayView.alpha = 0.4
            activityIndicator.frame = CGRectMake(self.view.frame.width/2-50, self.view.frame.height/2-50, 100, 100)
        })
        
        //fills data fields for job object
        var jobName = jobField.text
        var pay: String = payLabel.text!
        pay = pay.substringFromIndex(advance(pay.startIndex,5))
        //var hours = hoursField.text
        var description = descriptionField.text
        var fullName = nameField.text
        var cellNum = cellField.text
        var email = emailField.text
        var geoLoc = PFGeoPoint(latitude: map.centerCoordinate.latitude, longitude: map.centerCoordinate.longitude)
        //check to make sure all fields are filled, and the location is good
        println(jobName+pay+description+fullName+cellNum+email)
        if (jobName == "" || pay == "$0.00" || description == "" || description == "Description (eg. Deliver bronco burger from tailgaters to Swig 714)" || fullName == "" || cellNum == ""){
            var alert = UIAlertController(title: "Incomplete form", message: "Not all fields are completed.", preferredStyle: UIAlertControllerStyle.Alert)
            var okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }else if map.userLocation.coordinate.latitude == 0{
            var alert = UIAlertController(title: "Location not loaded", message: "Wait for location to load.", preferredStyle: UIAlertControllerStyle.Alert)
            var okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
//        }else if payType == "Hourly Pay" && payTextField.text.toInt() < 10{
//            var alert = UIAlertController(title: "Pay More", message: "Minimum hourly pay is $10 per hour.", preferredStyle: UIAlertControllerStyle.Alert)
//            var okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
//                alert.dismissViewControllerAnimated(true, completion: nil)
//            })
//            alert.addAction(okAction)
//            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            //saves the contactInfo for the furure
            var personalInfo = ["Full Name": fullName, "Cell #": cellNum, "Email": email]
            NSUserDefaults.standardUserDefaults().setObject(personalInfo, forKey: "Contact Info")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            //creates job object
            var job = PFObject(className: "Job")
            //saves job object
            var error = NSError()
            job.saveInBackgroundWithBlock { (success, error) -> Void in
                if success && error == nil{
                    
                    //set attributes of the object
                    job["Job_Name"] = jobName
                    job["Pay_Type"] = "Flat Rate"
                    job["Pay"] = pay
                    //job["Hours"] = hours
                    job["Description"] = description
                    job["Full_Name"] = fullName
                    job["Cell_Num"] = cellNum
                    job["Email"] = email
                    job["Location"] = geoLoc
                    job["Active"] = "true"
                    
                    //save in the background
                    job.saveInBackgroundWithBlock({ (bop, jank) -> Void in
                        //refresh the table
                        if var jobsTable = self.navigationController?.viewControllers[0] as? JobsTableViewController {
                            jobsTable.refreshData()
                        }
                    })
                    
                    //create a dictionary with these values and add the object to the "Your Listings" array
                    var newListing: [String:AnyObject] = ["Job_Name":jobName,"Pay_Type": self.payType,"Pay":pay,"Description":description,"Full_Name":fullName,"Cell_Num":cellNum,"Email":email,"Latitude":geoLoc.latitude, "Longitude":geoLoc.longitude, "ParseID":job.objectId]
                    
                    var yourListings = NSUserDefaults.standardUserDefaults().arrayForKey("Your Listings") as! [[String:AnyObject]]?
                    if yourListings != nil {
                        yourListings?.append(newListing)
                    }else{
                        yourListings = [newListing]
                    }
                    NSUserDefaults.standardUserDefaults().setObject(yourListings, forKey: "Your Listings")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                }else{
                    println(error)
                }
            }
            
            //ends saving
            UIView.animateWithDuration(NSTimeInterval(0.3), animations: { () -> Void in
                grayView.alpha = 0
                activityIndicator.frame = CGRectMake(self.view.frame.width/2, self.view.frame.height/2, 0, 0)
            })
            if var jobsTable = navigationController?.viewControllers[0] as? JobsTableViewController{
                jobsTable.refreshData()
                navigationController?.popViewControllerAnimated(true)
            }else{
                self.performSegueWithIdentifier("BackToJobs", sender: self)
            }
        }
    }
    
    func hideMenu(){
        
        self.revealViewController().revealToggle(self)
        //if there is no gesture recognizer, add one
        self.view.removeGestureRecognizer(tapGesture)
        payTextField.removeGestureRecognizer(tapGesture)
        jobField.removeGestureRecognizer(tapGesture)
        descriptionField.removeGestureRecognizer(tapGesture)
        nameField.removeGestureRecognizer(tapGesture)
        cellField.removeGestureRecognizer(tapGesture)
        emailField.removeGestureRecognizer(tapGesture)
        tapGestureAdded = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGesture = UITapGestureRecognizer(target: self, action: "hideMenu")
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.showsVerticalScrollIndicator = false
        
        //set appearance
        navigationController?.navigationBar.tintColor = UIColor.cyanColor()
        self.tableView.backgroundColor = UIColor.grayColor()
        
        //makes sure fields are filled in
        var personalInfo = NSUserDefaults.standardUserDefaults().dictionaryForKey("Contact Info")
        if var name = personalInfo?["Full Name"] as? String{
            nameField.text = name
        }else{
            nameField.text = ""
        }
        if var num = personalInfo?["Cell #"] as? String{
            cellField.text = num
        }
        if var email = personalInfo?["Email"] as? String{
            emailField.text = email
        }else{
            emailField.text = ""
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if map.region.span.latitudeDelta > 0.02 && map.userLocation.coordinate.latitude != 0 {
            println("zooming")
            locManager.distanceFilter = 20
            //set map centered on current location
            var latitude = map.userLocation.coordinate.latitude
            var longitude = map.userLocation.coordinate.longitude
            var latDelta: CLLocationDegrees = 0.005
            var lonDelta: CLLocationDegrees = 0.005
            var coordSpan: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            var coordRegion: MKCoordinateRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(latitude, longitude), coordSpan)
            map.setRegion(coordRegion, animated: false)
        }
    }
    
//    //makes the custon user location image
//    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        var userAnnotationView = MKAnnotationView()
//        userAnnotationView.annotation = annotation
//        userAnnotationView.image = UIImage(named: "user_loc.png")
//        userAnnotationView.frame.size = CGSizeMake(25, 25)
//        return userAnnotationView
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return ""
        }else{
            return ""
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 4
        }else{
            return 3
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 2 || indexPath.row == 3) && indexPath.section == 0{
            return 150
        }
//        if indexPath.row == 1 && indexPath.section == 0{
//            return 90
//        }
        return 60
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UITableViewHeaderFooterView(frame: CGRectMake(0,0, tableView.bounds.size.width, 30))
        var titleView = UILabel(frame: CGRectMake(15,-4, tableView.bounds.size.width, 30))
        if section == 0{
            titleView.text = "Info"
        }else{
            titleView.text = "Contact"
        }
        titleView.font = UIFont(name: ".HelveticaNeueInterface-Bold", size: 16)
        titleView.textColor = UIColor.whiteColor()
        //titleView.textAlignment = NSTextAlignment.Center
        headerView.addSubview(titleView)
        return headerView
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //gets reuse identifier for cell
        var identifier: String
        if indexPath.section == 0{
            switch indexPath.row{
            case 0:
                identifier = "Job Name"
                break;
            case 1:
                identifier = "Pay"
                break;
            case 2:
                identifier = "Description"
                break;
            case 3:
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
//        set the personal info to whatever is stored, to save the user time
        var personalInfo = NSUserDefaults.standardUserDefaults().dictionaryForKey("Contact Info")
        cell.backgroundColor = UIColor.grayColor()
        switch identifier{
        case "Job Name":
            jobField = cell.viewWithTag(1) as! UITextField
            jobField.textColor = UIColor.whiteColor()
            jobField.attributedPlaceholder = NSAttributedString(string: "Job Title", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            break
        case "Pay":
            //set up cell
            //segmented control
//            selection = cell.viewWithTag(21)! as! UISegmentedControl
//            selection.selectedSegmentIndex = 0
            payType = "Flat Rate"
//            selection.addTarget(self, action: "selectionChanged", forControlEvents: UIControlEvents.ValueChanged)
            //textField
            payTextField = cell.viewWithTag(22)! as! UITextField
            payTextField.tintColor = UIColor.clearColor()
            payTextField.delegate = self
            payLabel = cell.viewWithTag(23)! as! UILabel
            if payLabel.text == "Pay: $0.00"{
                payLabel.textColor = UIColor.lightGrayColor()
            }
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "updatePayTextField", name: UITextFieldTextDidChangeNotification, object: payTextField)
            break
//        case "Hours":
//            hoursField = cell.viewWithTag(3) as! UITextField
//            break;
        case "Description":
            descriptionField = cell.viewWithTag(4) as! UITextView
            descriptionField.delegate = self
            descriptionField.backgroundColor = UIColor.grayColor()
            break
        case "Map":
            userLocationButton = cell.viewWithTag(11) as! UIButton
            userLocationButton.addTarget(self, action: "currLocClicked", forControlEvents: UIControlEvents.TouchDown)
            userLocationButton.contentHorizontalAlignment = .Right
            map = cell.viewWithTag(10) as! MKMapView
            map.showsUserLocation = true
            map.delegate = self
            //set the map
            var latitude = map.userLocation.coordinate.latitude
            var longitude = map.userLocation.coordinate.longitude
            var latDelta: CLLocationDegrees = 0.005
            var lonDelta: CLLocationDegrees = 0.005
            var coordSpan: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            var coordRegion: MKCoordinateRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.348505, -121.939037), coordSpan)
            map.setRegion(coordRegion, animated: false)
            //get current location
            locManager.delegate = self
            if locManager.respondsToSelector("requestWhenInUseAuthorization") {
                locManager.requestWhenInUseAuthorization()
            }
            locManager.startUpdatingLocation()
            //scales in loadingWarning
            //            loadingLocView.frame = CGRectMake(self.view.frame.width/2, self.view.frame.height/2-35, 0, 0)
            //            self.navigationController?.navigationBar.addSubview(loadingLocView)
            //            UIView.animateWithDuration(0.6, animations: { () -> Void in
            //                var frame = CGRectMake(self.view.frame.width/2-70, self.view.frame.height/2-90, 140, 140)
            //                self.loadingLocView.frame = frame
            //            })
            var pinUpdater = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "tryPinSet:", userInfo: nil, repeats: true)
            break;
        case "Full Name":
            nameField = cell.viewWithTag(5) as! UITextField
            if nameField.text == ""{
                if var name = personalInfo?["Full Name"] as? String{
                    nameField.text = name
                }else{
                    nameField.text = ""
                }
            }
            nameField.textColor = UIColor.whiteColor()
            nameField.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            break
        case "Cell #":
            cellField = cell.viewWithTag(6) as! UITextField
            if cellField.text == ""{
                if var num = personalInfo?["Cell #"] as? String{
                    cellField.text = num
                }
            }
            cellField.textColor = UIColor.whiteColor()
            cellField.attributedPlaceholder = NSAttributedString(string: "Cell", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            break
        case "Email":
            emailField = cell.viewWithTag(7) as! UITextField
            if emailField.text == ""{
                if var email = personalInfo?["Email"] as? String{
                    emailField.text = email
                }else{
                    emailField.text = ""
                }
            }
            emailField.textColor = UIColor.whiteColor()
            emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            break
        default:
            break
        }
        return cell
    }
    
    func tryPinSet(timer: NSTimer){
        if map.region.span.latitudeDelta > 0.02 && map.userLocation.coordinate.latitude != 0 {
            println("zooming")
            //set map centered on current location
            var latitude = map.userLocation.coordinate.latitude
            var longitude = map.userLocation.coordinate.longitude
            var latDelta: CLLocationDegrees = 0.005
            var lonDelta: CLLocationDegrees = 0.005
            var coordSpan: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            var coordRegion: MKCoordinateRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(latitude, longitude), coordSpan)
            map.setRegion(coordRegion, animated: true)
            timer.invalidate()
            println("got it")
        }
    }
    
    //scrolls to the users location
    func currLocClicked(){
        //if point is valid
        if map.userLocation?.location?.coordinate.latitude != nil {
            var latitude = map.userLocation.coordinate.latitude
            var longitude = map.userLocation.coordinate.longitude
            var latDelta: CLLocationDegrees = 0.005
            var lonDelta: CLLocationDegrees = 0.005
            var coordSpan: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            var coordRegion: MKCoordinateRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(latitude, longitude), coordSpan)
            map.setRegion(coordRegion, animated: true)
        }
    }
    

//    func selectionChanged(){
//        if (selection.selectedSegmentIndex == 0){
//            payType = "Per Hour"
//        }else{
//            payType = "Flat Rate"
//        }
//        //maes textfield accurately represent the pay type
//        updatePayTextField()
//    }
    
    
    //textfield delegate functions
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.isEqual(payTextField)
        {
            payLabel.textColor = UIColor.whiteColor()
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.isEqual(payTextField){
            if payLabel.text == "Pay: $0.00"{
                payLabel.textColor = UIColor.lightGrayColor()
            }
        }
    }
    
    //textview delegate functions
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor != UIColor.whiteColor(){
            textView.text = ""
            textView.textColor = UIColor.whiteColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == ""{
            textView.text == "Description (please be specific)"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func updatePayTextField(){
        //fixes last digit removal bug
        if payTextField.text == ""{
            payLabel.text = "Pay: $0.00"
//            if payType == "Per Hour"{
//                payLabel.text! += " per hour"
//            }else{
//                payLabel.text! += " total"
//            }
        }
        if var payInt = payTextField.text.toInt(){
            //$1000 max
            if payInt < 1000{
                payLabel.text = "Pay: $\(payInt).00"
                if payInt < 5{
                    payLabel.text = "Pay: $\(payInt)0.00"
                }
                //add ending
//                if payType == "Per Hour"{
//                    payLabel.text! += " per hour"
//                }else{
//                    payLabel.text! += " total"
//                }
            }else{
                //if number is too long, delete back
                payTextField.deleteBackward()
            }
        }
    }
    
}
