//
//  FlashCardView.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/5/21.
//

import SwiftUI

struct FlashCardView: View {
    let screen = UIScreen.main.bounds
    
    @State var isFaceDown = false
    @State var rotationAngle: Double = 0
    
    var body: some View {
        
        let flipDegrees = isFaceDown ? 0.0 : 180.0
        
        Text("sina")
            .modifier(CardFlipModifier(isFaceDown: isFaceDown, frontText: "linja", backText: "long, very thin, floppy thing, e.g. string, rope, hair, thread, cord, chain"))
            .frame(width: 0.8 * screen.width, height: 200.0)
            .font(.title)
            .shadow(color: .gray, radius: 10.0, x: 10, y: 10)
            .rotation3DEffect(self.isFaceDown ? Angle(degrees: 180) : Angle(degrees: 0), axis: (x: 0.0, y: 10.0, z: 0.0))
            .animation(.default)
            .onTapGesture {
                self.isFaceDown.toggle()
            }
            
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
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardView()
    }
}
