//
//  LeaderboardItem.swift
//  PigPopper
//
//  Created by Evan Corriere on 8/19/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import Foundation
import DynamoDB

public class LeaderboardItem {
    
    var username: String
    var highscore: Int
    let gsiHashKey = "gsihash"
    
    init(username: String, highscore: Int) {
        self.username = username
        self.highscore = highscore
    }
    
    func dynamoDBItem() -> [String: DynamoDB.AttributeValue] {
        var item: [String: DynamoDB.AttributeValue] = [:]
        
        let useHighscore = DataHelper.getData(type: Bool.self, forKey: .settingsLeaderboard)!
        
        item["username"] = DynamoDB.AttributeValue(s: username)
        item["highscore"] = DynamoDB.AttributeValue(n: String(useHighscore ? self.highscore : -1))
        item["gsihash"] = DynamoDB.AttributeValue(s: gsiHashKey)
        return item
    }
    
}
