//
//  Achievement.swift
//  FitnessApp
//
//  Created by Adam Moorey on 07/02/2017.
//  Copyright © 2017 Adam Moorey. All rights reserved.
//

import UIKit

class Achievement: NSObject, NSCoding
{
    // MARK: Properties
    var name: String
    var achievementDescription: String
    var progressMarks: Int
    var achieveMarks: Int
    var identifier: String
    var achieved: Bool
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("achievements")
    static let CompletedArchiveURL = DocumentsDirectory.appendingPathComponent("completedAchievements")
    
    // MARK: Types
    struct PropertyKey
    {
        static let name = "name"
        static let achievementDescription = "achievementDescription"
        static let progressMarks = "progressMarks"
        static let achieveMarks = "achieveMarks"
        static let identifier = "identifier"
        static let achieved = "achieved"
    }
    
    // MARK: Initialization    
    init?(name: String, achievementDescription: String, progressMarks: Int, achieveMarks: Int, identifier: String)
    {
        //the name must not be empty
        guard !name.isEmpty else
        {
            return nil
        }
        
        //the description must not be empty
        guard !achievementDescription.isEmpty else
        {
            return nil
        }
        
        //make sure the achieve marks is more than 0
        guard achieveMarks > 0 else
        {
            return nil
        }
        
        //make sure the progress marks is more than or equal to 0
        guard progressMarks >= 0 else
        {
            return nil
        }
        
        guard !identifier.isEmpty else
        {
            return nil
        }
        
        self.name = name
        self.achievementDescription = achievementDescription
        self.progressMarks = progressMarks
        self.achieveMarks = achieveMarks
        self.identifier = identifier
        
        if (progressMarks >= achieveMarks)
        {
            self.achieved = true
        }
        else
        {
            self.achieved = false
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let name = aDecoder.decodeObject(forKey: PropertyKey.name) as! String
        let description = aDecoder.decodeObject(forKey: PropertyKey.achievementDescription) as! String
        let progressMarks = aDecoder.decodeInteger(forKey: PropertyKey.progressMarks)
        let achieveMarks = aDecoder.decodeInteger(forKey: PropertyKey.achieveMarks)
        let identifier = aDecoder.decodeObject(forKey: PropertyKey.identifier) as! String
        
        //must call designated initializer
        self.init(name: name, achievementDescription: description, progressMarks: progressMarks, achieveMarks: achieveMarks, identifier: identifier)
    }
    
    // MARK: NSCoding
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(achievementDescription, forKey: PropertyKey.achievementDescription)
        aCoder.encode(progressMarks, forKey: PropertyKey.progressMarks)
        aCoder.encode(achieveMarks, forKey: PropertyKey.achieveMarks)
        aCoder.encode(identifier, forKey: PropertyKey.identifier)
        aCoder.encode(achieved, forKey: PropertyKey.achieved)
    }
}
