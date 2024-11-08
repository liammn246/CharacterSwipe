//  CSGameScene.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 10/24/24.
//

import SpriteKit

class CSGameScene: SKScene {
    
    weak var context: CSGameContext?
    var gameBoard: CSGameBoard!
    
    // SwipeDetector instance
    let swipeDetector = SwipeDetector()
    
    init(context: CSGameContext, size: CGSize) {
        self.context = context
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Set up the game board
        let boardSize = CGSize(width: 300, height: 300) // Adjust the size as needed
        gameBoard = CSGameBoard(size: boardSize)
        gameBoard.position = CGPoint(x: size.width / 2, y: size.height / 1.5)
        gameBoard.zPosition = 1
        addChild(gameBoard)
        
        // Add swipe functionality
        setupSwipeGestures()
    }
    
    // MARK: - Swipe Detection Setup
    private func setupSwipeGestures() {
        swipeDetector.addSwipeGestures(to: self)
        
        // Assign actions for each swipe direction
        swipeDetector.onSwipeUp = { [weak self] in
            self?.gameBoard.onUserInput(direction: "up")
        }
        
        swipeDetector.onSwipeDown = { [weak self] in
            self?.gameBoard.onUserInput(direction: "down")
        }
        
        swipeDetector.onSwipeLeft = { [weak self] in
            self?.gameBoard.onUserInput(direction: "left")
        }
        
        swipeDetector.onSwipeRight = { [weak self] in
            self?.gameBoard.onUserInput(direction: "right")
        }
    }
    
    // Handle swipe and pass to the gameplay state
    private func handleSwipe(direction: UISwipeGestureRecognizer.Direction) {
        print("Swiped in direction: \(direction)")
        
        // Pass swipe action to CSGameplayState
        if let gameplayState = context?.stateMachine?.currentState as? CSGameplayState {
//            gameplayState.handleSwipe(direction: direction)
            print("Called state machine for swipe")
        }
    }
    
    // MARK: - Refresh Game Board
    func updateTiles() {
        gameBoard.updateTiles() // Ensure CSGameBoard has a method to refresh its tiles
    }
}
