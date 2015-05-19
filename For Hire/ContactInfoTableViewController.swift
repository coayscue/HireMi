//
//  ContactInfoTableViewController.swift
//  For Hire
//
//  Created by Christian Ayscue on 2/18/15.
//  Copyright (c) 2015 coayscue. All rights reserved.
//

import UIKit

class ContactInfoTableViewController: UITableViewController {
    
    var tapGesture = UITapGestureRecognizer()
    var tapGestureAdded = false
    var nameField = UITextField()
    var cellField = UITextField()
    var emailField = UITextField()

    @IBAction func showSideMenu(sender: AnyObject) {
        self.revealViewController().revealToggle(self)
        //self.navigationController?.popViewControllerAnimated(true)
        self.view.endEditing(true)
        //if there is no gesture recognizer for view click when slid out, add one
        if tapGestureAdded
        {
            self.view.removeGestureRecognizer(tapGesture)
            nameField.removeGestureRecognizer(tapGesture)
            cellField.removeGestureRecognizer(tapGesture)
            emailField.removeGestureRecognizer(tapGesture)
            tapGestureAdded = false
        }else{
            self.view.addGestureRecognizer(tapGesture)
            nameField.removeGestureRecognizer(tapGesture)
            cellField.removeGestureRecognizer(tapGesture)
            emailField.removeGestureRecognizer(tapGesture)
            tapGestureAdded = true
        }
    }
    
    @IBAction func save(sender: AnyObject) {
        var personalInfo = ["Full Name": nameField.text, "Cell #": cellField.text, "Email": emailField.text]
        NSUserDefaults.standardUserDefaults().setObject(personalInfo, forKey: "Contact Info")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func hideMenu(){
        
        self.revealViewController().revealToggle(self)
        //if there is no gesture recognizer, add one
        self.view.removeGestureRecognizer(tapGesture)
        nameField.removeGestureRecognizer(tapGesture)
        cellField.removeGestureRecognizer(tapGesture)
        emailField.removeGestureRecognizer(tapGesture)
        tapGestureAdded = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGesture = UITapGestureRecognizer(target: self, action: "hideMenu")
        
//        //allows a swipe gesture to show the side menu
//        var revealViewController = self.revealViewController
//        if ( revealViewController != nil )
//        {
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
        
        //set appearance
        navigationController?.navigationBar.tintColor = UIColor.cyanColor()
        self.tableView.backgroundColor = UIColor.grayColor()
        
        //deletes unecessary cells 
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

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
        
        //gets prototype cell
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell
        
        cell.backgroundColor = UIColor.grayColor()
        
        var contactInfo = NSUserDefaults.standardUserDefaults().dictionaryForKey("Contact Info")
        
        if (contactInfo != nil){
            
            //sets up cell
            switch identifier{
            case "Full Name":
                var fullName = contactInfo!["Full Name"] as! String
                println(fullName)
                nameField = (cell.viewWithTag(3) as! UITextField)
                nameField.text = fullName
                nameField.textColor = UIColor.whiteColor()
                break;
            case "Cell #":
                var cellNum = contactInfo!["Cell #"] as! String
                cellField = (cell.viewWithTag(4) as! UITextField)
                cellField.text = cellNum
                cellField.textColor = UIColor.whiteColor()
                break;
            case "Email":
                var email = contactInfo!["Email"] as! String
                emailField = (cell.viewWithTag(5) as! UITextField)
                emailField.text = email
                emailField.textColor = UIColor.whiteColor()
                
                break;
            default:
                break;
            }
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
