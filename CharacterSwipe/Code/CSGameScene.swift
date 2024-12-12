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
    var background2: SKShapeNode!
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
        rectangleBackground.zPosition = -4 // Set zPosition to layer it properly
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

        
         
         

        background2 = SKShapeNode(rectOf: CGSize(width: 300, height: 80), cornerRadius: 10)
        background2.fillColor = SKColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        background2.position = CGPoint(x: size.width / 2, y: size.height / 6)
        background2.strokeColor = SKColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1) //border
        background2.lineWidth = 5 // Border thickness
        background2.name = "scoreTile"
        background2.isHidden = true
        addChild(background2)

        
        scoreTile = SKShapeNode(rectOf: CGSize(width: 90, height: 50), cornerRadius: 25) // Adjust
        scoreTile.fillColor = SKColor(red: 63/255, green: 63/255, blue: 63/255, alpha: 1)
        scoreTile.strokeColor = SKColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1) //border
        scoreTile.lineWidth = 5 // Border thickness
        scoreTile.zPosition = 9 // Set zPosition to layer it properly
        scoreTile.isHidden = true
        background2.addChild(scoreTile)
        
        
        // Create the actual score label
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.fontColor = .white
        scoreLabel.zPosition = 10
        scoreLabel.fontSize = 24
        scoreLabel.verticalAlignmentMode = .center // Ensures vertical centering
        scoreLabel.horizontalAlignmentMode = .center // Ensures horizontal centering
        scoreLabel.position = CGPoint(x: 0, y: 0) // Position at the center of scoreTile
        scoreLabel.isHidden = true
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
        scoreTile.isHidden = false
        scoreLabel.isHidden = false
        background2.isHidden = false
    
    }
    
    func hideGameBoard() {
        gameBoard.isHidden = true
        rectangleBackground.isHidden = true
        scoreTile.isHidden = true
        scoreLabel.isHidden = true
        background2.isHidden = true
    }
    
    func updateScoreLabel(newScore: Int) {
        guard let scoreLabel = scoreLabel else { return }

        // Create a floating label to show the old score
        let floatingLabel: SKLabelNode
        if let currentScore = Int(scoreLabel.text ?? "0") {
            floatingLabel = SKLabelNode(text: "+ " + String(newScore - currentScore))
        } else {
            floatingLabel = SKLabelNode(text: "+ " + String(newScore))
        }
        if Int(scoreLabel.text ?? "0") != newScore {
            floatingLabel.fontName = scoreLabel.fontName
            floatingLabel.fontSize = scoreLabel.fontSize - 5
            floatingLabel.fontColor = scoreLabel.fontColor
            floatingLabel.position = scoreLabel.position
            floatingLabel.zPosition = scoreLabel.zPosition
            scoreLabel.parent?.addChild(floatingLabel)
            
            // Update the score label text
            scoreLabel.text = "\(newScore)"
            
            // Create the floating and fading animation
            let floatUp = SKAction.moveBy(x: 0, y: 20, duration: 0.5)
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let group = SKAction.group([floatUp, fadeOut])
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([group, remove])
            
            // Run the animation
            floatingLabel.run(sequence)
        }
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
