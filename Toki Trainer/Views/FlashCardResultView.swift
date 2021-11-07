//
//  FlashCardResultView.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/7/21.
//

import SwiftUI

struct FlashCardResultView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var flashCardAnswers: FetchedResults<FlashCardAnswer>
    
    init() {
        self._flashCardAnswers = FetchRequest(entity: FlashCardAnswer.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FlashCardAnswer.word, ascending: true)], predicate: nil, animation: .none)
    }
    
    var body: some View {
        List(flashCardAnswers, id: \.self) { answer in
            Text(answer.word ?? "Unknown")
        }
    }
}

struct FlashCardResultView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardResultView()
    }
}
