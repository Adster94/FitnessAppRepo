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
        
        if let savedStructures = loadStructures()
        {
            for BaseGridObject in savedStructures
            {
                BaseGridObject.attachedPosition.image = BaseGridObject.baseImage
            }
            
            placedStructures += savedStructures
            
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
        let topMiddle = BaseGridObject(attachedPosition: self.topMiddle, baseImage: UIImage(named: "Empty"))!
        let topLeft = BaseGridObject(attachedPosition: self.topLeft, baseImage: UIImage(named: "Empty"))!
        let topRight = BaseGridObject(attachedPosition: self.topRight, baseImage: UIImage(named: "Empty"))!
        
        let midMiddle = BaseGridObject(attachedPosition: self.midMiddle, baseImage: UIImage(named: "Empty"))!
        let midLeft = BaseGridObject(attachedPosition: self.midLeft, baseImage: UIImage(named: "Empty"))!
        let midRight = BaseGridObject(attachedPosition: self.midRight, baseImage: UIImage(named: "Empty"))!
        
        let botMiddle = BaseGridObject(attachedPosition: self.botMiddle, baseImage: UIImage(named: "Empty"))!
        let botLeft = BaseGridObject(attachedPosition: self.botLeft, baseImage: UIImage(named: "Empty"))!
        let botRight = BaseGridObject(attachedPosition: self.botRight, baseImage: UIImage(named: "Empty"))!
        
        placedStructures += [topMiddle, topLeft, topRight, midMiddle, midLeft, midRight, botMiddle, botLeft, botRight]
    }
    
    func placeStructure()
    {
        if (selectedObjectView.image != UIImage(named: "Empty"))
        {
            placeLoop: for BaseGridObject in placedStructures
            {
                if (selectedObjectView.frame.intersects(BaseGridObject.attachedPosition.frame))
                {
                    BaseGridObject.attachedPosition.image = selectedObjectView.image
                    BaseGridObject.baseImage = selectedObjectView.image
                    
                    print("Placed structure")
                    
                    selectedObjectView.frame.origin = resetPosition
                    selectedObjectView.image = UIImage(named: "Empty")
                    break placeLoop
                }
            }
        }
        else
        {
            selectedObjectView.frame.origin = resetPosition
        }
        
        saveStructures()
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
