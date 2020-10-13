//
//  Achievement.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/10/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import Foundation

class Achievement {
    

    let rank: String
    let reward: String
    let requiredScore: Int
    let baconAmount: Int?
    let itemType: ItemType?
    var completed: Bool

    init(rank: String, score: Int, reward: String, itemType: ItemType?, baconAmount: Int?) {
        self.rank = rank
        self.requiredScore = score
        self.reward = reward
        self.baconAmount = baconAmount
        self.itemType = itemType

        let highscore = DataHelper.getHighscore()
        self.completed = highscore >= self.requiredScore ? true : false
    }
    
    convenience init(rank: String, score: Int, baconAmount: Int) {
        self.init(rank: rank, score: score, reward: "bacon", itemType: nil, baconAmount: baconAmount)
    }
    
    convenience init(rank: String, score: Int, itemReward: String, itemType: ItemType) {
        self.init(rank: rank, score: score, reward: itemReward, itemType: itemType, baconAmount: nil)
    }
    
    
    func isCompletedBy(highscore: Int) -> Bool {
        if !completed && highscore >= requiredScore {
            
            if let baconReward = baconAmount {
                let currentBacon = DataHelper.getBacon()
                DataHelper.setBacon(bacon: currentBacon + baconReward)
            }
            
            completed = true
            return true
        }
        return false
    }
    
    func isCompleted() -> Bool {
        return self.completed
    }
    
    
    
}
