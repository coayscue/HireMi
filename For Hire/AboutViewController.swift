//
//  AboutViewController.swift
//  For Hire
//
//  Created by Christian Ayscue on 2/19/15.
//  Copyright (c) 2015 coayscue. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    var tapGesture = UITapGestureRecognizer()
    var tapGestureAdded = false

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
    
    func hideMenu(){
        
        self.revealViewController().revealToggle(self)
        //if there is no gesture recognizer, add one
        self.view.removeGestureRecognizer(tapGesture)
        tapGestureAdded = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGesture = UITapGestureRecognizer(target: self, action: "hideMenu")

        //set appearance
        navigationController?.navigationBar.tintColor = UIColor.cyanColor()
        view.backgroundColor = UIColor.grayColor()

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

}
