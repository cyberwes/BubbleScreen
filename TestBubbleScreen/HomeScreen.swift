//
//  SwiftUIView.swift
//  TestBubbleScreen
//
//  Created by Wesley Hahn on 19/11/2023.
//

import SwiftUI

struct HomeScreen: View {
    
    @State var stateManager: StateManager
    
    init(stateManager: StateManager) {
        self.stateManager = stateManager
        UITabBar.appearance().barTintColor = UIColor.clear;
    }
    
    var body: some View {
        TabView {
            ZStack {
                BouncingBubblesView(stateManager: stateManager)
                VStack {
                    HStack {
                        Text("BouncingBubbles").font(.largeTitle).fontWeight(.bold).foregroundColor(.white).shadow(radius: 10)
                        Spacer()
                    }
                    Spacer()
                }.padding()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            Text("Hello World")
            .tabItem {
                Label("Order", systemImage: "square.and.pencil")
            }
        }
    }
}



#Preview {
    HomeScreen(stateManager: StateManager())
}
