//
//  BaseViewController.swift
//  FitnessApp
//
//  Created by Adam Moorey on 16/02/2017.
//  Copyright © 2017 Adam Moorey. All rights reserved.
//

import UIKit

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
        
        loadEmptyPlots()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
