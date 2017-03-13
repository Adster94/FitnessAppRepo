//
//  StoreObject.swift
//  FitnessApp
//
//  Created by Adam Moorey on 15/02/2017.
//  Copyright © 2017 Adam Moorey. All rights reserved.
//

import UIKit
import os.log

class BuildingObject: NSObject, NSCoding
{
    var unlocked: Bool = false
    var cost: Int = 0
    var itemIdentifier: String = ""
    var objectImage: UIImage?
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("storeObject")
    
    // MARK: Types
    struct PropertyKey
    {
        static let unlocked = "unlocked"
        static let cost = "cost"
        static let itemIdentifier = "itemIdentifier"
        static let objectImage = "objectImage"
    }
    
    init?(unlocked: Bool, cost: Int, itemIdentifier: String, image: UIImage?)
    {
        guard cost > 0 else
        {
            return nil
        }
        
        guard !itemIdentifier.isEmpty else
        {
            return nil
        }
        
        self.unlocked = unlocked
        self.cost = cost
        self.itemIdentifier = itemIdentifier
        self.objectImage = image
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let unlocked = aDecoder.decodeObject(forKey: PropertyKey.unlocked)
        let cost = aDecoder.decodeInteger(forKey: PropertyKey.cost)
        let itemIdentifier = aDecoder.decodeObject(forKey: PropertyKey.itemIdentifier) as! String
        let objectImage = aDecoder.decodeObject(forKey: PropertyKey.objectImage) as! UIImage
        
        //must call designated initializer
        self.init(unlocked: (unlocked != nil), cost: cost, itemIdentifier: itemIdentifier, image: objectImage)
    }
    
    // MARK: NSCoding
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(unlocked, forKey: PropertyKey.unlocked)
        aCoder.encode(cost, forKey: PropertyKey.cost)
        aCoder.encode(itemIdentifier, forKey: PropertyKey.itemIdentifier)
        aCoder.encode(objectImage, forKey: PropertyKey.objectImage)
    }
}
