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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Delegate touch to game board if applicable
        if let gameBoard = gameBoard, !gameBoard.isHidden {
            let locationInBoard = touch.location(in: gameBoard)
            gameBoard.handleTouch(at: locationInBoard)
        }

        // Handle touches in specific states
        if let startState = context?.stateMachine?.currentState as? CSStartState {
            startState.handleTouch(at: location)
        } else if let loseState = context?.stateMachine?.currentState as? CSLoseState {
            loseState.handleTouch(at: location)
        }
    }



    override func didMove(to view: SKView) {
        super.didMove(to: view)
        context?.stateMachine?.enter(CSStartState.self) // Start with CSStartState
        
        // Set up the game board
        let boardSize = CGSize(width: 300, height: 300) // Adjust the size as needed
        gameBoard = CSGameBoard(size: boardSize)
        gameBoard.gameScene = self
        gameBoard.position = CGPoint(x: size.width / 2, y: size.height / 1.5)
        gameBoard.zPosition = 1
        gameBoard.isHidden = true  // Start hidden
        if let gameBoard = gameBoard {
            addChild(gameBoard)
        }
        
        // Add swipe functionality
        setupSwipeGestures()
    }
    
    func getGameBoard() -> CSGameBoard? {
        return gameBoard
    }
    
    // MARK: - Show/Hide Game Board
    func showGameBoard() {
        gameBoard.isHidden = false
    
    }
    
    func hideGameBoard() {
        gameBoard.isHidden = true
    }

    // MARK: - Swipe Detection Setup
    private func setupSwipeGestures() {
        swipeDetector.addSwipeGestures(to: self)
        
        swipeDetector.onSwipeUp = { [weak self] in
            guard let self = self, self.context?.stateMachine?.currentState is CSGameplayState else { return }
            self.gameBoard.onUserInput(direction: "up")
        }
        
        swipeDetector.onSwipeDown = { [weak self] in
            guard let self = self, self.context?.stateMachine?.currentState is CSGameplayState else { return }
            self.gameBoard.onUserInput(direction: "down")
        }
        
        swipeDetector.onSwipeLeft = { [weak self] in
            guard let self = self, self.context?.stateMachine?.currentState is CSGameplayState else { return }
            self.gameBoard.onUserInput(direction: "left")
        }
        
        swipeDetector.onSwipeRight = { [weak self] in
            guard let self = self, self.context?.stateMachine?.currentState is CSGameplayState else { return }
            self.gameBoard.onUserInput(direction: "right")
        }
    }

    
    // Handle swipe and pass to the gameplay state
    private func handleSwipe(direction: UISwipeGestureRecognizer.Direction) {
        print("Swiped in direction: \(direction)")
        
        // Pass swipe action to CSGameplayState
        if let gameplayState = context?.stateMachine?.currentState as? CSGameplayState {
            print("Called state machine for swipe")
        }
    }
    
    // MARK: - Refresh Game Board
    func updateTiles() {
        gameBoard.updateTiles() // Ensure CSGameBoard has a method to refresh its tiles
    }
}
