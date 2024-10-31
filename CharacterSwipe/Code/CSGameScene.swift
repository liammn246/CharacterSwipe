
//  CSGameScene.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 10/24/24.
//

import SpriteKit

class CSGameScene: SKScene {
    weak var context: CSGameContext?
    init(context: CSGameContext, size: CGSize) {
        self.context = context
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    var gameInfo: CSGameInfo? { context.gameInfo }
//    var layoutInfo: CSGameLayout { context.layoutInfo }
//    
}

