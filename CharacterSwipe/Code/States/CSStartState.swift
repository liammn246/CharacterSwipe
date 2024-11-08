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

        // Display the start button on the screen
        let startButton = SKSpriteNode(color: .blue, size: CGSize(width: 200, height: 50))
        startButton.position = CGPoint(x: 0, y: -100) // Positioned below the center
        startButton.name = "startButton" // Assign a name to identify it
        gameScene.addChild(startButton)

        print("Start state entered: Displaying Start Button")
    }

    func startGame() {
        // When the start button is pressed, transition to the gameplay state
        stateMachine?.enter(CSGameplayState.self)

        if let startButton = gameScene.childNode(withName: "startButton") {
            startButton.removeFromParent() // removes start button when pressed
        }
    }
    func handleTouch(at location: CGPoint) {
            // Check if the start button was tapped
            if let startButton = gameScene.childNode(withName: "startButton"), startButton.contains(location) {
                // Start button was tapped, transition to the gameplay state
                print("Start button tapped, transitioning to gameplay state")
                startGame()
            }
        }
    }
