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
        
        if (achievement.achieved)
        {
            cell.backgroundColor = UIColor.green
        }
        else
        {
            cell.backgroundColor = UIColor.clear
        }

        return cell
    }
    
    func update()
    {
        achievements = achievementManager.loadAchievements()!
        self.tableView.reloadData()
    }
}
