//
//  BaseViewController.swift
//  FitnessApp
//
//  Created by Adam Moorey on 16/02/2017.
//  Copyright © 2017 Adam Moorey. All rights reserved.
//

import UIKit
import os.log

class BaseViewController: UIViewController
{
    var placedStructures = [BaseGridObject]()
    var imageViews = [UIImageView]()
    var selectedObject: StoreObject!
    var resetPosition: CGPoint!
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var selectedObjectView: UIImageView!
    
    @IBOutlet weak var topMiddle: UIImageView!
    @IBOutlet weak var topLeft: UIImageView!
    @IBOutlet weak var topRight: UIImageView!
    
    @IBOutlet weak var midMiddle: UIImageView!
    @IBOutlet weak var midLeft: UIImageView!
    @IBOutlet weak var midRight: UIImageView!
    
    @IBOutlet weak var botMiddle: UIImageView!
    @IBOutlet weak var botLeft: UIImageView!
    @IBOutlet weak var botRight: UIImageView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        resetPosition = selectedObjectView.frame.origin
        
        imageViews += [topMiddle, topLeft, topRight, midMiddle, midLeft, midRight, botMiddle, botLeft, botRight]
        
        //loadEmptyPlots()
        //saveStructures()
        
        if let savedStructures = loadStructures()
        {
            placedStructures += savedStructures
            
            for BaseGridObject in savedStructures
            {
                findView(name: BaseGridObject.positionName).image = BaseGridObject.baseImage
                
                if (BaseGridObject.baseImage != UIImage(named: "Empty"))
                {
                    print(BaseGridObject.positionName + " image is not empty")
                }
            }
            
            print("Loaded structures")
        }
        else
        {
            loadEmptyPlots()
            
            print("Loaded empty plots")
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func loadEmptyPlots()
    {
        let topMiddle = BaseGridObject(positionName: "topMiddle", baseImage: UIImage(named: "Empty"))!
        let topLeft = BaseGridObject(positionName: "topLeft", baseImage: UIImage(named: "Empty"))!
        let topRight = BaseGridObject(positionName: "topRight", baseImage: UIImage(named: "Empty"))!
        
        let midMiddle = BaseGridObject(positionName: "midMiddle", baseImage: UIImage(named: "Empty"))!
        let midLeft = BaseGridObject(positionName: "midLeft", baseImage: UIImage(named: "Empty"))!
        let midRight = BaseGridObject(positionName: "midRight", baseImage: UIImage(named: "Empty"))!
        
        let botMiddle = BaseGridObject(positionName: "botMiddle", baseImage: UIImage(named: "Empty"))!
        let botLeft = BaseGridObject(positionName: "botLeft", baseImage: UIImage(named: "Empty"))!
        let botRight = BaseGridObject(positionName: "botRight", baseImage: UIImage(named: "Empty"))!
        
        placedStructures += [topMiddle, topLeft, topRight, midMiddle, midLeft, midRight, botMiddle, botLeft, botRight]
    }
    
    func placeStructure()
    {
        if (selectedObjectView.image != UIImage(named: "Empty"))
        {
            placeLoop: for BaseGridObject in placedStructures
            {
                let tempObject = findView(name: BaseGridObject.positionName)
                
                print("tempObject name: " + tempObject.accessibilityIdentifier!)
                
                if (selectedObjectView.frame.intersects(tempObject.frame))
                {
                    tempObject.image = selectedObjectView.image
                    BaseGridObject.baseImage = selectedObjectView.image
                    
                    saveStructures()
                    print("Placed structure")
                    
                    selectedObjectView.frame.origin = resetPosition
                    selectedObjectView.image = UIImage(named: "Empty")
                    testLabel.text = "No object selected..."
                    break placeLoop
                }
            }
        }
        else
        {
            selectedObjectView.frame.origin = resetPosition
        }
    }
    
    func findView(name: String) -> UIImageView
    {
        var imageView: UIImageView?
        
        for UIImageView in imageViews
        {
            if UIImageView.accessibilityIdentifier == name
            {
                imageView = UIImageView
            }
        }
        
        return imageView!
    }
    
    @IBAction func unwindToPlaceObject(sender: UIStoryboardSegue)
    {
        if let sourceViewController = sender.source as? StoreCollectionViewController
        {
            self.selectedObject = sourceViewController.selectedObject
            testLabel.text = self.selectedObject.itemIdentifier
            
            self.selectedObjectView.image = self.selectedObject.objectImage
        }
    }
    
    @IBAction func dragSelectedImage(_ sender: UIPanGestureRecognizer)
    {
        let translation = sender.translation(in: self.view)
        
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        if (sender.state == UIGestureRecognizerState.ended)
        {
            //pass the current object to the grid
            placeStructure()
        }
    }
    
    // MARK: Private Methods
    private func saveStructures()
    {
        //bool that changes based on if the archive worked
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(placedStructures, toFile: BaseGridObject.ArchiveURL.path)
        
        //logs the appropriate response
        if isSuccessfulSave
        {
            os_log("Structures successfully saved.", log: OSLog.default, type: .debug)
        }
        else
        {
            os_log("Failed to save structures...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadStructures() -> [BaseGridObject]?
    {
        //return the array of workouts
        return NSKeyedUnarchiver.unarchiveObject(withFile: BaseGridObject.ArchiveURL.path) as? [BaseGridObject]
    }

}
