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
    //var attachedPosition: UIImageView!
    var positionName: String
    var baseImage: UIImage?
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("baseGridObject")
    
    // MARK: Types
    struct PropertyKey
    {
        static let positionName = "positionName"
        static let baseImage = "baseImage"
    }
    
    init?(positionName: String, baseImage: UIImage?) //attachedPosition: UIImageView!
    {
        //self.attachedPosition = attachedPosition
        self.positionName = positionName
        
        if (baseImage == nil)
        {
            self.baseImage = UIImage(named: "Empty")
        }
        else
        {
            self.baseImage = baseImage
            //self.attachedPosition.image = baseImage
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let positionName = aDecoder.decodeObject(forKey: PropertyKey.positionName) as! String
        let baseImage = aDecoder.decodeObject(forKey: PropertyKey.baseImage) as! UIImage
        
        //must call designated initializer
        self.init(positionName: positionName, baseImage: baseImage)
    }
    
    // MARK: NSCoding
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(positionName, forKey: PropertyKey.positionName)
        aCoder.encode(baseImage, forKey: PropertyKey.baseImage)
    }
}
