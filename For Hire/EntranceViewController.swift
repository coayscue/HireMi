//
//  EntranceViewController.swift
//  HireMi
//
//  Created by Christian Ayscue on 3/29/15.
//  Copyright (c) 2015 coayscue. All rights reserved.
//

import UIKit

class EntranceViewController: UIViewController {

    @IBOutlet weak var EmailField: UITextField!
    
    @IBAction func GoButtonClick(sender: AnyObject) {
        //check if email contains @scu.edu
        if EmailField.text.rangeOfString("@scu.edu") != nil{
            var personalInfo = ["Full Name": "", "Cell #": "", "Email": EmailField.text]
            NSUserDefaults.standardUserDefaults().setObject(personalInfo, forKey: "Contact Info")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "entered")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.resignFirstResponder()
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            UIView.animateWithDuration(0.1, delay: 0, options: nil, animations: { () -> Void in
                self.EmailField.center = CGPointMake(self.EmailField.center.x - 15, self.EmailField.center.y)
                }, completion: { (poop) -> Void in
                    UIView.animateWithDuration(0.1, delay: 0, options: nil, animations: { () -> Void in
                        self.EmailField.center = CGPointMake(self.EmailField.center.x + 30, self.EmailField.center.y)
                        }, completion: { (poop) -> Void in
                            UIView.animateWithDuration(0.1, animations: { () -> Void in
                                self.EmailField.center = CGPointMake(self.EmailField.center.x - 15, self.EmailField.center.y)
                            })
                    })
            })
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
