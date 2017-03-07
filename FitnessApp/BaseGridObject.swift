//
//  BaseGridObject.swift
//  FitnessApp
//
//  Created by Adam Moorey on 02/03/2017.
//  Copyright © 2017 Adam Moorey. All rights reserved.
//

import UIKit

class BaseGridObject: NSObject, NSCoding
{
    var attachedPosition: UIImageView!
    var baseImage: UIImage?
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("baseGridObject")
    
    // MARK: Types
    struct PropertyKey
    {
        static let attachedPosition = "attachedPosition"
        static let baseImage = "baseImage"
    }
    
    init?(attachedPosition: UIImageView!, baseImage: UIImage?)
    {
        self.attachedPosition = attachedPosition
        
        if (baseImage == nil)
        {
            self.baseImage = UIImage(named: "Empty")
        }
        else
        {
            self.baseImage = baseImage
            self.attachedPosition.image = baseImage
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let attachedPosition = aDecoder.decodeObject(forKey: PropertyKey.attachedPosition) as! UIImageView
        let baseImage = aDecoder.decodeObject(forKey: PropertyKey.baseImage) as! UIImage
        
        //must call designated initializer
        self.init(attachedPosition: attachedPosition, baseImage: baseImage)
    }
    
    // MARK: NSCoding
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(attachedPosition, forKey: PropertyKey.attachedPosition)
        aCoder.encode(baseImage, forKey: PropertyKey.baseImage)
    }
}
