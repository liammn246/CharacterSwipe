//
//  CSGameInfo.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 10/24/24.
//


// Game sessions specific info: score, powerup active or not, level progression
// Score, level progression

import Foundation

class CSGameInfo {
    var score: Int
    
    init() {
        score = 0
    }
    
    func reset() {
        score = 0
    }
    
    func incrementScore(by amount: Int) {
        score = score + amount
    }

}
