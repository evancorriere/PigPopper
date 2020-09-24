//
//  DynamoDBHelper.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/22/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import Foundation
import DynamoDB

public class DynamoDBHelper {
    
    private static let accessKey = "AKIAZDPKIW43E5RR3A7S"
    private static let secretKey = "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"
    private static let tableName = "leaderboard"
    
    static let leaderboardResultCount = 25
    
    
    static func validateUsername(username: String?) -> Bool {
        guard let username = username else {
            return false
        }
        
        let highscore = DataHelper.getHighscore()
        let leaderboardItem = LeaderboardItem(username: username, highscore: highscore).dynamoDBItem()

        let dynamoDB = DynamoDB(accessKeyId: accessKey, secretAccessKey: secretKey, region: .uswest1)
        let putInput = DynamoDB.PutItemInput(conditionExpression: "attribute_not_exists(username)", item: leaderboardItem, tableName: tableName)
        do {
            let _ = try dynamoDB.putItem(putInput).wait()
            UserDefaults.standard.set(username, forKey: "username")
        } catch {
            print("error with db")
            return false
        }
        return true
    }
    
    static func getLeaderboardData() -> [[String]] {
        var data: [[String]] = []
        var usernameInResponse = false
        guard let username = DataHelper.getUsername() else {
            return data
        }
        let highscore = DataHelper.getHighscore()
        
        let dynamodb = DynamoDB(accessKeyId: accessKey, secretAccessKey: secretKey, region: Region.uswest1)
        let queryInput = DynamoDB.QueryInput(
            expressionAttributeValues: [":v_hash": DynamoDB.AttributeValue(s: "gsihash")],
            indexName: "gsihash-highscore-index",
            keyConditionExpression: "gsihash = :v_hash",
            limit: leaderboardResultCount,
            scanIndexForward: false,
            tableName: self.tableName)
        do {
            let queryOutput = try dynamodb.query(queryInput).wait()
            for item in queryOutput.items! {
                data.append([item["username"]?.s ?? "error", item["highscore"]?.n ?? "-1"])
                if item["username"]?.s == username {
                    usernameInResponse = true
                }
            }
        } catch {
            print("error with query: \(error)")
            data.append(["error", "0"])
        }
        
        if !usernameInResponse {
            data.append(["...........", ""])
            data.append([username, String(highscore)])
        }
        
        return data
    }
    
    static func sendLeaderboardData() {
        let dynamodb = DynamoDB(accessKeyId: accessKey, secretAccessKey: secretKey, region: Region.uswest1)
        let username = DataHelper.getUsername()
        let highscore = DataHelper.getHighscore()
        if username != nil {
            let item = LeaderboardItem(username: username!, highscore: highscore).dynamoDBItem()
            let putInput = DynamoDB.PutItemInput(item: item, tableName: self.tableName)
            _ = dynamodb.putItem(putInput)
        }
    }
    
    
    
    
}
