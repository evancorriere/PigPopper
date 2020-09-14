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

    let accessKey = "AKIAZDPKIW43E5RR3A7S"
    let secretKey = "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"
    let tableName = "leaderboard"
    var dynamodb: DynamoDB?
    var username: String?
    var highscore: Int = 0
    var usernameInResponse = false
    
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
        dynamodb = DynamoDB(accessKeyId: accessKey, secretAccessKey: secretKey, region: Region.uswest1)
        sendLeaderboardData()
        getLeaderboardData()
        
        if let name = username, !usernameInResponse {
            data.append(["...........", ""])
            data.append([name, String(highscore)])
        }
        

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func sendLeaderboardData() {
        if username != nil {
            let item = LeaderboardItem(username: self.username!, highscore: self.highscore).dynamoDBItem()
            let putInput = DynamoDB.PutItemInput(item: item, tableName: self.tableName)
            _ = self.dynamodb!.putItem(putInput)
        }
    }
    
    func getLeaderboardData() {
        let queryInput = DynamoDB.QueryInput(
            expressionAttributeValues: [":v_hash": DynamoDB.AttributeValue(s: "gsihash")],
            indexName: "gsihash-highscore-index",
            keyConditionExpression: "gsihash = :v_hash",
            limit: 25,
            scanIndexForward: false,
            tableName: self.tableName)
        do {
            let queryOutput = try dynamodb?.query(queryInput).wait()
            for item in queryOutput!.items! {
                data.append([item["username"]?.s ?? "error", item["highscore"]?.n ?? "-1"])
                if item["username"]?.s == username {
                    self.usernameInResponse = true
                }
            }
        } catch {
            print("error with query: \(error)")
            data.append(["error", "0"])
        }
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
        cell.nameLabel.text = data[indexPath.row][0]
        cell.scoreLabel.text = data[indexPath.row][1]
        if self.usernameInResponse && data[indexPath.row][0] == self.username {
            
            print("here!!!")        }
        return cell
    }
    
    
}

