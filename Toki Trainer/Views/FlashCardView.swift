//
//  FlashCardView.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/5/21.
//

import SwiftUI

struct FlashCardView: View {
    let screen = UIScreen.main.bounds
    
    @State var flipped = false
    
    var body: some View {
        
        let flipDegrees = flipped ? 0.0 : 180.0
        
        ZStack() {
            Text("sina").opacity(flipped ? 0.0 : 1.0)
            Text("you")
                .opacity(flipped ? 1.0 : 0.0)
                .rotation3DEffect(Angle(degrees: -180 + flipDegrees), axis: (x: 0.0, y: 10.0, z: 0.0))
        }
        .frame(width: 0.8 * screen.width, height: 200.0)
        .font(.title)
        .background(self.flipped ? .cyan : .mint)
        .cornerRadius(20)
        .shadow(color: .gray, radius: 10.0, x: 10, y: 10)
        .rotation3DEffect(self.flipped ? Angle(degrees: 180) : Angle(degrees: 0), axis: (x: 0.0, y: 10.0, z: 0.0)
        )
        .animation(.default)
        .onTapGesture {
            self.flipped.toggle()
        }
        
    }
}

struct CardFlipModifier: AnimatableModifier {
    var rotationAngle: Double
    
    init(isFaceUp: Bool) {
        rotationAngle = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { rotationAngle }
        set { rotationAngle = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20.0)
                .fill(Color.blue.opacity(rotationAngle < 90 ? 0.5 : 1.0))
            content
                .opacity(rotationAngle < 90 ? 1.0 : 0.0)
        }
    }
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardView()
    }
}
