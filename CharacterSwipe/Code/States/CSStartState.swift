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

    init(gameScene: CSGameScene) {
        self.gameScene = gameScene
        super.init()
    }
}

class CSStartState: CSGameState {

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        let startButton = SKSpriteNode(color: .red, size: CGSize(width: 200, height: 50))
        startButton.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2 - 100)
        startButton.name = "startButton"
        
        // Create a label for the button
        let startLabel = SKLabelNode(text: "Start Game")
        startLabel.fontColor = .white
        startLabel.fontSize = 24
        startLabel.position = CGPoint(x: 0, y: -startButton.size.height / 4)  // Adjust label position

        // Add the label to the button node
        startButton.addChild(startLabel)
        
        gameScene.addChild(startButton)

        print("Start state entered: Displaying Start Button")
    }

    func startGame() {
        print("Start button tapped, transitioning to gameplay state")
        stateMachine?.enter(CSGameplayState.self)
        
        if let startButton = gameScene.childNode(withName: "startButton") {
            startButton.removeFromParent()
        }
    }

    func handleTouch(at location: CGPoint) {
        if let startButton = gameScene.childNode(withName: "startButton"), startButton.contains(location) {
            startGame()
        }
    }
}
