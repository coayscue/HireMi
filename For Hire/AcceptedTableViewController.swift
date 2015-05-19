//
//  AcceptedTableViewController.swift
//  For Hire
//
//  Created by Christian Ayscue on 2/11/15.
//  Copyright (c) 2015 coayscue. All rights reserved.
//

import UIKit
import MessageUI

class AcceptedTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {

    @IBAction func done(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gets rid of superfluous trailing cells'
        navigationItem.backBarButtonItem?.enabled = false
        navigationItem.rightBarButtonItem?.enabled = false
        //navigationItem.backBarButtonItem?.tintColor = UIColor.clearColor()
        tableView.tableFooterView = UIView(frame:CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        //sets up cell
        switch identifier{
        case "Full Name":
            var fullName = selectedJob!["Full_Name"] as! String
            cell.textLabel?.text = fullName
            break;
        case "Cell #":
            var cellNum = selectedJob!["Cell_Num"] as! String
            cell.textLabel?.text = cellNum
            break;
        case "Email":
            var email = selectedJob!["Email"] as! String
            cell.textLabel?.text = email
            break;
        default:
            break;
        }
        
        return cell
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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

    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
}
