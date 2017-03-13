//
//  StoreCollectionViewController.swift
//  FitnessApp
//
//  Created by Adam Moorey on 16/02/2017.
//  Copyright © 2017 Adam Moorey. All rights reserved.
//

import UIKit
import os.log

class BuildingsCollectionViewController: UICollectionViewController
{
    let reuseIdentifier = "StoreCell"
    
    //array to store store objects
    var storeBuildings = [BuildingObject]()
    
    let coinsManagerInstance = CoinsManager()
    var selectedBuilding: BuildingObject!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        if let savedObjects = loadBuildings()
        {
            storeBuildings += savedObjects
        }
        else
        {
            loadStoreObjects()
        }
    }
    
    func loadStoreObjects()
    {
        let image1 = UIImage(named: "Jail")!
        let storeObject1 = BuildingObject(unlocked: false, cost: 20, itemIdentifier: "Jail", image: image1)!
        
        let image2 = UIImage(named: "Garage")!
        let storeObject2 = BuildingObject(unlocked: false, cost: 30, itemIdentifier: "Garage", image: image2)!
        
        let image3 = UIImage(named: "Workshop")!
        let storeObject3 = BuildingObject(unlocked: false, cost: 50, itemIdentifier: "Workshop", image: image3)!
        
        let image4 = UIImage(named: "StockStoreImage")!
        let storeObject4 = BuildingObject(unlocked: false, cost: 15, itemIdentifier: "Barracks", image: image4)!
        
        let image5 = UIImage(named: "StockStoreImage")!
        let storeObject5 = BuildingObject(unlocked: false, cost: 10, itemIdentifier: "FoodStall", image: image5)!
        
        storeBuildings += [storeObject1, storeObject2, storeObject3, storeObject4, storeObject5]
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return storeBuildings.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind type: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        switch type
        {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: type, withReuseIdentifier: "CreditsBar", for: indexPath) as! StoreCreditsCollectionReusableView
            
            headerView.creditsLabel.text = "Credits: " + String(coinsManagerInstance.getCoins())
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BuildingsCollectionViewCell
        
        var label: String = ""
        
        if (!storeBuildings[indexPath.row].unlocked)
        {
            label = String(storeBuildings[indexPath.row].cost) + " coins"
        }
        else
        {
            label = "Item Unlocked! Click to place object!"
        }
        
        //sets the values of the current cell to their correct array counterpart
        cell.objectImage.image = storeBuildings[indexPath.row].objectImage
        cell.costLabel.text = label
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    //uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool
    {
        let selectedObject = storeBuildings[indexPath.row]
        
        if (!selectedObject.unlocked)
        {
            if (coinsManagerInstance.getCoins() >= selectedObject.cost)
            {
                //changes unlocked bool and the total coins
                storeBuildings[indexPath.row].unlocked = true
                coinsManagerInstance.removeCoins(value: storeBuildings[indexPath.row].cost)
                
                saveBuildings()
                
                //display alert to confirm purchase
                let purchaseAlert = UIAlertController(title: "Item Unlocked!", message:
                    "You have now unlocked the item, press it again to place it in your base.", preferredStyle: UIAlertControllerStyle.alert)
                
                purchaseAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                
                present(purchaseAlert, animated: true, completion: nil)
                
                return true
            }
            else
            {
                //display alert for not enough coins to buy
                let coinsAlert = UIAlertController(title: "Not enough money!", message:
                    "Earn more coins to buy this item. You need " + String(selectedObject.cost - coinsManagerInstance.getCoins()) + " coins!", preferredStyle: UIAlertControllerStyle.alert)
                
                coinsAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                
                present(coinsAlert, animated: true, completion: nil)
                
                return true
            }
        }
        else
        {
            self.selectedBuilding = selectedObject
            self.performSegue(withIdentifier: "unwindToPlaceObject", sender: self)
            
            return true
        }
    }
    
    @IBAction func cancel(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Private Methods
    private func saveBuildings()
    {
        //bool that changes based on if the archive worked
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(storeBuildings, toFile: BuildingObject.ArchiveURL.path)
        
        //logs the appropriate response
        if isSuccessfulSave
        {
            os_log("Store objects successfully saved.", log: OSLog.default, type: .debug)
        }
        else
        {
            os_log("Failed to save store objects...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadBuildings() -> [BuildingObject]?
    {
        //return the array of workouts
        return NSKeyedUnarchiver.unarchiveObject(withFile: BuildingObject.ArchiveURL.path) as? [BuildingObject]
    }
}
