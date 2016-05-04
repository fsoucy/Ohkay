//
//  OptionsViewController.swift
//  Prototype
//
//  Created by Francis Soucy on 6/14/15.
//  Copyright (c) 2015 Soucy Development. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController
{
    
    
    @IBOutlet weak var font: UILabel!
    @IBOutlet weak var redVal: UISlider!
    @IBOutlet weak var blueVal: UISlider!
    @IBOutlet weak var greenVal: UISlider!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        redVal.value = (presentingViewController as! TextViewController).redV
        greenVal.value = (presentingViewController as! TextViewController).greenV
        blueVal.value = (presentingViewController as! TextViewController).blueV
        self.changeTextColor(nil)
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation
    {
        return UIInterfaceOrientation.Portrait
    }
    
    override func shouldAutorotate() -> Bool
    {
        return false
    }
    
    @IBAction func changeTextColor(sender: AnyObject?)
    {
        let red: CGFloat = CGFloat(redVal.value / 255.0)
        let blue: CGFloat = CGFloat(blueVal.value / 255.0)
        let green: CGFloat = CGFloat(greenVal.value / 255.0)
        let color: UIColor = UIColor(red: red, green: green, blue: blue, alpha: CGFloat(1.0))
        font.textColor = color
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
