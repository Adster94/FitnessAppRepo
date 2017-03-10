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
    var completedAchievement: Achievement?
    var markedIdentifier: String = ""
    var achievementReward: Int = 25
    
    let coinsManagerInstance = CoinsManager()
    
    // MARK: - Achievement methods
    public func checkAchievements()
    {
        //loop through all the achievements to progress next achievement
        for achievement in achievements
        {
            print(self.markedIdentifier + " is the marked identifier (loop print)")
            if (achievement.progressMarks < achievement.achieveMarks)
            {
                if (achievement.identifier == self.markedIdentifier && (achievement.identifier == "completeCardio" || achievement.identifier == "completeBicep" || achievement.identifier == "completeEndurance"))
                {
                    //call check on standard achievement completion
                    standardCompletion(achievement: achievement)
                }
                
                print(self.markedIdentifier + " is the marked identifier")
                if (achievement.identifier == self.markedIdentifier)
                {
                    print(achievement.identifier + " has been progressed")
                    achievement.progressMarks += 1
                    self.markedIdentifier = ""
                    
                    if (achievement.progressMarks == achievement.achieveMarks)
                    {
                        achievement.achieved = true
                        completedAchievement = achievement
                        coinsManagerInstance.addCoins(value: achievementReward)
                    }
                    saveAchievements()
                }
                
                //check progress to complete the first workout achievement
                if (achievement.identifier == "completeWorkout" && achievement.progressMarks == 1)
                {
                    for firstAchievement in achievements
                    {
                        if (firstAchievement.identifier == "firstWorkout" && firstAchievement.progressMarks < 1)
                        {
                            firstAchievement.progressMarks += 1
                            completedAchievement = firstAchievement
                            coinsManagerInstance.addCoins(value: achievementReward)
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
        let achievement8 = Achievement(name: "Hercules", achievementDescription: "Complete a Bicep Workout", progressMarks: 0, achieveMarks: 1, identifier: "completeBicep")!
        
        //add basic ahcievemnts to the array
        achievements += [achievement1, achievement2, achievement3, achievement4, achievement5, achievement6, achievement7, achievement8]
    }
    
    func standardCompletion(achievement: Achievement)
    {
        //check progress for the standard completion achievement
        if (achievement.identifier == "completeCardio" && !achievement.achieved)
        {
            for standardAchievement in achievements
            {
                if (standardAchievement.identifier == "completeStandard")
                {
                    standardAchievement.progressMarks += 1
                }
            }
        }
        
        if (achievement.identifier == "completeBicep" && !achievement.achieved)
        {
            for standardAchievement in achievements
            {
                if (standardAchievement.identifier == "completeStandard")
                {
                    standardAchievement.progressMarks += 1
                }
            }
        }
        
        if (achievement.identifier == "completeEndurance" && !achievement.achieved)
        {
            for standardAchievement in achievements
            {
                if (standardAchievement.identifier == "completeStandard")
                {
                    standardAchievement.progressMarks += 1
                }
            }
        }
        
        for standardAchievement in achievements
        {
            if (standardAchievement.progressMarks == standardAchievement.achieveMarks)
            {
                standardAchievement.achieved = true
                coinsManagerInstance.addCoins(value: achievementReward)
                completedAchievement = standardAchievement
            }
        }
        
        saveAchievements()
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
}
