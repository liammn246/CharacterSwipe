//
//  CSScore.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 11/8/24.
//
import GameplayKit
import SpriteKit

class CSScore: CSGameState {
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        let score_tile = SKSpriteNode(color: .red, size: CGSize(width: 200, height: 5000))
        score_tile.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2 - 50)
        score_tile.name = "score"
        
        // Create a label for the button
        let score_label = SKLabelNode(text: "SCOREE")
        score_label.fontColor = .white
        score_label.fontSize = 24
        score_label.position = CGPoint(x: 0, y: -score_tile.size.height / 4)  // Adjust label position
        
        // Add the label to the  node
        score_tile.addChild(score_label)
        
        gameScene.addChild(score_tile)
        
        print("Displaying Start Button")
    }
}
