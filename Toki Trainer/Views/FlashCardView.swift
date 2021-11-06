//
//  FlashCardView.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/5/21.
//

import SwiftUI

struct FlashCardView: View {
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 100
                )
            FlashCard(canBeFlipped: true)
            Spacer()
            FlashCardStack()
        }
    }
}

struct FlashCardStack: View {
    
    var body: some View {
        ZStack {
            ForEach(0 ..< 8) { item in
                FlashCard(canBeFlipped: false)
                    .offset(x: 0, y: -30 * CGFloat(item))
            }
        }
    }
}

struct FlashCard: View {
    let screen = UIScreen.main.bounds
    
    @State var isFaceDown = false
    @State var rotationAngle: Double = 0
    @State var canBeFlipped: Bool
    
    var body: some View {
        
        let flipDegrees = isFaceDown ? 0.0 : 180.0
        
        Text("")
            .modifier(CardFlipModifier(isFaceDown: isFaceDown, frontText: "linja", backText: "long, very thin, floppy thing, e.g. string, rope, hair, thread, cord, chain"))
            .frame(width: 0.8 * screen.width, height: 200.0)
            .font(.title)
            .rotation3DEffect(self.isFaceDown ? Angle(degrees: 180) : Angle(degrees: 0), axis: (x: 0.0, y: 10.0, z: 0.0))
            .animation(.default)
            .onTapGesture {
                if canBeFlipped == true {
                    self.isFaceDown.toggle()
                }
            }
        
    }
    
    func setCanBeFlipped(_ input: Bool) {
        canBeFlipped = input
    }
}

struct CardFlipModifier: AnimatableModifier {
    
    var frontText: String
    var backText: String
    var isFaceDown: Bool
    var rotationAngle: Double
    
    init(isFaceDown: Bool, frontText: String, backText: String) {
        rotationAngle = isFaceDown ? 180 : 0
        self.isFaceDown = isFaceDown
        self.frontText = frontText
        self.backText = backText
    }
    
    var animatableData: Double {
        get { rotationAngle }
        set { rotationAngle = newValue }
    }
    
    func body(content: Content) -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 20.0)
                .fill(rotationAngle < 90 ? Color.blue : Color.cyan)
                .animation(.none)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.cyan, lineWidth: 5))
            Text(frontText)
                .font(.title)
                .opacity(rotationAngle < 90 ? 1.0 : 0.0)
                .animation(.none)
            Text(backText)
                .font(.subheadline)
                .padding()
                .opacity(rotationAngle < 90 ? 0.0 : 1.0)
                .scaleEffect(CGSize(width: -1.0, height: 1.0))
                .animation(.none)
        }
    }
    
    private func getCardColor() -> Color {
        rotationAngle < 90 ? Color.blue : Color.cyan
    }
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardView()
    }
}
