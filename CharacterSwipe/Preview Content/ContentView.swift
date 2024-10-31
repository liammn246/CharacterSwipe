//
//  ContentView.swift
//  CharacterSwipe
//
//  Created by Liam Nagel on 10/23/24.
//

import GameplayKit
import SpriteKit
import SwiftUI

struct ContentView: View {

    let context = CSGameContext()

    var body: some View {
        ZStack {
            SpriteView(scene: context.scene, debugOptions: [])
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
        }
        .statusBarHidden()
    }
}

#Preview {
    ContentView()
}
