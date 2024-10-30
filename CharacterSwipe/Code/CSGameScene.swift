// screen that users see when playing game

import SpriteKit

class CSGameScene: SKScene {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    unowned let context: CSGameContext
    var gameInfo: CSGameInfo? { context.gameInfo }
    var layoutInfo: CSGameLayout { context.layoutInfo }

}

//uh oh
