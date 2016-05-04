//
//  DrawViewController.swift
//  Prototype
//
//  Created by Francis Soucy on 6/14/15.
//  Copyright (c) 2015 Soucy Development. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController
{

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    var lastPoint = CGPoint.zeroPoint
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var origRect: CGRect?
    
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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func reset(sender: AnyObject)
    {
        mainImageView.image = (presentingViewController as! ViewController).realImageView.image!
    }
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        swiped = false
        if let touch = touches.first as? UITouch
        {
            lastPoint = touch.locationInView(self.view)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint)
    {
        
        
        UIGraphicsBeginImageContextWithOptions(self.mainImageView.bounds.size, self.mainImageView.opaque, 0.0)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.layer.renderInContext(context)
        
        
        
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        
        CGContextStrokePath(context)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(image.CGImage, (presentingViewController as! ViewController).originalRect)
        
        let finalImage: UIImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)!
        
        
        tempImageView.image = finalImage
        tempImageView.alpha = self.opacity
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
    
        swiped = true
        if let touch = touches.first as? UITouch {
            let currentPoint = touch.locationInView(view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContextWithOptions(mainImageView.frame.size, self.mainImageView.opaque, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        self.view.layer.renderInContext(ctx)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(image.CGImage, (presentingViewController as! ViewController).originalRect)
        
        let finalImage: UIImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)!
        UIGraphicsEndImageContext()
        self.mainImageView.image = finalImage
        
        tempImageView.image = nil
    }
    
    @IBAction func exitFromSettings(sender: UIStoryboardSegue) {
        let settingsViewController = sender.sourceViewController as! SettingsViewController
        self.brushWidth = settingsViewController.brush
        self.red = settingsViewController.red
        self.green = settingsViewController.green
        self.blue = settingsViewController.blue
    }
    
    /**
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if sender?.sourceViewController is ViewController
        {
            self.mainImageView.image = (segue.sourceViewController as! ViewController).realImageView.image!
        }
    }
*/
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.origRect = (presentingViewController as! ViewController).originalRect
        if self.mainImageView.image == nil
        {
            self.mainImageView.image = (presentingViewController as! ViewController).realImageView.image!
        }
    }
    
}
