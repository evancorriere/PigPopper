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
    let completed: Bool
    
    
    init(rank: String, score: Int, reward: String) {
        self.rank = rank
        self.requiredScore = score
        self.reward = reward
        self.completed = false
        
        // TODO : if highscore > required -> self.completed = true
    }
    
    
    
    
    
}
