//
//  CSStartStart.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 10/29/24.
//

import SpriteKit
import GameplayKit


class CSGameState: GKState  {
    
    unowned let gameScene: CSGameScene
    /// Idk what this is, research
    init(gameScene: CSGameScene) {
        self.gameScene = gameScene
        super.init()
    }
}

class CSStartState: CSGameState {

}
