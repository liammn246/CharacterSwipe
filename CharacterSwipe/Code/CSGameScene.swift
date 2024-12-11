//  CSGameScene.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 10/24/24.
//

import SpriteKit

class CSGameScene: SKScene {
    var scorePop: SKLabelNode!
    var rectangleBackground: SKShapeNode!
    var scoreLabel: SKLabelNode!
    var scoreTile: SKShapeNode!
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
        
        rectangleBackground = SKShapeNode(rectOf: CGSize(width: 320, height: 320), cornerRadius: 20) // Adjust
        rectangleBackground.fillColor = SKColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        rectangleBackground.strokeColor = SKColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1) //border
        rectangleBackground.lineWidth = 5 // Border thickness
        rectangleBackground.position = CGPoint(x: size.width / 2, y: size.height / 2)
        rectangleBackground.zPosition = -1 // Set zPosition to layer it properly
        rectangleBackground.isHidden = true
        addChild(rectangleBackground)
        
        // Set up the game board
        let boardSize = CGSize(width: 300, height: 300) // Adjust the size as needed
        gameBoard = CSGameBoard(size: boardSize)
        gameBoard.gameScene = self
        gameBoard.position = CGPoint(x: size.width / 2, y: size.height / 1.625)
        gameBoard.zPosition = 1
        gameBoard.isHidden = true  // Start hidden
        addChild(gameBoard)

        
         
         

        scoreTile = SKShapeNode(rectOf: CGSize(width: 200, height: 50), cornerRadius: 10)
        scoreTile.fillColor = SKColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        scoreTile.position = CGPoint(x: size.width / 2, y: size.height / 6)
        scoreTile.strokeColor = SKColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1) //border
        scoreTile.lineWidth = 5 // Border thickness
        scoreTile.name = "scoreTile"
        addChild(scoreTile)

        // Create the actual score label
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 24
        scoreLabel.verticalAlignmentMode = .center // Ensures vertical centering
        scoreLabel.horizontalAlignmentMode = .center // Ensures horizontal centering
        scoreLabel.position = CGPoint(x: 0, y: 0) // Position at the center of scoreTile
        scoreTile.addChild(scoreLabel) // Add label as a child of the tile

        // Add swipe functionality
        setupSwipeGestures()
    }
    
    func getGameBoard() -> CSGameBoard? {
        return gameBoard
    }
    
    // MARK: - Show/Hide Game Board
    func showGameBoard() {
        gameBoard.isHidden = false
        rectangleBackground.isHidden = false
    
    }
    
    func hideGameBoard() {
        gameBoard.isHidden = true
        rectangleBackground.isHidden = true
    }
    
    func updateScoreLabel(newScore: Int) {
        scoreLabel?.text = "\(newScore)"
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
