//
//  StoreCollectionViewController.swift
//  FitnessApp
//
//  Created by Adam Moorey on 16/02/2017.
//  Copyright © 2017 Adam Moorey. All rights reserved.
//

import UIKit
import os.log

class StoreCollectionViewController: UICollectionViewController
{
    let reuseIdentifier = "StoreCell"
    
    //array to store store objects
    var storeObjects = [StoreObject]()
    
    let coinsManagerInstance = CoinsManager()
    var selectedObject: StoreObject!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        if let savedObjects = loadObjects()
        {
            storeObjects += savedObjects
        }
        else
        {
            loadStoreObjects()
        }
    }
    
    func loadStoreObjects()
    {
        let image1 = UIImage(named: "Jail")!
        let storeObject1 = StoreObject(unlocked: false, cost: 20, itemIdentifier: "Jail", image: image1)!
        
        let image2 = UIImage(named: "Garage")!
        let storeObject2 = StoreObject(unlocked: false, cost: 30, itemIdentifier: "Garage", image: image2)!
        
        let image3 = UIImage(named: "Workshop")!
        let storeObject3 = StoreObject(unlocked: false, cost: 50, itemIdentifier: "Workshop", image: image3)!
        
        let image4 = UIImage(named: "StockStoreImage")!
        let storeObject4 = StoreObject(unlocked: false, cost: 15, itemIdentifier: "Barracks", image: image4)!
        
        let image5 = UIImage(named: "StockStoreImage")!
        let storeObject5 = StoreObject(unlocked: false, cost: 10, itemIdentifier: "FoodStall", image: image5)!
        
        storeObjects += [storeObject1, storeObject2, storeObject3, storeObject4, storeObject5]
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
    }*/

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return storeObjects.count
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StoreCollectionViewCell
        
        var label: String = ""
        
        if (!storeObjects[indexPath.row].unlocked)
        {
            label = String(storeObjects[indexPath.row].cost) + " coins"
        }
        else
        {
            label = "Item Unlocked! Click to place object!"
        }
        
        //sets the values of the current cell to their correct array counterpart
        cell.objectImage.image = storeObjects[indexPath.row].objectImage
        cell.costLabel.text = label
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool
    {
        let selectedObject = storeObjects[indexPath.row]
        
        if (!selectedObject.unlocked)
        {
            if (coinsManagerInstance.getCoins() >= selectedObject.cost)
            {
                //changes unlocked bool and the total coins
                storeObjects[indexPath.row].unlocked = true
                coinsManagerInstance.removeCoins(value: storeObjects[indexPath.row].cost)
                
                saveObjects()
                
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
            self.selectedObject = selectedObject
            self.performSegue(withIdentifier: "unwindToPlaceObject", sender: self)
            
            return true
        }
    }
    
    @IBAction func cancel(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    // MARK: Private Methods
    private func saveObjects()
    {
        //bool that changes based on if the archive worked
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(storeObjects, toFile: StoreObject.ArchiveURL.path)
        
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
    
    private func loadObjects() -> [StoreObject]?
    {
        //return the array of workouts
        return NSKeyedUnarchiver.unarchiveObject(withFile: StoreObject.ArchiveURL.path) as? [StoreObject]
    }
}
