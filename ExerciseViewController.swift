//
//  ExerciseViewController.swift
//  FitnessApp
//
//  Created by Adam Moorey on 16/12/2016.
//  Copyright © 2016 Adam Moorey. All rights reserved.
//

import UIKit
import os.log

class ExerciseViewController: UIViewController, UITextFieldDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //outlets for the labels and fields for changing variables
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var exercise: Exercise?
    let imagePickerController = UIImagePickerController()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        descriptionField.delegate = self
        lengthTextField.delegate = self
        imagePickerController.delegate = self
        
        //update the UI for the exercise scene, with the loaded exercise
        if let exercise = exercise
        {            
            navigationItem.title = exercise.name
            nameTextField.text = exercise.name
            descriptionField.text = exercise.exerciseDescription
            lengthTextField.text = String(exercise.length)
            photoImageView.image = exercise.image
        }
        
        checkValidExerciseName()
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
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        //check the name isn't empty and change the label accordingly
        checkValidExerciseName()
        exerciseNameLabel.text = nameTextField.text
    }
    
    func checkValidExerciseName()
    {
        //disable the Save button if the text fields is empty
        let text = nameTextField.text ?? ""
        let description = descriptionField.text ?? ""
        
        saveButton.isEnabled = !text.isEmpty && !description.isEmpty && checkInteger(lengthTextField: lengthTextField)
    }
    
    func checkInteger(lengthTextField: UITextField) -> Bool
    {
        //check whether the input field is only numbers
        if Int(lengthTextField.text!) != nil
        {
            return true
        }
        else
        {
            return false
        }
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        //when save button pressed, configure view controller
        guard let button = sender as? UIBarButtonItem, button === saveButton
        else
        {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        //exercise name to be passed to ExerciseTableViewController after the unwind segue
        let name = nameTextField.text ?? ""
        let tempDescription = descriptionField.text ?? ""
        let tempLength = Int(lengthTextField.text ?? "")
        let tempImage = photoImageView.image
        
        exercise = Exercise(name: name, image: tempImage!, length: tempLength!, exerciseDescription: tempDescription)
    }
    
    // MARK: - Actions
    @IBAction func selectImage(_ sender: UITapGestureRecognizer)
    {
        //hide the keyboard
        nameTextField.resignFirstResponder()
        
        //make sure images come from library, not camera
        imagePickerController.sourceType = .photoLibrary
        
        //view controller is notified when an image is selected
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem)
    {
        //check that the sender is the navigation controller
        let isPresentingInAddWorkoutMode = presentingViewController is UINavigationController
        
        //if this is true then dismiss correctly
        if (isPresentingInAddWorkoutMode)
        {
            dismiss(animated: true, completion: nil)
        }
        else
        {
            navigationController!.popViewController(animated: true)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
