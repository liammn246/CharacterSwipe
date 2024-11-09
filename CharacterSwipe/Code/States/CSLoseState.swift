//
//  CSLoseState.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 10/29/24.
//

import GameplayKit
import SpriteKit

class CSLoseState: CSGameState {

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        let restartButton = SKSpriteNode(color: .red, size: CGSize(width: 200, height: 50))
        restartButton.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2 - 100)
        restartButton.name = "restartButton"

        let restartLabel = SKLabelNode(text: "Restart Game")
        restartLabel.fontColor = .white
        restartLabel.fontSize = 24
        restartLabel.position = CGPoint(x: 0, y: -restartButton.size.height / 4)
        restartButton.addChild(restartLabel)
        
        gameScene.addChild(restartButton)

        print("Lose state entered: Displaying Restart Button")
    }

    func startGame() {
        print("Restart button tapped, transitioning to gameplay state")
        stateMachine?.enter(CSGameplayState.self)
        
        gameScene.childNode(withName: "restartButton")?.removeFromParent()
    }

    func handleTouch(at location: CGPoint) {
        if let restartButton = gameScene.childNode(withName: "restartButton"), restartButton.contains(location) {
            initializeBoardValues()
            startGame()
        }
    }
}
