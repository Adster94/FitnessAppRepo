//
//  TestApp2Tests.swift
//  TestApp2Tests
//
//  Created by Adam Moorey on 28/10/2016.
//  Copyright © 2016 Adam Moorey. All rights reserved.
//

import XCTest
@testable import FitnessApp

class FitnessAppTests: XCTestCase
{
    // MARK: FitnessApp Tests
    
    //tests to confirm that the Workout initialiser returns when no name or a negative rating is provided.
    func testWorkoutInitialization()
    {
        // Success case.
        let potentialItem = Workout(name: "Newest workout", image: nil, rating: 5)
        XCTAssertNotNil(potentialItem)
        
        // Failure cases.
        let noName = Workout(name: "", image: nil, rating: 0)
        XCTAssertNil(noName, "Empty name is invalid")
        
        let badRating = Workout(name: "Failed Rating", image: nil, rating: -1)
        XCTAssertNil(badRating, "Negative ratings are invalid")
    }
}
