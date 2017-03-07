//
//  StoreCreditsCollectionReusableView.swift
//  FitnessApp
//
//  Created by Adam Moorey on 16/02/2017.
//  Copyright © 2017 Adam Moorey. All rights reserved.
//

import UIKit

class StoreCreditsCollectionReusableView: UICollectionReusableView
{
    @IBOutlet weak var creditsLabel: UILabel!
    
    public func updateCreditsLabel()
    {
        creditsLabel.text = "Credits: " + String(CoinsManager.totalCoins)
    }
}
