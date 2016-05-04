
//
//  TextViewController.swift
//  Prototype
//
//  Created by Francis Soucy on 6/4/15.
//  Copyright (c) 2015 Soucy Development. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addText: UITextField!
    var addedLabelsArray: [UILabel] = []
    var selectedLabelForChange: UILabel?
    var toMoveLabel: UILabel?
    var redV: Float = 0.0
    var greenV: Float = 0.0
    var blueV: Float = 0.0    
    
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation
    {
        return UIInterfaceOrientation.Portrait
    }
    
    override func shouldAutorotate() -> Bool
    {
        return false
    }
    
    override func viewDidAppear(animated: Bool)
    {
        self.imageView.image = (presentingViewController as! ViewController).realImageView.image
    }
    
    
    
    
    @IBAction func doAddText(sender: AnyObject)
    {
        let text: String = addText.text
        var label: UILabel = UILabel(frame: CGRectMake(self.imageView.center.x - 40.0, self.imageView.center.y - 25.0, 80.0, 50.0))
        if(count(text) > 4 && count(text) <= 7)
        {
            label = UILabel(frame: CGRectMake(self.imageView.center.x - 55.0, self.imageView.center.y - 25.0, 110.0, 50.0))
        }
        if(count(text) > 7 && count(text) <= 9)
        {
            label = UILabel(frame: CGRectMake(self.imageView.center.x - 75.0, self.imageView.center.y - 25.0, 150.0, 50.0))
        }
        if (count(text) > 9)
        {
            label = UILabel(frame: CGRectMake(self.imageView.center.x - 110.0, self.imageView.center.y - 25.0, 220.0, 50.0))
        }
        
        label.text = text
        label.textColor = UIColor(red: CGFloat(redV), green: CGFloat(greenV), blue: CGFloat(blueV), alpha: CGFloat(1.0))
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        self.addedLabelsArray.append(label)
        addText.text = ""
        addText.resignFirstResponder()
        self.selectedLabelForChange = label
        self.updateSelection()
    }
    
    
    @IBAction func foundTap(sender: AnyObject)
    {
        if addText.isFirstResponder()
        {
            addText.resignFirstResponder()
        }
        let tapRec: UITapGestureRecognizer = sender as! UITapGestureRecognizer
        let tapLoc: CGPoint = tapRec.locationInView(self.view)
        var foundOne: Bool = false
        for label in addedLabelsArray
        {
            let labelForCheck: UILabel = label as UILabel
            let labelLoc: CGPoint = labelForCheck.frame.origin
            
            if (tapLoc.x >= labelLoc.x) && (tapLoc.x <= labelLoc.x + labelForCheck.frame.size.width) && (tapLoc.y >= labelLoc.y) && (tapLoc.y <= labelLoc.y + labelForCheck.frame.size.height)
            {
                foundOne = true
                if labelForCheck == self.selectedLabelForChange
                {
                    self.selectedLabelForChange!.layer.borderWidth = CGFloat(0.0)
                    self.selectedLabelForChange = nil
                }
                else
                {
                    if self.selectedLabelForChange != nil
                    {
                        self.selectedLabelForChange!.layer.borderWidth = CGFloat(0.0)
                    }
                    self.selectedLabelForChange = labelForCheck
                    self.selectedLabelForChange!.layer.borderColor = UIColor.blackColor().CGColor
                    self.selectedLabelForChange!.layer.borderWidth = CGFloat(3.0)
                }
            }
        }
        if foundOne == false
        {
            self.selectedLabelForChange = nil
        }
        self.updateSelection()
    }
    
    @IBAction func dragSticker(sender: AnyObject)
    {
        let gesture: UIPanGestureRecognizer = sender as! UIPanGestureRecognizer
        if gesture.state == UIGestureRecognizerState.Began
        {
            let gestureX = gesture.locationInView(self.view).x
            let gestureY = gesture.locationInView(self.view).y
            for label in self.addedLabelsArray
            {
                let labelX = label.frame.origin.x
                let labelY = label.frame.origin.y
                if (gestureX >= labelX) && (gestureX <= labelX + label.frame.size.width) && (gestureY   >= labelY) && (gestureY <= labelY + label.frame.size.width)
                {
                    self.toMoveLabel = label
                }
            }
        }

        
        if gesture.state == UIGestureRecognizerState.Ended
        {
            if self.toMoveLabel != nil
            {
                self.toMoveLabel!.center = gesture.locationInView(self.view)
                //after pan, set selected label to old move thing
                self.selectedLabelForChange = self.toMoveLabel
                self.updateSelection()
                self.toMoveLabel = nil
            }
        }
    }
    
    @IBAction func foundRotation(sender: AnyObject)
    {
        if self.selectedLabelForChange != nil
        {
            let tempCenter: CGPoint = self.selectedLabelForChange!.center
            let rotation: CGFloat = (sender as! UIRotationGestureRecognizer).rotation
            self.selectedLabelForChange!.transform = CGAffineTransformMakeRotation(rotation)
            self.selectedLabelForChange!.center = tempCenter
        }
    }
    
    @IBAction func foundPinch(sender: AnyObject)
    {
        if self.selectedLabelForChange != nil
        {
            self.selectedLabelForChange!.transform = CGAffineTransformMakeRotation(0)
            let tempCenter: CGPoint = self.selectedLabelForChange!.center
            var scale: CGFloat = (sender as! UIPinchGestureRecognizer).scale
            if (sender as! UIPinchGestureRecognizer).velocity > 2.0
            {
                scale *= CGFloat(0.7)
                if scale < CGFloat(1.5)
                {
                    scale = CGFloat(1.5)
                }
            }
            self.selectedLabelForChange!.frame.size.width *= scale
            self.selectedLabelForChange!.frame.size.height *= scale
            let scaleFactor: CGFloat = min(self.selectedLabelForChange!.frame.size.width / 80.0 * 1.25, self.selectedLabelForChange!.frame.size.height / 50.0 * 1.25)
            self.selectedLabelForChange!.font = UIFont(name: self.selectedLabelForChange!.font.fontName, size: UIFont.labelFontSize() * scaleFactor)

            self.selectedLabelForChange!.center = tempCenter
        }
    }

    @IBAction func foundDoubleTap(sender: AnyObject)
    {
        if self.selectedLabelForChange != nil
        {
            self.selectedLabelForChange!.removeFromSuperview()
            self.selectedLabelForChange = nil
        }
    }
    
    @IBAction func exitFromOptions(sender: UIStoryboardSegue)
    {
        self.redV = (sender.sourceViewController as! OptionsViewController).redVal.value
        self.blueV = (sender.sourceViewController as! OptionsViewController).blueVal.value
        self.greenV = (sender.sourceViewController as! OptionsViewController).greenVal.value
    }
    
    func updateSelection()
    {
        for label in self.addedLabelsArray
        {
            if label == self.selectedLabelForChange
            {
                label.layer.borderColor = UIColor.blackColor().CGColor
                label.layer.borderWidth = CGFloat(3.0)
            }
            else
            {
                label.layer.borderWidth = CGFloat(0.0)
            }
        }
    }
    
}
