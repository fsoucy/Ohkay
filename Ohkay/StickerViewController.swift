//
//  StickerViewController.swift
//  Prototype
//
//  Created by Francis Soucy on 6/3/15.
//  Copyright (c) 2015 Soucy Development. All rights reserved.
//

import UIKit

class StickerViewController: UIViewController
{
    
    //var pinchRec: UIPinchGestureRecognizer!
    
    //var rotationRec: UIRotationGestureRecognizer!
    
    @IBOutlet weak var stickerLibrary: UIView!
    var current: UIImage?
    var currentImageView: UIImageView?
    var selectedImageForChange: UIImageView?
    var postedImageViews: [UIImageView] = []
    var toMoveImageView: UIImageView?
    //var arrayOfTransformValues: [(CGFloat, CGFloat)] = []
    
    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
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
        if (presentingViewController as! ViewController).realImageView?.image != nil
        {
            self.theImageView.image = (presentingViewController as! ViewController).realImageView!.image
        }
    }
    
    
    @IBAction func foundTap(sender: AnyObject)
    {
        let tapRec: UITapGestureRecognizer = sender as! UITapGestureRecognizer
        let tapLoc: CGPoint = tapRec.locationInView(self.view)
        var foundOne: Bool = false
        for view in postedImageViews
        {
            let imgForCheck: UIImageView = view as UIImageView
            let imgLoc: CGPoint = imgForCheck.frame.origin
            
            if (tapLoc.x >= imgLoc.x) && (tapLoc.x <= imgLoc.x + imgForCheck.frame.size.width) && (tapLoc.y >= imgLoc.y) && (tapLoc.y <= imgLoc.y + imgForCheck.frame.size.height)
            {
                foundOne = true
                if imgForCheck == self.selectedImageForChange
                {
                    self.selectedImageForChange!.layer.borderWidth = CGFloat(0.0)
                    self.selectedImageForChange = nil
                }
                else
                {
                    if self.selectedImageForChange != nil
                    {
                        self.selectedImageForChange!.layer.borderWidth = CGFloat(0.0)
                    }
                    self.selectedImageForChange = imgForCheck
                    self.selectedImageForChange!.layer.borderColor = UIColor.blackColor().CGColor
                    self.selectedImageForChange!.layer.borderWidth = CGFloat(3.0)
                }
            }
        }
        if foundOne == false
        {
            self.selectedImageForChange = nil
        }
        self.updateSelection()
    }
    
    
    @IBAction func foundPinch(sender: AnyObject)
    {
        
        if self.selectedImageForChange != nil
        {
            self.selectedImageForChange!.transform = CGAffineTransformMakeRotation(0)
            let tempCenter: CGPoint = self.selectedImageForChange!.center
            //let index: Int = find(self.postedImageViews, self.selectedImageForChange!)!
            var scale: CGFloat = (sender as! UIPinchGestureRecognizer).scale // + self.arrayOfTransformValues[index].0
            //let rotation: CGFloat = self.arrayOfTransformValues[index].1
            
            /*
            if scale > 1
            {
                let modScale: CGFloat = scale * 0.7
                if modScale < 1.0
                {
                    scale = 1.02
                }
                else
                {
                    scale = modScale
                }
            }
            if scale < 1
            {
                let modScale: CGFloat = scale * 1.5
                if modScale > 1.0
                {
                    scale = 0.98
                }
                else
                {
                    scale = modScale
                }
            }
            */
            /*
            if scale > 4
            {
                let modScale: CGFloat = scale * 0.6
            }
            */
            
            if (sender as! UIPinchGestureRecognizer).velocity > 2.0
            {
                scale *= 0.7
                if scale < 1.5
                {
                    scale = 1.5
                }
            }
            
            NSLog(String(format: "%1.2f", (sender as! UIPinchGestureRecognizer).velocity))
            self.selectedImageForChange!.frame.size.width *= scale
            self.selectedImageForChange!.frame.size.height *= scale
            
            //self.selectedImageForChange!.transform = CGAffineTransformMakeScale(scale, scale)
            //self.selectedImageForChange!.transform = CGAffineTransformMakeRotation(rotation)
            self.selectedImageForChange!.center = tempCenter
            //(sender as! UIPinchGestureRecognizer).scale = CGFloat(1.0)
        }
    }
    
    
    @IBAction func foundRotation(sender: AnyObject)
    {
        if self.selectedImageForChange != nil
        {
            
            let tempCenter: CGPoint = self.selectedImageForChange!.center
            let rotation: CGFloat = (sender as! UIRotationGestureRecognizer).rotation
            self.selectedImageForChange!.transform = CGAffineTransformMakeRotation(rotation)
            //NSLog(String(format: "%1.2f", rotation))
            //let index: Int = find(self.postedImageViews, self.selectedImageForChange!)!
            //let (oldScale, oldRotation): (CGFloat, CGFloat) = self.arrayOfTransformValues[index]
            //let fullRotation: CGFloat = rotation + oldRotation
            //let fullScale: CGFloat = oldScale
            //self.arrayOfTransformValues[index].0 += rotation
            //self.selectedImageForChange!.transform = CGAffineTransformMakeRotation(fullRotation)
            //self.selectedImageForChange!.transform = CGAffineTransformMakeScale(fullScale, fullScale)
            self.selectedImageForChange!.center = tempCenter
            //(sender as! UIRotationGestureRecognizer).rotation = CGFloat(0.0)
        }
    }

    
    
    @IBAction func dragSticker(sender: AnyObject)
    {
        var currentImageView: UIImageView?
        let gesture: UIPanGestureRecognizer = sender as! UIPanGestureRecognizer
        if gesture.state == UIGestureRecognizerState.Began
        {
            let gestureX = gesture.locationInView(self.view).x
            let gestureY = gesture.locationInView(self.view).y
            for view in self.view.subviews
            {
                if view is UIImageView
                {
                    for imgView in postedImageViews
                    {
                        let imageX = imgView.frame.origin.x
                        let imageY = imgView.frame.origin.y
                        if (gestureX >= imageX) && (gestureX <= imageX + imgView.frame.size.width) && (gestureY   >= imageY) && (gestureY <= imageY + imgView.frame.size.width)
                        {
                            self.toMoveImageView = imgView
                        }
                    }
                    
                    if self.toMoveImageView == nil
                    {
                        let imageView: UIImageView = view as! UIImageView

                        let imageX = imageView.frame.origin.x
                        let imageY = imageView.frame.origin.y
                        if (gestureX >= imageX) && (gestureX <= imageX + imageView.frame.size.width) && (gestureY   >= imageY) && (gestureY <= imageY + imageView.frame.size.width && imageView != self.theImageView) && (imageView != self.backgroundImageView)
                        {
                            self.current = imageView.image
                            self.currentImageView = imageView
                        }
                    }
                }
            }
            
            let gestureInX = gesture.locationInView(stickerLibrary).x
            let gestureInY = gesture.locationInView(stickerLibrary).y
            
            for view in self.stickerLibrary.subviews
            {
                if view is UIImageView
                {
                    for imgView in postedImageViews
                    {
                        let imageX = imgView.frame.origin.x
                        let imageY = imgView.frame.origin.y
                        if (gestureInX >= imageX) && (gestureInX <= imageX + imgView.frame.size.width) && (gestureInY   >= imageY) && (gestureInY <= imageY + imgView.frame.size.width)
                        {
                            self.toMoveImageView = imgView
                        }
                    }
                    
                    if self.toMoveImageView == nil
                    {
                        let imageView: UIImageView = view as! UIImageView
                        
                        let imageX = imageView.frame.origin.x
                        let imageY = imageView.frame.origin.y
                        if (gestureInX >= imageX) && (gestureInX <= imageX + imageView.frame.size.width) && (gestureInY   >= imageY) && (gestureInY <= imageY + imageView.frame.size.width && imageView != self.theImageView) && (imageView != self.backgroundImageView)
                        {
                            self.current = imageView.image
                            self.currentImageView = imageView
                        }
                    }
                }
            }
        }
        
        
        if gesture.state == UIGestureRecognizerState.Ended
        {
            if self.toMoveImageView == nil
            {
                if self.current != nil && self.currentImageView != nil
                {
                    let createImageView: UIImageView = UIImageView(frame: CGRectMake(gesture.locationInView(self.view).x, gesture.locationInView(self.view).y, self.currentImageView!.frame.size.width, self.currentImageView!.frame.size.height))
                    createImageView.image = self.current!
                    self.view.addSubview(createImageView)
                    self.view.bringSubviewToFront(createImageView)
                    self.postedImageViews.append(createImageView)
                    //self.arrayOfTransformValues.append((CGFloat(1.0), CGFloat(0.0)))
                    self.selectedImageForChange = createImageView
                    self.updateSelection()
                    self.current = nil
                    self.currentImageView = nil
                }
            }
            else
            {
                self.toMoveImageView!.center = gesture.locationInView(self.view)
                self.selectedImageForChange = self.toMoveImageView
                self.toMoveImageView = nil
                self.updateSelection()
            }
        }
    }
    
    func updateSelection()
    {
        for imageview in self.postedImageViews
        {
            if imageview == self.selectedImageForChange
            {
                imageview.layer.borderColor = UIColor.blackColor().CGColor
                imageview.layer.borderWidth = CGFloat(3.0)
            }
            else
            {
                imageview.layer.borderWidth = CGFloat(0.0)
            }
        }
    }
    
    @IBAction func foundDoubleTap(sender: AnyObject)
    {
        if self.selectedImageForChange != nil
        {
            self.selectedImageForChange!.image = nil
            self.selectedImageForChange!.removeFromSuperview()
            self.selectedImageForChange = nil
        }
    }
    
    
    @IBAction func exitFromTutorial(sender: UIStoryboardSegue)
    {
        
    }
}
