//
//  AchievementManager.swift
//  FitnessApp
//
//  Created by Adam Moorey on 27/02/2017.
//  Copyright © 2017 Adam Moorey. All rights reserved.
//

import UIKit
import os.log

class AchievementManager: NSObject
{
    //arrays for storing achievements
    var achievements = [Achievement]()
    var completedAchievements = [Achievement]()
    var completedAchievement: Achievement?
    var markedIdentifier: String = ""
    
    let coinsManagerInstance = CoinsManager()
    
    // MARK: - Achievement methods
    public func checkAchievements()
    {
        //loop through all the achievements to progress next achievement
        for achievement in achievements
        {
            if (achievement.progressMarks < achievement.achieveMarks)
            {
                if (achievement.identifier == self.markedIdentifier)
                {
                    achievement.progressMarks += 1
                    self.markedIdentifier = ""
                    
                    if (achievement.progressMarks == achievement.achieveMarks)
                    {
                        completedAchievement = achievement
                        completedAchievement?.achieved = true
                        coinsManagerInstance.addCoins(value: 10)
                    }
                    saveAchievements()
                }
                
                //check progress to complete the first workout achievement
                if (achievement.identifier == "completeWorkout" && achievement.progressMarks == 1)
                {
                    for firstAchievement in achievements
                    {
                        if (firstAchievement.identifier == "firstWorkout")
                        {
                            firstAchievement.progressMarks += 1
                            completedAchievement = firstAchievement
                            coinsManagerInstance.addCoins(value: 10)
                            saveAchievements()
                        }
                    }
                }
            }
        }
    }
    
    //load the starter achievements
    func loadStartingAchievements()
    {
        let achievement1 = Achievement(name: "Just getting started!", achievementDescription: "Finish your first workout", progressMarks: 0, achieveMarks: 1, identifier: "firstWorkout")!
        let achievement2 = Achievement(name: "Getting creative", achievementDescription: "Make your own workout!", progressMarks: 0, achieveMarks: 1, identifier: "makeWorkout")!
        let achievement3 = Achievement(name: "Dedicated to fitness", achievementDescription: "Complete 30 workouts", progressMarks: 0, achieveMarks: 30, identifier: "completeWorkout")!
        let achievement4 = Achievement(name: "Tailoured workout", achievementDescription: "Edit an existing workout", progressMarks: 0, achieveMarks: 1, identifier: "editWorkout")!
        let achievement5 = Achievement(name: "Completionist", achievementDescription: "Complete every standard workout in the list", progressMarks: 0, achieveMarks: 3, identifier: "completeStandard")!
        let achievement6 = Achievement(name: "Cardio, check!", achievementDescription: "Complete a Cardio Workout", progressMarks: 0, achieveMarks: 1, identifier: "completeCardio")!
        let achievement7 = Achievement(name: "Endured", achievementDescription: "Complete a Endurance Workout", progressMarks: 0, achieveMarks: 1, identifier: "completeEndurance")!
        
        //add basic ahcievemnts to the array
        achievements += [achievement1, achievement2, achievement3, achievement4, achievement5, achievement6, achievement7]
    }
    
    //functions for the loading and saving of achievements
    public func saveAchievements()
    {
        //bool that changes based on if the archive worked
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(achievements, toFile: Achievement.ArchiveURL.path)
        
        //logs the appropriate response
        if isSuccessfulSave
        {
            os_log("Achievements successfully saved.", log: OSLog.default, type: .debug)
        }
        else
        {
            os_log("Failed to save achievements...", log: OSLog.default, type: .error)
        }
    }
    
    public func loadAchievements() -> [Achievement]?
    {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Achievement.ArchiveURL.path) as? [Achievement]
    }
    
    //functions for loading and saving completed achievements
    public func saveCompletedAchievements()
    {
        //bool that changes based on if the archive worked
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(completedAchievements, toFile: Achievement.CompletedArchiveURL.path)
        
        //logs the appropriate response
        if isSuccessfulSave
        {
            os_log("Completed achievements saved successfully.", log: OSLog.default, type: .debug)
        }
        else
        {
            os_log("Failed to save completed achievements...", log: OSLog.default, type: .error)
        }
    }
    
    public func loadCompletedAchievements() -> [Achievement]?
    {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Achievement.CompletedArchiveURL.path) as? [Achievement]
    }
}
