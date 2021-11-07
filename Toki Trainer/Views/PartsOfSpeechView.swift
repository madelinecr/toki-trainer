//
//  PartsOfSpeechView.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/4/21.
//

import SwiftUI

struct PartsOfSpeechView: View {
    var selectedPartOfSpeech: String? = nil
    
    @ObservedObject var tokiDictViewModel = TokiDictionaryViewModel()
    
    var partsOfSpeech: [TokiPartOfSpeech]
    
    var body: some View {
        VStack {
            Text("Parts of Speech")
                .padding()
            VStack(alignment: .leading) {
                ForEach(tokiDictViewModel.partsOfSpeech, id: \.pos) { pos in
                    HStack {
                        Text(pos.pos)
                            .frame(width: 45, height: 22, alignment: .center)
                            .background(Color(K.posColors[pos.pos]!))
                            .cornerRadius(5.0)
                            .padding(1)
                        Text(pos.definition)
                        Spacer()
                    }
                    //.background(.blue)
                    .background((selectedPartOfSpeech == pos.pos) ? Color(UIColor.systemGray4) : Color(UIColor.systemBackground))
                    .cornerRadius(5.0)
                    .padding(2)
                }
            }
            Spacer()
        }
    }
}

struct PartsOfSpeechView_Previews: PreviewProvider {
    static var previews: some View {
        PartsOfSpeechView(selectedPartOfSpeech: "sep", partsOfSpeech: [TokiPartOfSpeech(pos: "sep", definition: "test")])
            .preferredColorScheme(.dark)
        PartsOfSpeechView(selectedPartOfSpeech: "sep", partsOfSpeech: [TokiPartOfSpeech(pos: "sep", definition: "test")])
    }
}
