//
//  ViewController.swift
//  Prototype
//
//  Created by Francis Soucy on 6/3/15.
//  Copyright (c) 2015 Soucy Development. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet weak var fingersLib: UIImageView!
    @IBOutlet weak var fingersCam: UIImageView!
    @IBOutlet weak var photoLibraryButton: UIButton!
    @IBOutlet weak var realImageView: UIImageView!
    var originalRect: CGRect!
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation
    {
        return UIInterfaceOrientation.Portrait
    }
    
    override func shouldAutorotate() -> Bool
    {
        return false
    }
    
    func loadDestinationVC()
    {
        if NSUserDefaults.standardUserDefaults().boolForKey("FirstUse") == true
        {
            self.performSegueWithIdentifier("HowSegue", sender: nil)
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool
    {
        if realImageView.image != nil
        {
            return true
        }
        else
        {
            if identifier == "HowSegue"
            {
                return true
            }
            self.fingersCam.hidden = false
            self.fingersLib.hidden = false
            return false
        }
    }
    
    /**
    override func viewDidLoad()
    {
        let name: String = UIDevice.currentDevice().model
        let version: String = UIDevice.currentDevice().systemVersion
        let concat: String = name + " " + version
        NSLog(concat)
    }
    */
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        self.loadDestinationVC()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        for subview in self.view.subviews
        {
            if subview is UIButton
            {
                self.view.bringSubviewToFront(subview as! UIView)
            }
        }
        self.fingersCam.hidden = true
        self.fingersLib.hidden = true
    }

    @IBAction func photoLibrary(sender: AnyObject)
    {
        var toPresent: Bool = false
        let imagePicker: UIImagePickerController = UIImagePickerController()
        if((sender as! UIButton) == photoLibraryButton)
        {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
            {
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                toPresent = true
            }
        }
        else
        {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            {
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                toPresent = true
            }
        }
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        if(toPresent == true)
        {
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        let chosenImage: UIImage
        if info[UIImagePickerControllerEditedImage] != nil
        {
            chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        }
        else
        {
            chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        
        let imageWidth: CGFloat = chosenImage.size.width
        let imageHeight: CGFloat = chosenImage.size.height
        let screenWidth: CGFloat = self.realImageView.frame.size.width
        let screenHeight: CGFloat = self.realImageView.frame.size.height
        let scale: CGFloat = CGFloat(min((screenWidth / imageWidth),(screenHeight / imageHeight)))
        
        //Temporary fix (works for all devices though)
        let newScreenSize: CGRect = UIScreen.mainScreen().bounds
        let newScreenHeight = newScreenSize.height
        let newScreenWidth = newScreenSize.width
        //var width: CGFloat = floor(imageWidth * scale)
        //var height: CGFloat = floor(imageHeight * scale)
        var width: CGFloat = imageWidth * scale
        var height: CGFloat = imageHeight * scale
        var y: CGFloat = newScreenHeight - height
        var x: CGFloat = newScreenWidth - width
        
        
        //compare screenWidth to newScreenWidth
        //try and use image view instead of mainScreen().bounds
        
        self.originalRect = CGRectMake(x, y, width * 2.0, height * 2.0)
        
        if(UIScreen.mainScreen().scale > 2.9)
        {
            self.originalRect = CGRectMake(x * 1.5, y * 1.5, width * 3.0, height * 3.0)
        }
        
        if(UIScreen.mainScreen().scale < 1.1)
        {
            self.originalRect = CGRectMake(x / 2.0, y / 2.0, width, height)
        }

        realImageView.image = chosenImage
        self.fingersLib.hidden = true
        self.fingersCam.hidden = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func exitFromFilters(sender: UIStoryboardSegue)
    {
        
        let filters: FilterViewController = sender.sourceViewController as! FilterViewController
        let now: ViewController = sender.destinationViewController as! ViewController
        /**
        for subView in filters.view.subviews
        {
            if subView is UIButton
            {
                (subView as! UIButton).hidden = true
            }
        }
        UIGraphicsBeginImageContextWithOptions(filters.imageView.bounds.size, filters.imageView.opaque, 0.0)
        let ctx: CGContextRef = UIGraphicsGetCurrentContext()
        //pencilView.hidden = false
        filters.view.layer.renderInContext(ctx)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        for subView in filters.view.subviews
        {
            (subView as! UIView).hidden = false
        }
        UIGraphicsEndImageContext()
        */
        now.realImageView.image = filters.imageView.image
    }
    
    @IBAction func exitFromStickers(sender: UIStoryboardSegue)
    {
        //get stickers view controller
        let stickers: StickerViewController = sender.sourceViewController as! StickerViewController
        //get current view controller
        let now: ViewController = sender.destinationViewController as! ViewController
        //hide all subviews
        
        for subView in stickers.view.subviews
        {
            (subView as! UIView).hidden = true
        }
    
        //unhide main image view
        stickers.theImageView.hidden = false
        
        //unhide all stickers added t oimage
        for imgs in stickers.postedImageViews
        {
            (imgs as UIImageView).hidden = false
            (imgs as UIImageView).layer.borderWidth = CGFloat(0.0)
        }
        
        //begin graphics context, the size of the image view (which is the whole screen) HERE
        UIGraphicsBeginImageContextWithOptions(stickers.theImageView.bounds.size, stickers.theImageView.opaque, 0.0)
        
        //get current context
        let ctx: CGContextRef = UIGraphicsGetCurrentContext()
        
        //render the layer of the whole view onto the context HERE
        stickers.view.layer.renderInContext(ctx)
        
        //get the image from the current context
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        //unhide all of the subviews
        for subView in stickers.view.subviews
        {
            (subView as! UIView).hidden = false
        }
        //end image context
        UIGraphicsEndImageContext()
        //set image view of main view controller
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(image.CGImage, self.originalRect)
        NSLog(String(format: "%1.2f", self.originalRect.height))
        NSLog(String(format: "%1.2f", self.originalRect.width))
        
        let finalImage: UIImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)!
        NSLog(String(format: "%1.2f", finalImage.size.height))
        NSLog(String(format: "%1.2f", finalImage.size.width))
        now.realImageView.image = finalImage
    }
    
    @IBAction func exitFromText(sender: UIStoryboardSegue)
    {
        let text: TextViewController = sender.sourceViewController as! TextViewController
        let now: ViewController = sender.destinationViewController as! ViewController
        for subView in text.view.subviews
        {
            if !(subView is UILabel) && !(subView is UIImageView) && !((subView as! UIView) == self.view)
            {
                (subView as! UIView).hidden = true
            
            }
        }
        
        for label in text.addedLabelsArray
        {
            (label as UIView).hidden = false
            (label as UILabel).layer.borderWidth = CGFloat(0.0)
        }
        UIGraphicsBeginImageContextWithOptions(text.imageView.bounds.size, text.imageView.opaque, 0.0)
        let ctx: CGContextRef = UIGraphicsGetCurrentContext()
        //pencilView.hidden = false
        text.view.layer.renderInContext(ctx)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        for subView in text.view.subviews
        {
            (subView as! UIView).hidden = false
        }
        UIGraphicsEndImageContext()
        NSLog(String(format: "%1.2f", self.originalRect.minY))
        
        NSLog(String(format: "%1.2f", image.size.width))
        
        
        
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(image.CGImage, self.originalRect)
        NSLog(String(format: "%1.2f", self.originalRect.height))
        NSLog(String(format: "%1.2f", self.originalRect.width))
        
        let finalImage: UIImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)!
        NSLog(String(format: "%1.2f", finalImage.size.height))
        NSLog(String(format: "%1.2f", finalImage.size.width))
        now.realImageView.image = finalImage
    }
    
    @IBAction func exitFromHow(sender: UIStoryboardSegue)
    {
        
    }
    
    @IBAction func exitFromDraw(sender: UIStoryboardSegue)
    {
        let draw: DrawViewController = sender.sourceViewController as! DrawViewController
        let now: ViewController = sender.destinationViewController as! ViewController
        for subView in draw.view.subviews
        {
            if subView is UIButton
            {
                (subView as! UIView).hidden = true
                
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(draw.mainImageView.bounds.size, draw.mainImageView.opaque, 0.0)
        let ctx: CGContextRef = UIGraphicsGetCurrentContext()
        //pencilView.hidden = false
        draw.view.layer.renderInContext(ctx)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        for subView in draw.view.subviews
        {
            (subView as! UIView).hidden = false
        }
        UIGraphicsEndImageContext()
        
        
        
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(image.CGImage, self.originalRect)
        
        let finalImage: UIImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)!
        now.realImageView.image = finalImage
    }
    
    @IBAction func share(sender: AnyObject)
    {
        if(self.realImageView.image == nil)
        {
            self.fingersCam.hidden = false
            self.fingersLib.hidden = false
            return
        }
        let activity = UIActivityViewController(activityItems: [self.realImageView.image!], applicationActivities: nil)
        self.presentViewController(activity, animated: true, completion: nil)
    }
    

}


