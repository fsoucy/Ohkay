//
//  SettingsViewController.swift
//  Prototype
//
//  Created by Francis Soucy on 6/14/15.
//  Copyright (c) 2015 Soucy Development. All rights reserved.
//

import UIKit

import UIKit


class SettingsViewController: UIViewController {
    
    @IBOutlet weak var sliderBrush: UISlider!
    
    @IBOutlet weak var imageViewBrush: UIImageView!
    
    
    @IBOutlet weak var sliderRed: UISlider!
    @IBOutlet weak var sliderGreen: UISlider!
    @IBOutlet weak var sliderBlue: UISlider!
    
    var brush: CGFloat = 10.0
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation
    {
        return UIInterfaceOrientation.Portrait
    }
    
    override func shouldAutorotate() -> Bool
    {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func colorChanged(sender: UISlider?) {
        red = CGFloat(sliderRed.value / 255.0)
        green = CGFloat(sliderGreen.value / 255.0)
        blue = CGFloat(sliderBlue.value / 255.0)
        
        drawPreview()
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        if sender == sliderBrush {
            brush = CGFloat(sender.value)
            
        }
        drawPreview()
    }
    
    func drawPreview() {
        UIGraphicsBeginImageContext(imageViewBrush.frame.size)
        var context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineWidth(context, brush)
        
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextMoveToPoint(context, 45.0, 45.0)
        CGContextAddLineToPoint(context, 45.0, 45.0)
        CGContextStrokePath(context)
        imageViewBrush.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let present: DrawViewController = (presentingViewController as! DrawViewController)
        sliderBrush.value = Float(present.brushWidth)
        sliderRed.value = Float(present.red * 255)
        sliderGreen.value = Float(present.green * 255)
        sliderBlue.value = Float(present.blue * 255)
        self.red = CGFloat(sliderRed.value)
        self.blue = CGFloat(sliderBlue.value)
        self.green = CGFloat(sliderGreen.value)
        self.brush = CGFloat(sliderBrush.value)
        //let draw: DrawViewController = presentingViewController as! DrawViewController
        self.colorChanged(nil)
        self.drawPreview()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        self.drawPreview()
    }
}