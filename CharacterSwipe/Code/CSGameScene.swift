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
        super.didMove(to: view)
        // Set up the game board
        let boardSize = CGSize(width: 300, height: 300)  // Adjust the size as needed
        gameBoard = CSGameBoard(size: boardSize)
        // Center the game board in the scene
        gameBoard.position = CGPoint(x: size.width / 2, y: size.height / 1.5)
        // Ensure the game board appears in front
        gameBoard.zPosition = 1
        // Add the game board to the scene
        addChild(gameBoard)
<<<<<<< HEAD
//NEED TO MOVE GAMEBOARD INTO GAMEPLAYSTATE
=======
>>>>>>> 50d2344823388ef5173da669f2a1e2f33e60b267
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Handle touch events when the user first touches the screen
        // Get the first touch location
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            // Handle the touch based on the current game state or location
            handleTouch(at: location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Optionally handle touch movement (e.g., dragging, swiping)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Optionally handle the touch end event (e.g., end of swipe or tap)
    }
    // Handle touch at a specific location
    func handleTouch(at location: CGPoint) {
        // Example logic: Detect if the user tapped on a button or performed an action
        // You can forward this logic to your game state or game board
        // Check if the touch is inside the game board area
        if gameBoard.contains(location) {
            // Here you can perform the action when a player interacts with the game board (e.g., swipe, move tile, etc.)
            print("Touched the game board at: \(location)")
            // If you want to detect swipes or taps on the tiles, you could add more logic here
        }
        else {
            print("Touched outside the game board")
        }
    }
    
    // Optionally handle swipe detection if needed (for gameplay)
    func detectSwipe(from startPoint: CGPoint, to endPoint: CGPoint) {
        let deltaX = endPoint.x - startPoint.x
        let deltaY = endPoint.y - startPoint.y
        
        // Define a threshold for detecting swipe direction
        let threshold: CGFloat = 50
        
        if abs(deltaX) > abs(deltaY) && abs(deltaX) > threshold {
            if deltaX > 0 {
                // Swipe Right
                print("Swipe Right")
                // Call your swipe right function
            } else {
                // Swipe Left
                print("Swipe Left")
                // Call your swipe left function
            }
        } else if abs(deltaY) > abs(deltaX) && abs(deltaY) > threshold {
            if deltaY > 0 {
                // Swipe Up
                print("Swipe Up")
                // Call your swipe up function
            } else {
                // Swipe Down
                print("Swipe Down")
                // Call your swipe down function
            }
        }
    }
}
    //NEED TO WORK ON REFRESHING THE BOARD AFTER EVERY SWIPE SO THAT IT IS UPDATED
    //IN ORDER TO DO THAT: In CSGameScene, after creating gameBoard, pass it to CSGameplayState so it can call the updateTiles method after every swipe.
    //HOW DO WE PASS IT TO CSGAMEPLAYSTATE?
    //ALSO NEED AN UPDATE tiLES FUNCTION
