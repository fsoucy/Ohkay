//
//  HowToViewController.swift
//  Prototype
//
//  Created by Francis Soucy on 6/23/15.
//  Copyright (c) 2015 Soucy Development. All rights reserved.
//

import UIKit

class HowToViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation
    {
        return UIInterfaceOrientation.Portrait
    }
    
    override func shouldAutorotate() -> Bool
    {
        return false
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "FirstUse")
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
