//
//  AchievementManager.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/18/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import Foundation

class AchievementManager {
    
    static let achievements: [Achievement] = [ Achievement(rank: "Rookie", score: 5, reward: "bunnyHat"), // hat - bunny
                                               Achievement(rank: "Piggy", score: 10, reward: "frozenBar"), // fork - frozenDessert
                                               Achievement(rank: "Oinker", score: 15, reward: "bacon"), // bacon - 500
                                               Achievement(rank: "PIG", score: 25, reward: "appleHat"), // hat - apple
                                               Achievement(rank: "Farmer", score: 35, reward: "arrow"), // fork - arrow
                                               Achievement(rank: "Agricultural Scientist", score: 50, reward: "bacon"), // bacon
                                               Achievement(rank: "Master", score: 75, reward: "crownHat"), // hat - crown
                                               Achievement(rank: "God", score: 100, reward: "darkSword") ] // fork - mega sword
           
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
