//
//  AchievementManager.swift
//  PigPopper
//
//  Created by Evan Corriere on 9/18/20.
//  Copyright © 2020 Evan Corriere. All rights reserved.
//

import Foundation

class AchievementManager {
    
    static let achievements: [Achievement] = [
        Achievement(rank: "Rookie", score: 5, itemReward: "bunnyHat", itemType: .hat), // hat - bunny
        Achievement(rank: "Piggy", score: 10, itemReward: "frozenBar", itemType: .weapon), // fork - frozenDessert
        Achievement(rank: "Oinker", score: 15, baconAmount: 1000), // bacon
        Achievement(rank: "Farmer", score: 20, itemReward: "appleHat", itemType: .hat), // hat - apple
        Achievement(rank: "Hunter", score: 25, itemReward: "arrow", itemType: .weapon), // fork - arrow
        Achievement(rank: "Swineherd", score: 35, baconAmount: 50000), // bacon
        Achievement(rank: "Boar Borer", score: 50, itemReward: "crownHat", itemType: .hat), // hat - crown
        Achievement(rank: "Pig Popper", score: 75, itemReward: "darkSword", itemType: .weapon) ] // fork - mega sword
           
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
