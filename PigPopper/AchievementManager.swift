//
//  AchievementManager.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/18/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import Foundation

class AchievementManager {
    
    static var achievements: [Achievement] = [  Achievement(rank: "Rookie", score: 5, reward: "one"),
                                                Achievement(rank: "Piggy", score: 10, reward: "two"),
                                                Achievement(rank: "Oinker", score: 15, reward: "three"),
                                                Achievement(rank: "PIG", score: 20, reward: "four"),
                                                Achievement(rank: "Farmer", score: 25, reward: "five"),
                                                Achievement(rank: "Agricultural Scientist", score: 30, reward: "six"),
                                                Achievement(rank: "God", score: 100, reward: "seven")
                                            ]
    
    // achievement completed set at init, here we have functions to update them
    
    // Preconditison: this is the same high score as userdefaults
    // not checking to precent calling every time
    // returns list of newly completed achievements
    static func updatedAchievements(highscore: Int) -> [Achievement] {
        var completed: [Achievement] = []
        for achievement in achievements {
            if achievement.isCompletedBy(highscore: highscore) {
                completed.append(achievement)
            }
        }
        
        return completed
    }
    

    
    
    
    
    
    
    
}
