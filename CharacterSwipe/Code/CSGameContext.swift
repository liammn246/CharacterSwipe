
//  CSGameContext.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 10/24/24.
//
import GameplayKit
import SwiftUI

class CSGameContext {
    private(set) var scene: CSGameScene!
    var previousHighestUnlockedIndex: Int = -1
    private(set) var stateMachine: GKStateMachine?
    var layoutInfo: CSGameLayout
    var gameInfo: CSGameInfo
    init() {
        self.layoutInfo = CSGameLayout()
        self.gameInfo = CSGameInfo()
        self.scene = CSGameScene(context: self, size: UIScreen.main.bounds.size)
        
        configureStates()
        configureLayoutInfo()
    }
    
    private func configureStates() {
        // Ensure scene is already initialized before using it in states
        guard let gameScene = scene else {
            print("Error: Game Scene not initialized properly")
            return
        }
        
        // Set up the state machine with the already initialized scene
        stateMachine = GKStateMachine(states: [
            CSGameplayState(gameScene: gameScene),
            CSLoseState(gameScene: gameScene),
            CSStartState(gameScene: gameScene)
        ])
        
        // Start with an initial state, e.g., CSStartState
        stateMachine?.enter(CSStartState.self)
    }
    
    private func configureLayoutInfo() {
        // If you have layout setup, do it here
        let screenSize = UIScreen.main.bounds.size
        // Additional layout configuration if needed
    }
}
