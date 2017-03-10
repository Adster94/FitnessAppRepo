//
//  Exercise.swift
//  FitnessApp
//
//  Created by Adam Moorey on 16/12/2016.
//  Copyright © 2016 Adam Moorey. All rights reserved.
//

import UIKit

public class Exercise
{
    // MARK: Properties
    var name: String
    
    // MARK: Initialization
    init?(name: String)
    {
        //the name must not be empty
        guard !name.isEmpty else
        {
            return nil
        }
        
        self.name = name
    }
}
