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
        item["username"] = DynamoDB.AttributeValue(s: username)
        item["highscore"] = DynamoDB.AttributeValue(n: String(highscore))
        item["gsihash"] = DynamoDB.AttributeValue(s: gsiHashKey)
        return item
    }
    
}
