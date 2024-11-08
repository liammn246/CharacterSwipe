//  CSGameplayState.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 10/29/24.
//

//Tap mechanics go here
//Code that changes depending on state

import GameplayKit
import SpriteKit

class CSGameplayState: CSGameState {
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        print("Entering gameplay state, showing game board")
        gameScene.showGameBoard()
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        print("Exiting gameplay state, hiding game board")
        gameScene.hideGameBoard()
    }
}
