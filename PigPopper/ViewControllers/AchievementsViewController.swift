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
    @IBOutlet weak var menuButton: UIButton!
    
    // Rewards at 5, 10, 15, 25, 35, 50, 75, 100
    override func viewDidLoad() {
        super.viewDidLoad()

         // Do any additional setup after loading the view.
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
       
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.tableFooterView = UIView(frame: frame)
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
        return AchievementManager.achievements.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "achievementCell", for: indexPath) as! AchievementCell
        cell.setupWith(achievement: AchievementManager.achievements[indexPath.row])
        return cell
     }
 }
