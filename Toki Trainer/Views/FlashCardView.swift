//
//  FlashCardView.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/5/21.
//

import SwiftUI
import CoreData

enum FlashCardResult {
    case Correct
    case Incorrect
    case Unanswered
}

struct FlashCardView: View {
    
    @ObservedObject var flashCardsViewModel = FlashCardsViewModel()
    
    var body: some View {
        VStack {
            FlashCardStack(dictionary: flashCardsViewModel.randomDictionary)
        }
    }
}

extension Binding {
    func onChange(_ handler: @escaping () -> ()) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            })
    }
}

struct FlashCardStack: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity:FlashCardAnswer.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FlashCardAnswer.word, ascending: false)]) var flashCardAnswers: FetchedResults<FlashCardAnswer>
    
    var dictionary: [TokiDictEntry]
    @State private var flashCards: [FlashCard] = []
    @State private var topFlashCard: FlashCard? = nil
    @State private var flashCardStack: [FlashCard] = []
    @State private var flashCardsAreInteractive: [Bool] = []
    @State private var flashCardsVertOffset: [CGFloat] = []
    @State private var flashCardsResults: [FlashCardResult] = []
    @State private var fadeOutOverlay = false
    
    @State private var currentFlashCard = 0
    
    var body: some View {
        VStack {
            ZStack {
                if(flashCards.count > 0) {
                    ForEach(flashCards.indices, id: \.self) { index in
                        flashCards[index]
                            .offset(x: 0, y: flashCardsVertOffset[index])
                            .zIndex(-(CGFloat(index * 100)))
                    }
                }
            }
            .overlay(HStack {
                Image(systemName: "arrow.backward")
                Text("Incorrect")
                Spacer()
                Text("Correct")
                Image(systemName: "arrow.right")
            }.opacity(fadeOutOverlay ? 0.0 : 1.0), alignment: .top)
        }
        Spacer()
        .onAppear {
            initFlashCards()
        }
    }
    
    func initFlashCards() {
        flashCards = []
        for index in dictionary.indices {
            flashCardsAreInteractive.append(false)
            flashCardsResults.append(FlashCardResult.Unanswered)
            flashCards.append(FlashCard(isInteractive: $flashCardsAreInteractive[index], result: $flashCardsResults[index].onChange(cardAnswerReceived), dictionaryEntry: dictionary[index]))
            flashCardsVertOffset.append(470)
        }
        if flashCards.count - currentFlashCard >= 3 {
            flashCardsVertOffset[currentFlashCard + 1] = 410
            flashCardsVertOffset[currentFlashCard + 2] = 440
            flashCardsVertOffset[currentFlashCard + 3] = 470
        } else if flashCards.count - currentFlashCard == 2 {
            flashCardsVertOffset[currentFlashCard + 1] = 410
            flashCardsVertOffset[currentFlashCard + 2] = 440
        } else if flashCards.count - currentFlashCard == 1 {
            flashCardsVertOffset[currentFlashCard + 1] = 410
        }
        
        flashCardsVertOffset[currentFlashCard] = 100
        flashCardsAreInteractive[currentFlashCard] = true
    }
    
    func setFlashCardAnswersCoreData(_ correct: Bool) {
        var cardInDatabase = false
        for answer in flashCardAnswers {
            print(answer.word)
            if answer.word == dictionary[currentFlashCard].word {
                cardInDatabase = true
                answer.setValue((answer.triesCount + 1), forKey: "triesCount")
                if correct {
                    answer.setValue((answer.correctCount + 1), forKey: "correctCount")
                }
                print("answer found in database")
            }
        }
        
        if cardInDatabase == false {
            let answer = FlashCardAnswer(context: viewContext)
            answer.word = dictionary[currentFlashCard].word
            answer.triesCount = 1
            if correct {
                answer.correctCount = 1
            }
            print("answer not found in database")
        }
        
//        for answer in flashCardAnswers {
//            if answer.word == dictionary[currentFlashCard].word {
//                flashCardAnswer.word = answer.word
//                flashCardAnswer.triesCount = answer.triesCount + 1
//                if correct {
//                    flashCardAnswer.correctCount = answer.correctCount + 1
//                }
//            }
//        }
        try? viewContext.save()
    }
    
    func cardAnswerReceived() {
        if flashCardsResults[currentFlashCard] == FlashCardResult.Correct {
            setFlashCardAnswersCoreData(true)
        } else if flashCardsResults[currentFlashCard] == FlashCardResult.Incorrect {
            setFlashCardAnswersCoreData(false)
        } else {
            return
        }
        nextFlashCard()
    }
    
    func nextFlashCard() {
        currentFlashCard += 1
        if(currentFlashCard > 0 ) {
            flashCardsVertOffset[currentFlashCard - 1] = -1000
        }
        flashCardsVertOffset[currentFlashCard] = 100
        flashCardsAreInteractive[currentFlashCard] = true
        
        self.fadeOutOverlay = true
        
        if flashCards.count - currentFlashCard >= 3 {
            flashCardsVertOffset[currentFlashCard + 1] = 410
            flashCardsVertOffset[currentFlashCard + 2] = 440
            flashCardsVertOffset[currentFlashCard + 3] = 470
        } else if flashCards.count - currentFlashCard == 2 {
            flashCardsVertOffset[currentFlashCard + 1] = 410
            flashCardsVertOffset[currentFlashCard + 2] = 440
        } else if flashCards.count - currentFlashCard == 1 {
            flashCardsVertOffset[currentFlashCard + 1] = 410
        }
    }
    
    func setTopFlashCard(card: FlashCard?) {
        if let safeCard = card {
            self.topFlashCard?.isInteractive = false
            self.topFlashCard = safeCard
            self.topFlashCard?.isInteractive = true
        }
    }
}

