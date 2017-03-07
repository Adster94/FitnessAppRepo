//
//  Workout.swift
//  FitnessApp
//
//  Created by Adam Moorey on 10/11/2016.
//  Copyright © 2016 Adam Moorey. All rights reserved.
//

import UIKit
import os.log

class Workout: NSObject, NSCoding
{
    // MARK: Properties
    var name: String
    var image: UIImage?
    var rating: Int
    //var exercises = [Exercise]()
    var exercises = [String]()
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("workouts")
    
    // MARK: Types
    struct PropertyKey
    {
        static let name = "name"
        static let image = "image"
        static let rating = "rating"
        static let exercises = "exercises"
    }
    
    // MARK: Initilisation
    //init?(name: String, image: UIImage?, rating: Int, exercise: [Exercise])
    init?(name: String, image: UIImage?, rating: Int, exercise: [String])
    {
        //the name must not be empty
        guard !name.isEmpty else
        {
            return nil
        }
        
        //the rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else
        {
            return nil
        }
        
        //initialise the stored values
        self.name = name
        self.image = image
        self.rating = rating
        self.exercises = exercise
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        //the name is required. If we cannot decode a name string, the initializer should fail
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
            else
        {
            os_log("Unable to decode the name for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        //because photo is an optional property of Meal, just use conditional cast
        let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        //let exercises = aDecoder.decodeObject(forKey: PropertyKey.exercises) as! [Exercise]
        let exercises = aDecoder.decodeObject(forKey: PropertyKey.exercises) as! [String]
        
        //must call designated initializer
        self.init(name: name, image: image, rating: rating, exercise: exercises)
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(image, forKey: PropertyKey.image)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(exercises, forKey: PropertyKey.exercises)
    }
}
