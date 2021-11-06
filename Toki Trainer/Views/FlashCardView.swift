//
//  FlashCardView.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/5/21.
//

import SwiftUI

struct FlashCardView: View {
    
    //@ObservedObject var tokiDictViewModel = TokiDictionaryViewModel()
    @ObservedObject var flashCardsViewModel = FlashCardsViewModel()
    
    var body: some View {
        VStack {
            //FlashCard(canBeFlipped: true, dictionaryEntry: tokiDictViewModel.dictionary.first!)
            FlashCardStack(dictionary: flashCardsViewModel.randomDictionary)
        }
    }
}

struct FlashCardStack: View {
    
    var dictionary: [TokiDictEntry]
    @State private var flashCards: [FlashCard] = []
    @State private var topFlashCard: FlashCard? = nil
    @State private var flashCardStack: [FlashCard] = []
    @State private var flashCardsCanBeFlipped: [Bool] = []
    @State private var flashCardsVertOffset: [CGFloat] = []
    
    @State private var currentFlashCard = 0
    
    let timer = Timer.publish(every: 1, tolerance: 0.1, on: .main, in: .common, options: nil).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                if(flashCards.count > 0) {
                    ForEach(flashCards.indices, id: \.self) { index in
                        flashCards[index]
                            .offset(x: 0, y: flashCardsVertOffset[index])
                    }
                }
    //                if(flashCards.count > 1) {
//                    flashCards[currentFlashCard]
//                        .offset(x: 0, y: flashCardsVertOffset[currentFlashCard])
//                        .animation(.default)
//                    flashCards[currentFlashCard + 1]
//                        .offset(x: 0, y: flashCardsVertOffset[currentFlashCard + 1])
//                        .animation(.default)
//                }
            }
            Spacer()
            Button {
                //self.currentFlashCard += 1
                nextFlashCard()
            } label: {
                Text("Next Card")
            }
            .background(.white)
        }
        .onAppear {
            initFlashCardsArray()
        }
    }
    
    func initFlashCardsArray() {
        flashCards = []
        for index in dictionary.indices {
            flashCardsCanBeFlipped.append(false)
            flashCards.append(FlashCard(canBeFlipped: $flashCardsCanBeFlipped[index], dictionaryEntry: dictionary[index]))
            flashCardsVertOffset.append(800)
        }
    }
    
    func nextFlashCard() {
        if(currentFlashCard > 0 ) {
            flashCardsVertOffset[currentFlashCard - 1] = -1000
        }
        flashCardsVertOffset[currentFlashCard] = 300
        flashCards[currentFlashCard].setCanBeFlipped(true)
        currentFlashCard += 1
        //flashCardsVertOffset[currentFlashCard + 1] = 300
    }
    
    func setTopFlashCard(card: FlashCard?) {
        if let safeCard = card {
            self.topFlashCard?.canBeFlipped = false
            self.topFlashCard = safeCard
            self.topFlashCard?.canBeFlipped = true
        }
    }
}

struct FlashCard: View {
    let screen = UIScreen.main.bounds
    
    @State var isFaceDown = false
    @State var rotationAngle: Double = 0
    @Binding var canBeFlipped: Bool
    
    var dictionaryEntry: TokiDictEntry
    
    var body: some View {
        
        let flipDegrees = isFaceDown ? 0.0 : 180.0
        
        Text("")
            .modifier(CardFlipModifier(isFaceDown: isFaceDown, frontText: dictionaryEntry.word, backText: concatenateDefinitions()))
            .frame(width: 0.8 * screen.width, height: 200.0)
            .font(.title)
            .rotation3DEffect(self.isFaceDown ? Angle(degrees: 180) : Angle(degrees: 0), axis: (x: 0.0, y: 10.0, z: 0.0))
            .animation(.default)
            .onTapGesture {
                print("onTapGesture called")
                if self.canBeFlipped == true {
                    self.isFaceDown.toggle()
                }
            }
        
    }
    
    func concatenateDefinitions() -> String {
        var result = String()
        for definition in dictionaryEntry.definitions {
            result.append(contentsOf: definition.definition)
        }
        return result
    }
    
    func setCanBeFlipped(_ input: Bool) {
        print("setCanBeFlipped called")
        self.canBeFlipped.toggle()
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
