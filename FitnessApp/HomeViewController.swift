//
//  HomeViewController.swift
//  FitnessApp
//
//  Created by Adam Moorey on 10/01/2017.
//  Copyright © 2017 Adam Moorey. All rights reserved.
//

import UIKit
import os.log

class HomeViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate
{
    //MARK: Variables
    //button and label outlets
    @IBOutlet weak var selectedWorkoutLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    //variables for the home screen
    var selectedWorkout: Workout?
    var completedWorkout: Bool = false
    var timer: Timer!
    var achievementAlert: UIAlertController!
    
    let coinsManagerInstance = CoinsManager()
    let achievementManager = AchievementManager()
    
    @IBOutlet weak var testCoinsLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //change the workout label based on whether one has been selected
        if selectedWorkout == nil
        {
            self.selectedWorkoutLabel.text = String("Please select a workout...")
        }
        else
        {
            self.selectedWorkoutLabel.text = selectedWorkout?.name
        }
        
        //disable the button at the opening of the app
        startButton.isEnabled = false
        startButton.setTitleColor(UIColor.gray, for: .disabled)
        
        //RESET SAVED ACHIEVEMENTS
        achievementManager.loadStartingAchievements()
        achievementManager.saveAchievements()
        
        //load any saved achievementss, otherwise load the starting versions
        /*if let savedAchievements = achievementManager.loadAchievements()
        {
            achievementManager.achievements += savedAchievements
        }
        else
        {
            achievementManager.loadStartingAchievements()
        }*/
        
        //start off timer for the achievement check
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(checkAchieved), userInfo: nil, repeats: true)
        
        //USED FOR TESTING
        testCoinsLabel.text = "Current Coins: " + String(coinsManagerInstance.getCoins())
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        //when the view switches views using the StartWorkout segue
        //then transfer the data correctly
        if segue.identifier == "StartWorkout"
        {
            let navController = segue.destination as! UINavigationController
            let activeWorkoutController = navController.topViewController as! ActiveWorkoutViewController
            activeWorkoutController.activeWorkout = selectedWorkout
        }
    }

    @IBAction func unwindToWorkoutSelected(sender: UIStoryboardSegue)
    {
        //if the controller that activates this function is workout selection
        //then update the current workout, and enable the start of a workout
        if let sourceViewController = sender.source as? WorkoutSelectionTableViewController, let workout = sourceViewController.selectedWorkout
        {
            selectedWorkout = workout
            updateWorkout()
            startButton.isEnabled = true
        }
    }
    
    @IBAction func unwindToDeactivateWorkout(sender: UIStoryboardSegue)
    {
        if let sourceViewController = sender.source as? ActiveWorkoutViewController
        {
            //reset the current workout selected, upon completion of workout
            selectedWorkoutLabel.text = "Please select a workout..."
            startButton.isEnabled = false
            completedWorkout = sourceViewController.completed
            achievementManager.markedIdentifier = "completeWorkout"
            achievementManager.checkAchievements()
            
            achievementManager.markedIdentifier = (selectedWorkout?.achievementIdentifier)!
            achievementManager.checkAchievements()
            
            selectedWorkout = nil
        }
    }
    
    public func checkAchieved()
    {
        if (achievementManager.completedAchievement != nil)
        {
            //display achieved popup
            achievementAlert = UIAlertController(title: "Achievement Unlocked!", message:
                "Well done, you unlocked: " + (achievementManager.completedAchievement?.name)!, preferredStyle: UIAlertControllerStyle.alert)
            
            achievementAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            
            present(achievementAlert, animated: true, completion: nil)
            
            achievementManager.completedAchievement = nil
            
            //saveAchievements()
        }
    }
    
    // MARK: - Private methods
    private func updateWorkout()
    {
        selectedWorkoutLabel.text = selectedWorkout?.name
    }
    
    //MARK: TEST FUNCTIONS
    @IBAction func testRemoveCoins(_ sender: Any)
    {
        coinsManagerInstance.removeCoins(value: 10)
        testCoinsLabel.text = "Current Coins: " + String(coinsManagerInstance.getCoins())
    }
    
    @IBAction func testAddCoins(_ sender: Any)
    {
        coinsManagerInstance.addCoins(value: 15)
        testCoinsLabel.text = "Current Coins: " + String(coinsManagerInstance.getCoins())
    }
}
