//
//  AchievementsViewController.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/10/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    let achievements: [Achievement] = [ Achievement(rank: "Rookie", score: 5, reward: "one"),
                                        Achievement(rank: "Piggy", score: 10, reward: "two"),
                                        Achievement(rank: "Oinker", score: 15, reward: "three"),
                                        Achievement(rank: "PIG", score: 20, reward: "four"),
                                        Achievement(rank: "Farmer", score: 25, reward: "five"),
                                        Achievement(rank: "Agricultural Scientist", score: 30, reward: "six"),
                                        Achievement(rank: "God", score: 100, reward: "seven")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

         // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
       
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
    
extension AchievementsViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
}

 extension AchievementsViewController: UITableViewDataSource {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievements.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "achievementCell", for: indexPath) as! AchievementCell
        cell.setupWith(achievement: achievements[indexPath.row])
        return cell
     }
 }
