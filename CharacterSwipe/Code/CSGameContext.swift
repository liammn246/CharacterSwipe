
//  CSGameContext.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 10/24/24.
//
import GameplayKit
import SwiftUI

class CSGameContext {
    private(set) var scene: CSGameScene!
    private(set) var stateMachine: GKStateMachine?
    var layoutInfo: CSGameLayout
    var gameInfo: CSGameInfo
    init() {
        self.layoutInfo = CSGameLayout()
        self.gameInfo = CSGameInfo()
        self.scene = CSGameScene(context: self, size: UIScreen.main.bounds.size)
        
//        configureStates()
    
    func configureStates() {
        stateMachine = GKStateMachine(
            states: [
                CSGameplayState(gameScene: scene),
                CSLoseState(gameScene: scene),
                CSStartState(gameScene: scene)
            ]
        )
    }

}

