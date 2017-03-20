//
//  WorkoutTableViewController.swift
//  FitnessApp
//
//  Created by Adam Moorey on 11/11/2016.
//  Copyright © 2016 Adam Moorey. All rights reserved.
//

import UIKit
import os.log

class WorkoutTableViewController: UITableViewController
{
    // MARK: Properties
    var workouts = [Workout]()
    var timer: Timer!
    
    var achievementAlert: UIAlertController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //use the edit button item provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        //loadSampleWorkouts()
        //saveWorkouts()
        
        //load any saved workouts, otherwise load sample data
        if let savedWorkouts = loadWorkouts()
        {
            workouts += savedWorkouts
        }
        else
        {
            //load sample workouts
            loadSampleWorkouts()
        }
        
        //start off timer for the achievement check
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(checkAchieved), userInfo: nil, repeats: true)
    }
    
    func loadSampleWorkouts()
    {
        //create three basic workouts for displaying in the cells
        let image1 = UIImage(named: "Cardio")!
        let exercise1 = Exercise(name: "5 minute sprint", image: #imageLiteral(resourceName: "DefaultImage"), length: 30, exerciseDescription: "Small sprint")
        let exercise2 = Exercise(name: "30 minute long run", image: #imageLiteral(resourceName: "DefaultImage"), length: 30, exerciseDescription: "Long run")
        let exercise3 = Exercise(name: "5 minute sprint", image: #imageLiteral(resourceName: "DefaultImage"), length: 30, exerciseDescription: "Small sprint")
        let exercise4 = Exercise(name: "10 minute on/off run", image: #imageLiteral(resourceName: "DefaultImage"), length: 30, exerciseDescription: "On/off sprint")
        
        var exerciseList1 = [Exercise]()
        exerciseList1.append(exercise1!)
        exerciseList1.append(exercise2!)
        exerciseList1.append(exercise3!)
        exerciseList1.append(exercise4!)
        
        let workout1 = Workout(name: "Cardio Workout", image: image1, rating: 4, exercise: exerciseList1, identifier: "completeCardio")!
        
        let image2 = UIImage(named: "Bicep Curls")!
        let exercise5 = Exercise(name: "Bicep Curls x4", image: #imageLiteral(resourceName: "DefaultImage"), length: 30, exerciseDescription: "Four bicep curls")
        let exercise6 = Exercise(name: "Bar bicep curl x3", image: #imageLiteral(resourceName: "DefaultImage"), length: 30, exerciseDescription: "Three barbell bicep curls")
        let exercise7 = Exercise(name: "Bicep Curl to failure", image: #imageLiteral(resourceName: "DefaultImage"), length: 30, exerciseDescription: "Bicep curls until you can't")
        
        var exerciseList2 = [Exercise]()
        exerciseList2.append(exercise5!)
        exerciseList2.append(exercise6!)
        exerciseList2.append(exercise7!)
        
        let workout2 = Workout(name: "Bicep Workout", image: image2, rating: 3, exercise: exerciseList2, identifier: "completeBicep")!
        
        let image3 = UIImage(named: "Endurance Cardio")!
        let exercise8 = Exercise(name: "60 minute long run", image: #imageLiteral(resourceName: "DefaultImage"), length: 30, exerciseDescription: "Extra Long run")
        let exercise9 = Exercise(name: "60 minute cycle", image: #imageLiteral(resourceName: "DefaultImage"), length: 30, exerciseDescription: "Extra Long cycle")
        
        var exerciseList3 = [Exercise]()
        exerciseList3.append(exercise8!)
        exerciseList3.append(exercise9!)
        
        let workout3 = Workout(name: "Endurance Cardio", image: image3, rating: 3, exercise: exerciseList3, identifier: "completeEndurance")!
        
        workouts += [workout1, workout2, workout3]
    }
    
    public func checkAchieved()
    {
        if (AchievementManager.instance.completedAchievement != nil)
        {
            //display achieved popup
            achievementAlert = UIAlertController(title: "Achievement Unlocked!", message:
                "Well done, you unlocked: " + (AchievementManager.instance.completedAchievement?.name)!, preferredStyle: UIAlertControllerStyle.alert)
            
            achievementAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            present(achievementAlert, animated: true, completion: nil)
            
            AchievementManager.instance.completedAchievement = nil
            
            AchievementManager.instance.saveAchievements()
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    //function that determines how many sections to display
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        //returns 1 section within the table
        return 1
    }

    //function that determines the number of rows within the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //returns the number of workouts within the list
        return workouts.count
    }

    //used to configure which cells are displayed if there is a large number that all couldn't all be displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "WorkoutTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WorkoutTableViewCell
        
        //fetches the appropriate workout for the data source layout
        let workout = workouts[indexPath.row]
        let tempString = String(workout.exercises.count)
        
        //sets the values of the current cell to their correct list counterpart
        cell.nameLabel.text = workout.name
        cell.photoImageView.image = workout.image
        cell.ratingControl.rating = workout.rating
        cell.exerciseNumber.text = tempString + " exercises"

        return cell
    }
    
    @IBAction func unwindToWorkoutList(sender: UIStoryboardSegue)
    {
        if let sourceViewController = sender.source as? WorkoutViewController, let workout = sourceViewController.workout
        {
            //checks if the cell in the table has information in it, if so, begin edit
            if let selectedIndexPath = tableView.indexPathForSelectedRow
            {
                //update an existing workout
                workouts[selectedIndexPath.row] = workout
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
                print("workout updated")
                AchievementManager.instance.markedIdentifier = "editWorkout"
                AchievementManager.instance.checkAchievements()
            }
            else
            {
                //add a new workout
                let newIndexPath = IndexPath(row: workouts.count, section: 0)
                
                //add the workout to the list
                workouts.append(workout)
                
                //add animation to show inserted workout
                tableView.insertRows(at: [newIndexPath], with: .bottom)
                
                print("workout made")
                AchievementManager.instance.markedIdentifier = "makeWorkout"
                AchievementManager.instance.checkAchievements()
            }
            
            //save the workouts in the list
            saveWorkouts()
        }
    }
 
    //override to support conditional editing of the table view
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        //return false if you do not want the specified item to be editable
        return true
    }

    //override to support editing the table view
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            //delete the row from the data source
            workouts.remove(at: indexPath.row)
            saveWorkouts()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert
        {
            //create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    //override to support rearranging the table view
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath)
    {
        let moveItem = workouts.remove(at: fromIndexPath.row)
        workouts.insert(moveItem, at: to.row)
        saveWorkouts()
    }

    //override to support conditional rearranging of the table view
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        //return false if you do not want the item to be re-orderable
        return true
    }

    // MARK: - Navigation

    //in a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ShowDetail"
        {
            let workoutDetailViewController = segue.destination as! WorkoutViewController
            
            //get the cell that generated this segue
            if let selectedWorkoutCell = sender as? WorkoutTableViewCell
            {
                let indexPath = tableView.indexPath(for: selectedWorkoutCell)!
                let selectedWorkout = workouts[indexPath.row]
                workoutDetailViewController.workout = selectedWorkout
            }
        }
        else if segue.identifier == "AddItem"
        {
            print("Adding new workout.")
        }
    }
    
    // MARK: Private Methods
    private func saveWorkouts()
    {
        //bool that changes based on if the archive worked
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(workouts, toFile: Workout.ArchiveURL.path)
        
        //logs the appropriate response
        if isSuccessfulSave
        {
            os_log("Workouts successfully saved.", log: OSLog.default, type: .debug)
        }
        else
        {
            os_log("Failed to save workouts...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadWorkouts() -> [Workout]?
    {
        //return the array of workouts
        return NSKeyedUnarchiver.unarchiveObject(withFile: Workout.ArchiveURL.path) as? [Workout]
    }
}
