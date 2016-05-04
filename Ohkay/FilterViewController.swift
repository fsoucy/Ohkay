//
//  FilterViewController.swift
//  Prototype
//
//  Created by Francis Soucy on 6/3/15.
//  Copyright (c) 2015 Soucy Development. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController
{
    
    @IBOutlet weak var theScroller: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cruelPreset: UIImageView!
    @IBOutlet weak var coldPreset: UIImageView!
    @IBOutlet weak var sunnyPreset: UIImageView!
    @IBOutlet weak var jupiterPreset: UIImageView!
    @IBOutlet weak var aprilPreset: UIImageView!
    @IBOutlet weak var monoPreset: UIImageView!
    @IBOutlet weak var bleedPreset: UIImageView!
    @IBOutlet weak var religionPreset: UIImageView!
    @IBOutlet weak var darkPreset: UIImageView!
    @IBOutlet weak var parkPreset: UIImageView!
    @IBOutlet weak var winterPreset: UIImageView!
    @IBOutlet weak var historyPreset: UIImageView!
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation
    {
        return UIInterfaceOrientation.Portrait
    }
    
    override func shouldAutorotate() -> Bool
    {
        return false
    }
    
    @IBAction func applySepia(sender: AnyObject)
    {
        self.applyFilter("CIColorInvert")
        self.applyFilter("CIPhotoEffectTonal")
        self.applyFilter("CIColorInvert")
    }
    
    @IBAction func revertToOriginal(sender: AnyObject)
    {
        self.imageView.image = (presentingViewController as! ViewController).realImageView.image!
    }
    /**
    func applyTone(sender: AnyObject)
    {
        self.applyFilter("CIToneCurve")
    }
    */
    
    @IBAction func applyVibrate(sender: AnyObject)
    {
        self.applyFilter("CIHueAdjust")
        self.applyFilter("CIGammaAdjust")
        self.applyFilter("CIExposureAdjust")
        self.applyFilter("CIPhotoEffectTransfer")
    }
    
    @IBAction func applyInvert(sender: AnyObject)
    {
        self.applyFilter("CIColorInvert")
    }
    
    @IBAction func applyVignette(sender: AnyObject)
    {
        let imageToFilter: UIImage = imageView.image!
        var beforeFilter: CIImage!
        if imageToFilter.CIImage != nil
        {
            beforeFilter = imageToFilter.CIImage
        }
        else
        {
            beforeFilter = CIImage(image: imageToFilter)
        }
        let filter: CIFilter = CIFilter(name: "CIVignetteEffect")
        filter.setDefaults()
        filter.setValue(CIVector(CGPoint: imageView.center), forKey: "inputCenter")
        filter.setValue(0.25, forKey: "inputIntensity")
        filter.setValue(beforeFilter, forKey: "inputImage")
        var afterFilter: CIImage = filter.valueForKey("outputImage") as! CIImage
        let context: CIContext = CIContext(options: [kCIContextUseSoftwareRenderer: true])
        let extent: CGRect = afterFilter.extent()
        let cgImage: CGImageRef = context.createCGImage(afterFilter, fromRect: extent)
        let toReturn: UIImage = UIImage(CGImage: cgImage)!
        self.imageView.image = toReturn
    }
    
    /**func applyDots(sender: AnyObject)
    {
        self.applyFilter("CIDotScreen")
    }*/
    
    @IBAction func applyTile(sender: AnyObject)
    {
        self.applyFilter("CIPhotoEffectTransfer")
        self.applyFilter("CIPhotoEffectTonal")
    }
    
    @IBAction func applySpot(sender: AnyObject)
    {
        self.applyFilter("CIPhotoEffectTransfer")
    }
    
    @IBAction func applyMono(sender: AnyObject)
    {
        let imageToFilter: UIImage = imageView.image!
        var beforeFilter: CIImage!
        if imageToFilter.CIImage != nil
        {
            beforeFilter = imageToFilter.CIImage
        }
        else
        {
            beforeFilter = CIImage(image: imageToFilter)
        }
        let filter: CIFilter = CIFilter(name: "CIColorPosterize")
        filter.setDefaults()
        filter.setValue(10.0, forKey: "inputLevels")
        filter.setValue(beforeFilter, forKey: "inputImage")
        var afterFilter: CIImage = filter.valueForKey("outputImage") as! CIImage
        let context: CIContext = CIContext(options: [kCIContextUseSoftwareRenderer: true])
        let extent: CGRect = afterFilter.extent()
        let cgImage: CGImageRef = context.createCGImage(afterFilter, fromRect: extent)
        let toReturn: UIImage = UIImage(CGImage: cgImage)!
        self.imageView.image = toReturn
    }
    
    @IBAction func applyTonal(sender: AnyObject)
    {
        self.applyFilter("CIPhotoEffectTonal")
    }
    
    @IBAction func applyHistogram(sender: AnyObject)
    {
        let imageToFilter: UIImage = imageView.image!
        var beforeFilter: CIImage!
        if imageToFilter.CIImage != nil
        {
            beforeFilter = imageToFilter.CIImage
        }
        else
        {
            beforeFilter = CIImage(image: imageToFilter)
        }
        let filter: CIFilter = CIFilter(name: "CIPixellate")
        filter.setDefaults()
        filter.setValue(3.5, forKey: "inputScale")
        filter.setValue(beforeFilter, forKey: "inputImage")
        var afterFilter: CIImage = filter.valueForKey("outputImage") as! CIImage
        let context: CIContext = CIContext(options: [kCIContextUseSoftwareRenderer: true])
        let extent: CGRect = afterFilter.extent()
        let cgImage: CGImageRef = context.createCGImage(afterFilter, fromRect: extent)
        let toReturn: UIImage = UIImage(CGImage: cgImage)!
        self.imageView.image = toReturn
    }
    
    @IBAction func applyBloom(sender: AnyObject)
    {
        self.applyFilter("CIColorPosterize")
        self.applyFilter("CISepiaTone")
    }
    
    @IBAction func applyMonodot(sender: AnyObject)
    {
        self.applyFilter("CIDotScreen")
        self.applyFilter("CIColorMonochrome")
    }
    
    @IBAction func applyMapdot(sender: AnyObject)
    {
        self.applyFilter("CIDotScreen")
        self.applyFilter("CIColorPosterize")
    }
    
    
    
    func applyFilter(filterName: String)
    {
        let imageToFilter: UIImage = imageView.image!
        var beforeFilter: CIImage!
        if imageToFilter.CIImage != nil
        {
            beforeFilter = imageToFilter.CIImage
        }
        else
        {
            beforeFilter = CIImage(image: imageToFilter)
        }
        let filter: CIFilter = CIFilter(name: filterName)
        filter.setDefaults()
        filter.setValue(beforeFilter, forKey: "inputImage")
        var afterFilter: CIImage = filter.valueForKey("outputImage") as! CIImage
        let context: CIContext = CIContext(options: [kCIContextUseSoftwareRenderer: true])
        let extent: CGRect = afterFilter.extent()
        let cgImage: CGImageRef = context.createCGImage(afterFilter, fromRect: extent)
        let toReturn: UIImage = UIImage(CGImage: cgImage)!
        self.imageView.image = toReturn
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        if (presentingViewController as! ViewController).realImageView?.image != nil
        {
            self.imageView.image = (presentingViewController as! ViewController).realImageView!.image!
        }
        NSLog(String(format: "x: %1.2f, y: %1.2f", theScroller.frame.origin.x, theScroller.frame.origin.y))
    }
    
    func applyFilterToImageView(buttonImageView: UIImageView, filterName: String)
    {
        let imageToFilter: UIImage = buttonImageView.image!
        var beforeFilter: CIImage!
        if imageToFilter.CIImage != nil
        {
            beforeFilter = imageToFilter.CIImage
        }
        else
        {
            beforeFilter = CIImage(image: imageToFilter)
        }
        let filter: CIFilter = CIFilter(name: filterName)
        filter.setDefaults()
        filter.setValue(beforeFilter, forKey: "inputImage")
        var afterFilter: CIImage = filter.valueForKey("outputImage") as! CIImage
        let context: CIContext = CIContext(options: [kCIContextUseSoftwareRenderer: true])
        let extent: CGRect = afterFilter.extent()
        let cgImage: CGImageRef = context.createCGImage(afterFilter, fromRect: extent)
        let toReturn: UIImage = UIImage(CGImage: cgImage)!
        buttonImageView.image = toReturn
    }
    
    
    func applyFilterToWinter()
    {
        let imageToFilter: UIImage = winterPreset.image!
        var beforeFilter: CIImage!
        if imageToFilter.CIImage != nil
        {
            beforeFilter = imageToFilter.CIImage
        }
        else
        {
            beforeFilter = CIImage(image: imageToFilter)
        }
        let filter: CIFilter = CIFilter(name: "CIVignetteEffect")
        filter.setDefaults()
        filter.setValue(CIVector(CGPoint: imageView.center), forKey: "inputCenter")
        filter.setValue(0.25, forKey: "inputIntensity")
        filter.setValue(beforeFilter, forKey: "inputImage")
        var afterFilter: CIImage = filter.valueForKey("outputImage") as! CIImage
        let context: CIContext = CIContext(options: [kCIContextUseSoftwareRenderer: true])
        let extent: CGRect = afterFilter.extent()
        let cgImage: CGImageRef = context.createCGImage(afterFilter, fromRect: extent)
        let toReturn: UIImage = UIImage(CGImage: cgImage)!
        self.winterPreset.image = toReturn
    }
    
    override func viewDidLayoutSubviews()
    {
        self.theScroller.scrollEnabled = true
        self.theScroller.userInteractionEnabled = true
        self.theScroller.contentSize = CGSizeMake(1700.0, 119.0)
        if(UIScreen.mainScreen().bounds.width > 350)
        {
            self.theScroller.contentSize = CGSizeMake(1645.0, 119.0)
        }
        if(UIScreen.mainScreen().bounds.width > 400)
        {
            self.theScroller.contentSize = CGSizeMake(1606.0, 119.0)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //scroll view
        self.theScroller.scrollEnabled = true
        self.theScroller.contentSize = CGSizeMake(1700.0, 119.0)
        // UNCOMMENT AFTER TESTING
        //apply filters to buttons
        
        applyFilterToImageView(cruelPreset,filterName: "CIColorInvert")
        applyFilterToImageView(cruelPreset, filterName: "CIPhotoEffectTonal")
        applyFilterToImageView(cruelPreset, filterName: "CIColorInvert")
        applyFilterToImageView(coldPreset,filterName: "CIColorInvert")
        applyFilterToImageView(sunnyPreset, filterName: "CIPhotoEffectTonal")
        applyFilterToImageView(jupiterPreset, filterName: "CIColorPosterize")
        applyFilterToImageView(aprilPreset, filterName: "CIHueAdjust")
        applyFilterToImageView(aprilPreset, filterName: "CIGammaAdjust")
        applyFilterToImageView(aprilPreset, filterName: "CIExposureAdjust")
        applyFilterToImageView(aprilPreset, filterName: "CIPhotoEffectTransfer")
        applyFilterToImageView(monoPreset, filterName: "CIDotScreen")
        applyFilterToImageView(monoPreset, filterName: "CIColorMonochrome")
        applyFilterToImageView(bleedPreset, filterName: "CIPhotoEffectTransfer")
        applyFilterToImageView(religionPreset, filterName: "CIColorPosterize")
        applyFilterToImageView(religionPreset, filterName: "CISepiaTone")
        applyFilterToImageView(darkPreset, filterName: "CIDotScreen")
        applyFilterToImageView(darkPreset, filterName: "CIColorPosterize")
        applyFilterToImageView(parkPreset, filterName: "CIPhotoEffectTransfer")
        applyFilterToImageView(parkPreset, filterName: "CIPhotoEffectTonal")
        applyFilterToImageView(historyPreset, filterName: "CIPixellate")
        applyFilterToWinter()
        
    }
}
