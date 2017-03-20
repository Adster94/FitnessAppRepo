//
//  WorkoutSelectionTableViewController.swift
//  FitnessApp
//
//  Created by Adam Moorey on 11/01/2017.
//  Copyright © 2017 Adam Moorey. All rights reserved.
//

import UIKit
import os.log

class WorkoutSelectionTableViewController: UITableViewController
{
    var workouts = [Workout]()
    var selectedWorkout: Workout?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        //returns 1 section within the table
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //returns the number of workouts within the list
        return workouts.count
    }

    
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

    // MARK: - Navigation

    //in a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        //get the cell that generated this segue
        if let selectedWorkoutCell = sender as? WorkoutTableViewCell
        {
            let indexPath = tableView.indexPath(for: selectedWorkoutCell)!
            let chosenWorkout = workouts[indexPath.row]
            selectedWorkout = chosenWorkout
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private Methods
    private func loadWorkouts() -> [Workout]?
    {
        //return the array of workouts
        return NSKeyedUnarchiver.unarchiveObject(withFile: Workout.ArchiveURL.path) as? [Workout]
    }
}
