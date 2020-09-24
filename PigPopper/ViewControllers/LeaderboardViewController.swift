//
//  TableViewController.swift
//  PigPopper
//
//  Created by Evan Corriere on 8/17/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import UIKit
import DynamoDB
import NIO

class LeaderboardViewController: UIViewController {

    var username: String?
    var highscore: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    var data: [[String]] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username = UserDefaults.standard.string(forKey: "username")
        highscore = UserDefaults.standard.integer(forKey: "highScore")
        data = DynamoDBHelper.getLeaderboardData()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension LeaderboardViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
}

extension LeaderboardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ScoreboardCell
        
        
        
        if indexPath.row < DynamoDBHelper.leaderboardResultCount{
            cell.nameLabel.text = "\(indexPath.row + 1). " + data[indexPath.row][0]
        } else {
            cell.nameLabel.text = data[indexPath.row][0]
        }
        
        cell.scoreLabel.text = data[indexPath.row][1]
        return cell
    }
    
    
}

