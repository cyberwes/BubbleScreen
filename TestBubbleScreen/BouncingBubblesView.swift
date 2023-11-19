//
//  SwiftUIView.swift
//  TestBubbleScreen
//
//  Created by Wesley Hahn on 19/11/2023.
//

import SwiftUI

let renderHeight = 2000.0
let renderWidth = 2000.0

struct BouncingBubblesView: View {
    
    var stateManager: StateManager
    
    @State private var bubbles: [Bubble] = []
    private var people = ["wesley", "person", "AJ", "lauren", "fabian", "someone"]
    private var colors: [Color] = [Color.red, Color.orange, Color.yellow, Color.green, Color.cyan, Color.blue, Color.purple, Color.pink, Color.red]
    
    init(stateManager: StateManager) {
        self.stateManager = stateManager
    }
    
    var body: some View {
        ScrollView ([.horizontal, .vertical], showsIndicators: false) {
            GeometryReader { geometry in
                ForEach(bubbles.indices, id: \.self) { index in
                    let bubble = bubbles[index]
                    Button(action: {
                        stateManager.current = .bubbleView
                        stateManager.bubble = bubble
                    }, label: {
                        ZStack {
                            Circle()
                                .fill(Gradient(colors: [bubble.colorOne, bubble.colorTwo]))
                                .frame(width: bubble.radius * 2, height: bubble.radius * 2)
                            VStack {
                                Image(systemName: "person")
                                Text(bubble.text)
                            }
                        }
                    })
                        .foregroundColor(.white)
                        .position(bubble.position)
                }
            }
            .frame(width: renderWidth, height: renderHeight)
        }
        .background(.black)

    
        .onAppear {
            bubbles = []
            var index = 0
            for i in 0..<50 {
                index = (index == 7) ? 0 : index + 1;
                bubbles.append(Bubble(radius: 100, position: randomPosition(in: CGRect(x: 0, y: 0, width: renderWidth, height: renderHeight)), velocity: randomVelocity(), colorOne: colors[index], colorTwo: colors[index + 1], text: people[i % 6]))
            }
            
            let timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                withAnimation {
                    updateBubblesPositions(in: CGRect(x: 0, y: 0, width: renderWidth, height: renderHeight))
                }
            }
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    private func randomPosition(in bounds: CGRect) -> CGPoint {
        return CGPoint(x: CGFloat.random(in: 0...(bounds.width - 50)), y: CGFloat.random(in: 0...(bounds.height - 50)))
    }

    private func randomVelocity() -> CGVector {
        let speed = CGFloat(1)
        let angle = CGFloat.random(in: 0...(2 * .pi))
        return CGVector(dx: cos(angle) * speed, dy: sin(angle) * speed)
    }

    private func updateBubblesPositions(in bounds: CGRect) {
        for index in bubbles.indices {
            var bubble = bubbles[index]
            bubble.position.x += bubble.velocity.dx
            bubble.position.y += bubble.velocity.dy

            if bubble.position.x < 0 || bubble.position.x > bounds.width {
                bubble.velocity.dx *= -1
            }

            if bubble.position.y < 0 || bubble.position.y > bounds.height {
                bubble.velocity.dy *= -1
            }

            for otherIndex in bubbles.indices where otherIndex != index {
                var otherBubble = bubbles[otherIndex]
                let distance = hypot(bubble.position.x - otherBubble.position.x, bubble.position.y - otherBubble.position.y)

                if distance < bubble.radius + otherBubble.radius {
                    handleCollision(bubble: &bubble, with: &otherBubble)
                    bubbles[otherIndex] = otherBubble
                }
            }

            for otherIndex in bubbles.indices where otherIndex != index {
                var otherBubble = bubbles[otherIndex]
                let distance = hypot(bubble.position.x - otherBubble.position.x, bubble.position.y - otherBubble.position.y)

                let minDistance = bubble.radius + otherBubble.radius
                if distance < minDistance {
                    let overlap = minDistance - distance
                    let direction = CGVector(dx: otherBubble.position.x - bubble.position.x, dy: otherBubble.position.y - bubble.position.y)
                    let unitDirection = CGVector(dx: direction.dx / distance, dy: direction.dy / distance)

                    bubble.position.x -= overlap * 0.5 * unitDirection.dx
                    bubble.position.y -= overlap * 0.5 * unitDirection.dy

                    otherBubble.position.x += overlap * 0.5 * unitDirection.dx
                    otherBubble.position.y += overlap * 0.5 * unitDirection.dy

                    bubbles[otherIndex] = otherBubble
                }
            }
            bubbles[index] = bubble
        }
    }

    private func handleCollision(bubble: inout Bubble, with otherBubble: inout Bubble) {
        let relativeVelocity = CGVector(dx: bubble.velocity.dx - otherBubble.velocity.dx, dy: bubble.velocity.dy - otherBubble.velocity.dy)
        let normal = CGVector(dx: otherBubble.position.x - bubble.position.x, dy: otherBubble.position.y - bubble.position.y)
        let distance = hypot(normal.dx, normal.dy)
        let unitNormal = CGVector(dx: normal.dx / distance, dy: normal.dy / distance)

        let relativeSpeed = relativeVelocity.dx * unitNormal.dx + relativeVelocity.dy * unitNormal.dy

        let impulse = 2 * relativeSpeed / (bubble.radius + otherBubble.radius)

        bubble.velocity.dx -= impulse * otherBubble.radius * unitNormal.dx
        bubble.velocity.dy -= impulse * otherBubble.radius * unitNormal.dy

        otherBubble.velocity.dx += impulse * bubble.radius * unitNormal.dx
        otherBubble.velocity.dy += impulse * bubble.radius * unitNormal.dy

        let maxVelocityChange: CGFloat = 5.0
        bubble.velocity.dx = max(-maxVelocityChange, min(maxVelocityChange, bubble.velocity.dx))
        bubble.velocity.dy = max(-maxVelocityChange, min(maxVelocityChange, bubble.velocity.dy))

        otherBubble.velocity.dx = max(-maxVelocityChange, min(maxVelocityChange, otherBubble.velocity.dx))
        otherBubble.velocity.dy = max(-maxVelocityChange, min(maxVelocityChange, otherBubble.velocity.dy))
    }
}

struct Bubble {
    var radius: CGFloat = 100.0
    var position: CGPoint
    var velocity: CGVector
    var colorOne: Color;
    var colorTwo: Color;
    var text: String;
}

extension CGVector {
    func length() -> CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
}

#Preview {
    BouncingBubblesView(stateManager: StateManager())
}
