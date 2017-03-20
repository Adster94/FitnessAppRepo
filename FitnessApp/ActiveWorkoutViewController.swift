//
//  ActiveWorkoutViewController.swift
//  FitnessApp
//
//  Created by Adam Moorey on 11/01/2017.
//  Copyright © 2017 Adam Moorey. All rights reserved.
//

import UIKit

class ActiveWorkoutViewController: UIViewController
{
    //UI outlets for updating data
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var currentExercise: UILabel!
    @IBOutlet weak var countingLabel: UILabel!
    @IBOutlet weak var completedView: UIView!
    @IBOutlet weak var currentDescription: UILabel!
    @IBOutlet weak var exerciseImage: UIImageView!
    
    var activeWorkout: Workout?
    
    //variables for exercise timing and workout routine
    var timer: Timer!
    var counter: Int = 0
    var exerciseCounter: Int = 0
    var exerciseFlag: Bool = true
    var exerciseNumber: Int = 0
    var completed: Bool = false
    var started: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        countingLabel.text = String(counter)
        
        self.view.addSubview(completedView)
        completedView.layer.cornerRadius = 8.0
        completedView.isHidden = true
        
        //make sure the active workout isn't empty
        if activeWorkout != nil
        {
            workoutName.text = activeWorkout?.name
            exerciseNumber = (activeWorkout?.exercises.count)!
        }
        else
        {
            workoutName.text = "Workout is empty..."
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func updateCounter()
    {
        //decrement the countdown
        counter -= 1
        countingLabel.text = String(counter)
        
        //when countdown is at 0, change exercise or endworkout
        if (counter <= 0)
        {
            counter = 0
            
            if (exerciseFlag)
            {
                exerciseCounter += 1
            }
            
            //flip the exerciseflag bool
            exerciseFlag = !exerciseFlag
            
            if (exerciseCounter < exerciseNumber)
            {
                startWorkout()
            }
            else
            {
                endWorkout()
            }
        }
    }
    
    func startWorkout()
    {
        //switch between exercises and rest periods
        if (exerciseFlag)
        {
            let activeExercise = activeWorkout?.exercises[exerciseCounter]
            counter = (activeExercise?.length)!
            
            currentExercise.text = activeExercise?.name
            currentDescription.text = activeExercise?.exerciseDescription
            exerciseImage.image = activeExercise?.image
        }
        else
        {
            counter = 5
            currentExercise.text = "Rest period"
        }
    }
    
    func endWorkout()
    {
        //end the workout and reset all values
        timer.invalidate()
        counter = 0
        countingLabel.text = String(counter)
        currentExercise.text = "Workout complete"
        exerciseImage.image = nil
        activeWorkout = nil
        completed = true
        
        //show the exit popup
        self.view.backgroundColor = UIColor.gray
        completedView.isHidden = false
    }
    
    // MARK: Actions
    @IBAction func playButton(_ sender: Any)
    {
        //if the timer hasn't already started then start
        if (started == false)
        {
            //start timer if a activeworkout is present
            if (activeWorkout != nil)
            {
                timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
                started = true
                startWorkout()
            }
            else
            {
                currentExercise.text = "No workout selected"
            }
        }
        else
        {
            timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func pauseButton(_ sender: Any)
    {
        timer.invalidate()
    }
    
    @IBAction func resetButton(_ sender: Any)
    {
        timer.invalidate()
        counter = 0
        countingLabel.text = String(counter)
    }
    
    // MARK: - Manual Segue Activation
    @IBAction func exitButton(_ sender: Any)
    {
        self.performSegue(withIdentifier: "unwindToDeactiveWorkout", sender: self)
    }
    
    @IBAction func cancelButton(_ sender: Any)
    {
        self.performSegue(withIdentifier: "unwindToDeactiveWorkout", sender: self)
    }
}