struct FlashCard: View {
    let screen = UIScreen.main.bounds
    
    @State var isFaceDown = false
    @State var rotationAngle: Double = 0
    @Binding var isInteractive: Bool
    @Binding var result: FlashCardResult
    
    var dictionaryEntry: TokiDictEntry
    
    @State private var dragAmount = CGFloat(0)
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if isInteractive {
                    self.dragAmount = gesture.translation.width
                }
            }
            .onEnded { gesture in
                withAnimation {
                    if isInteractive {
                        if self.dragAmount < -20 {
                            self.dragAmount = -500
                            self.result = FlashCardResult.Incorrect
                        } else if self.dragAmount > 20 {
                            self.dragAmount = 500
                            self.result = FlashCardResult.Correct
                        } else {
                            self.dragAmount = 0
                        }
                    }
                }
            }
    }
    
    var body: some View {
        
        Text("")
            .modifier(CardFlipModifier(isFaceDown: isFaceDown, frontText: dictionaryEntry.word, backText: concatenateDefinitions()))
            .frame(width: 0.8 * screen.width, height: 200.0)
            .offset(x: isFaceDown ? -dragAmount : dragAmount, y: abs(dragAmount) / 10)
            .rotationEffect(.degrees(isFaceDown ? -(dragAmount / 50) : dragAmount / 50))
            .font(.title)
            .rotation3DEffect(self.isFaceDown ? Angle(degrees: 180) : Angle(degrees: 0), axis: (x: 0.0, y: 10.0, z: 0.0))
            .animation(.default)
            .onTapGesture {
                if self.isInteractive == true {
                    self.isFaceDown.toggle()
                }
            }
            .gesture(drag)
        
    }
    
    func concatenateDefinitions() -> String {
        var result = String()
        for definition in dictionaryEntry.definitions {
            result.append(contentsOf: "\(definition.definition)\n")
        }
        return result
    }
    
    func setCanBeFlipped(_ input: Bool) {
        self.isInteractive.toggle()
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
                .animation(.none, value: rotationAngle)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.cyan, lineWidth: 5))
                .animation(.none, value: rotationAngle)
            Text(frontText)
                .font(.title)
                .opacity(rotationAngle < 90 ? 1.0 : 0.0)
                .animation(.none, value: rotationAngle)
            Text(backText)
                .font(.subheadline)
                .padding()
                .opacity(rotationAngle < 90 ? 0.0 : 1.0)
                .animation(.none, value: rotationAngle)
                .scaleEffect(CGSize(width: -1.0, height: 1.0))
        }
    }
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
