//
//  ExerciseTableViewController.swift
//  FitnessApp
//
//  Created by Adam Moorey on 16/12/2016.
//  Copyright © 2016 Adam Moorey. All rights reserved.
//

import UIKit

class ExerciseTableViewController: UITableViewController
{
    // MARK: Properties
    //var exercises = [Exercise]()
    var exercises = [String]()
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems?.append(editButtonItem)
        
        if exercises.isEmpty
        {
           loadSampleExercises()
        }
    }
    
    func loadSampleExercises()
    {
        /*let name1 = "Basic muscle exercise 1"
        let name2 = "Bicep curls exercise"
        let name3 = "Basic muscle exercise 2"
        
        let exercise1 = Exercise(name: name1)
        let exercise2 = Exercise(name: name2)
        let exercise3 = Exercise(name: name3)
        
        exercises.append(exercise1!)
        exercises.append(exercise2!)
        exercises.append(exercise3!)*/
        
        let exercise1 = "Basic muscle exercise 1"
        let exercise2 = "Bicep curls exercise"
        let exercise3 = "Basic msucle exercise 2"
        
        exercises.append(exercise1)
        exercises.append(exercise2)
        exercises.append(exercise3)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return exercises.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "ExerciseTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ExerciseTableViewCell else {
            fatalError("The dequeued cell is not an instance of ExerciseTableViewCell.")
        }
        
        let name = exercises[indexPath.row]
        
        cell.exerciseNameLabel.text = name
        
        return cell
    }

    //override to support editing the table view
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            //delete the row from the data source
            exercises.remove(at: indexPath.row)
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
        let moveItem = exercises.remove(at: fromIndexPath.row)
        exercises.insert(moveItem, at: to.row)
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
        if let barButton = sender as? UIBarButtonItem
        {
            if cancelButton == barButton
            {
                let controller = segue.destination as? WorkoutViewController
                controller?.exercises = exercises
            }
        }
    }
    
    // MARK: Actions
    @IBAction func unwindToExerciseList(sender: UIStoryboardSegue)
    {
        if let sourceViewController = sender.source as? ExerciseViewController, let exercise = sourceViewController.exercise
        {
            //add a new exercise
            let newIndexPath = IndexPath(row: exercises.count, section: 0)
            
            exercises.append(exercise)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}
