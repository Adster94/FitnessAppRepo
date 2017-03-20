//
//  WorkoutViewController.swift
//  TestApp2
//
//  Created by Adam Moorey on 28/10/2016.
//  Copyright © 2016 Adam Moorey. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController, UITextFieldDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    // MARK: Properties
    @IBOutlet weak var inputNameField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var exerciseButton: UIButton!
    @IBOutlet weak var exerciseNumberLabel: UILabel!
    
    //variables for workout details
    var workout: Workout?
    var exercises = [Exercise]()
    var achievementIdentifier: String = ""
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //handle the text field's input through delegate callbacks
        inputNameField.delegate = self
        imagePickerController.delegate = self
        
        //update the UI for the workout scene, with the loaded workout
        if let workout = workout
        {
            navigationItem.title = workout.name
            inputNameField.text = workout.name
            photoImageView.image = workout.image
            ratingControl.rating = workout.rating
            exercises = workout.exercises
            achievementIdentifier = workout.achievementIdentifier
            exerciseNumberLabel.text = String(workout.exercises.count)  + " exercises"
        }
        
        //enable the Save button only if the text field has a valid workout name
        checkValidWorkoutName()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        //hide the keyboard
        textField.resignFirstResponder()
        
        //when user hits Return, the keyboard should respond by hiding
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        //disable the Save button while editing
        saveButton.isEnabled = false
    }
    
    func checkValidWorkoutName()
    {
        //disable the Save button if the text field is empty.
        let text = inputNameField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        //calls check and changes the title accordingly
        checkValidWorkoutName()
        navigationItem.title = textField.text
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        //dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //set photoImageView to display the selected image and fit aspect
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.image = selectedImage
        
        //dismiss image picker
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //downcast required as Any? and UIBarButtonItem can't be compared
        if let barButton = sender as? UIBarButtonItem
        {
            if saveButton == barButton
            {
                let name = inputNameField.text ?? ""
                let image = photoImageView.image
                let rating = ratingControl.rating
                let exerciseList = exercises
                let identifier = achievementIdentifier
                
                //set the workout to be passed to WorkoutTableViewController after the unwind segue.
                workout = Workout(name: name, image: image, rating: rating, exercise: exerciseList, identifier: identifier)
            }
        }
        
        //transfer exercise data to the view for displaying correctly
        if segue.identifier == "ViewExercises"
        {
            let navController = segue.destination as! UINavigationController
            let exerciseController = navController.topViewController as! ExerciseTableViewController
            exerciseController.exercises = exercises
        }
    }
    
    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer)
    {
        //hide the keyboard
        inputNameField.resignFirstResponder()
        
        //make sure images come from library, not camera
        imagePickerController.sourceType = .photoLibrary
        
        //view controller is notified when an image is selected
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToExerciseListUpdate(sender: UIStoryboardSegue)
    {
        //update exercise table when leaving adding exercise screen
        if let sourceViewController = sender.source as? ExerciseTableViewController
        {
            let exerciseList = sourceViewController.exercises
            exercises = exerciseList
            updateExerciseLabel()
        }
    }
    
    //MARK: Private Methods
    private func updateExerciseLabel()
    {
        exerciseNumberLabel.text = String(exercises.count) + " exercises"
    }
}
