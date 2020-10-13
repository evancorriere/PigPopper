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
    private static let gsiHashKey = "gsihash"
    
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
        if !DataHelper.getData(type: Bool.self, forKey: .settingsLeaderboard)! {
            return
        }
        
        let dynamodb = DynamoDB(accessKeyId: accessKey, secretAccessKey: secretKey, region: Region.uswest1)
        let username = DataHelper.getUsername()
        let highscore = DataHelper.getHighscore()
        if username != nil {
            let item = LeaderboardItem(username: username!, highscore: highscore).dynamoDBItem()
            let putInput = DynamoDB.PutItemInput(item: item, tableName: self.tableName)
            do {
                _ = try dynamodb.putItem(putInput).wait()
            } catch {
                print("error sending: \(error)")
            }
        }
    }
    
    static func deleteLeaderboardData() {
        // Currently setting score to -1 to make sure username stays reserved
        // by changing the participation setting, this will be handled
        // automatically by sendLeaderboardData
        sendLeaderboardData()
    }
    
    
    static func updateUsername(newUsername: String?) -> Bool {
        // check if available, upload highscore.
        // on success, delete old name
        
        let currentUsername = DataHelper.getUsername()
        if newUsername == currentUsername {
            return true
        }
        
        if currentUsername == nil {
            // first time settings up
            return validateUsername(username: newUsername)
        }
        
        let hasNewUsername = validateUsername(username: newUsername)
        if hasNewUsername {
            // delete old one
            let dynamodb = DynamoDB(accessKeyId: accessKey, secretAccessKey: secretKey, region: Region.uswest1)
            var key: [String: DynamoDB.AttributeValue] = [:]
            key["username"] = DynamoDB.AttributeValue(s: currentUsername!)
//            key["gsihash"] = DynamoDB.AttributeValue(s: gsiHashKey)
            let deleteRequest = DynamoDB.DeleteItemInput(key: key, tableName: tableName)
            do {
                _ = try dynamodb.deleteItem(deleteRequest).wait()
            } catch {
                print("delete operation failed: \(error)")
            }
        }
        
        return hasNewUsername
    }
    
    
    
    
}
