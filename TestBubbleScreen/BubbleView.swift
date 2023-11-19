//
//  BubbleView.swift
//  TestBubbleScreen
//
//  Created by Wesley Hahn on 19/11/2023.
//

import SwiftUI

struct BubbleView: View {
    
    @State var stateManager: StateManager;
    
    var body: some View {
        ZStack {
            Rectangle().fill(Gradient(colors: [stateManager.bubble.colorOne, stateManager.bubble.colorTwo]))
            VStack {
                HStack {
                    Button(action: {
                        stateManager.current = StateManager.screen.home
                    }, label: {
                        Text("Back").foregroundColor(.white)
                    })
                    Spacer()
                }.padding()
                Spacer()
                Text(stateManager.bubble.text).foregroundColor(.white)
                Spacer()
            }
        }.background(Gradient(colors: [stateManager.bubble.colorOne, stateManager.bubble.colorTwo]))
    }}
