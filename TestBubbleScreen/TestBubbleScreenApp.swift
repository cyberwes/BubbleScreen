//
//  TestBubbleScreenApp.swift
//  TestBubbleScreen
//
//  Created by Wesley Hahn on 19/11/2023.
//

import SwiftUI

@main
struct TestBubbleScreenApp: App {
    
    @State var stateManager = StateManager()
    
    var body: some Scene {
        WindowGroup {
            if (stateManager.current == StateManager.screen.bubbleView) {
                BubbleView(stateManager: stateManager);
            } else {
                HomeScreen(stateManager: stateManager)
            }
        }
    }
}

@Observable
class StateManager {
    
    enum screen {
        case home
        case bubbleView
    }
    
    var bubble = Bubble(radius: 100, position: CGPoint() , velocity: CGVector(dx:1, dy:1), colorOne: .black, colorTwo: .black, text: "error")
    
    var current: screen = screen.home

}
