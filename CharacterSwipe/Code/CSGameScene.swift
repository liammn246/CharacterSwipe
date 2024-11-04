
//  CSGameScene.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 10/24/24.
//

import SpriteKit

class CSGameScene: SKScene {
    weak var context: CSGameContext?
    var gameBoard: CSGameBoard!
    init(context: CSGameContext, size: CGSize) {
        self.context = context
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        let boardSize = CGSize(width: 300, height: 300)  // Adjust the size as needed
        let gameBoard = CSGameBoard(size: boardSize)
        
        // Centers the game board in the scene
        gameBoard.position = CGPoint(x: size.width / 2, y: size.height/1.5)
        
        //zPosition to ensure it appears in front
        gameBoard.zPosition = 1
        
        // Add the game board to the scene
        addChild(gameBoard)

    }
    //NEED TO WORK ON REFRESHING THE BOARD AFTER EVERY SWIPE SO THAT IT IS UPDATED
    //IN ORDER TO DO THAT: In CSGameScene, after creating gameBoard, pass it to CSGameplayState so it can call the updateTiles method after every swipe.
    
    //HOW DO WE PASS IT TO CSGAMEPLAYSTATE?
    //ALSO NEED AN UPDATE tiLES FUNCTION
    
}
