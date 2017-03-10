//
//  Exercise.swift
//  FitnessApp
//
//  Created by Adam Moorey on 16/12/2016.
//  Copyright © 2016 Adam Moorey. All rights reserved.
//

import UIKit
import os.log

public class Exercise: NSObject, NSCoding
{
    // MARK: Properties
    var name: String
    var image: UIImage
    var length: Int
    var exerciseDescription: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("exercises")
    
    // MARK: Types
    struct PropertyKey
    {
        static let name = "name"
        static let image = "image"
        static let length = "length"
        static let description = "description"
    }
    
    // MARK: Initialization
    init?(name: String, image: UIImage, length: Int, exerciseDescription: String)
    {
        //the name must not be empty
        guard !name.isEmpty else
        {
            print ("Error: Name is empty.")
            return nil
        }
        
        guard length > 0 else
        {
            print ("Error: Exercise has no length.")
            return nil
        }
        
        self.name = name
        self.image = image
        self.length = length
        self.exerciseDescription = exerciseDescription
    }
    
    required convenience public init?(coder aDecoder: NSCoder)
    {
        //the name is required. If we cannot decode a name string, the initializer should fail
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
            else
        {
            os_log("Unable to decode the name for a Exercise object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        //because photo is an optional property of exercise, just use conditional cast
        let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage
        
        let length = aDecoder.decodeInteger(forKey: PropertyKey.length)
        
        let description = aDecoder.decodeObject(forKey: PropertyKey.description) as! String
        
        //must call designated initializer
        self.init(name: name, image: image!, length: length, exerciseDescription: description)
    }
    
    // MARK: NSCoding
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(image, forKey: PropertyKey.image)
        aCoder.encode(length, forKey: PropertyKey.length)
        aCoder.encode(exerciseDescription, forKey: PropertyKey.description)
    }
}
