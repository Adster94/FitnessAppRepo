//
//  CoinsManager.swift
//  FitnessApp
//
//  Created by Adam Moorey on 15/02/2017.
//  Copyright © 2017 Adam Moorey. All rights reserved.
//

import UIKit

public class CoinsManager: NSObject
{
    static let instance = CoinsManager()
    
    //MARK: Saving coins
    static let userDefaults = UserDefaults.standard
    static let totalCoinsKey = "TotalCoins"
    static var totalCoins: Int
    {
        get
        {
            return userDefaults.integer(forKey: totalCoinsKey)
        }
        
        set(value)
        {
            userDefaults.setValue(value, forKey: totalCoinsKey)
        }
    }
    
    public func addCoins(value: Int)
    {
        CoinsManager.totalCoins += value
    }
    
    public func removeCoins(value: Int)
    {
        CoinsManager.totalCoins -= value
    }
    
    public func getCoins() -> Int
    {
        return CoinsManager.totalCoins
    }
}
