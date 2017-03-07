//
//  AchievementTableViewController.swift
//  FitnessApp
//
//  Created by Adam Moorey on 07/02/2017.
//  Copyright © 2017 Adam Moorey. All rights reserved.
//

import UIKit
import os.log

class AchievementTableViewController: UITableViewController
{
    var achievements = [Achievement]()
    var timer: Timer!
    
    let achievementManager = AchievementManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 90.0
        
        //let tabBarControllers = self.tabBarController?.viewControllers
        //let loadedAchievements = tabBarControllers![0] as! HomeViewController
        achievements = achievementManager.loadAchievements()!
        
        //start off timer for the achievement check
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(update), userInfo: nil, repeats: true)
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
        return achievements.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //update all of the achievement cell information, so long as the identifier matches
        let cellIdentifier = "AchievementCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AchievementTableViewCell
        
        let achievement = achievements[indexPath.row]
        
        cell.nameLabel.text = achievement.name
        cell.descriptionLabel.text = achievement.achievementDescription
        cell.progressLabel.text = "Progress: " + String(achievement.progressMarks) + "/" + String(achievement.achieveMarks)

        return cell
    }
    
    func update()
    {
        achievements = achievementManager.loadAchievements()!
        
        self.tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
