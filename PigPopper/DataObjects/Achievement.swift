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
    let requiredScore: Int
    let reward: String
    var completed: Bool
    
    
    init(rank: String, score: Int, reward: String) {
        self.rank = rank
        self.requiredScore = score
        self.reward = reward
        
        let highscore = DataHelper.getHighscore()
        self.completed = highscore >= self.requiredScore ? true : false
    }
    
    
    func isCompletedBy(highscore: Int) -> Bool {
        if !completed && highscore >= requiredScore {
            completed = true
            return true
        }
        return false
    }
    
    func isCompleted() -> Bool {
        return self.completed
    }
    
    
    
}
