//
//  ContentView.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/2/21.
//

import SwiftUI
import CoreData

extension String: Identifiable {
    public var id: String { self }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var tokiDictViewModel = TokiDictionaryViewModel()
    @State private var selectedPartOfSpeech: String? = nil
    @State private var tokiInput: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter Toki Pona Word or Phrase", text: $tokiInput)
                .multilineTextAlignment(.center)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .padding(8)
                .onSubmit {
                    tokiDictViewModel.filterDictionary(tokiInput)
                }
            List(tokiDictViewModel.dictionary, id: \.word) { entry in
                VStack(alignment: .leading) {
                    Text(entry.word)
                        .font(.title)
                    ForEach(entry.definitions, id: \.pos) { definition in
                        HStack(alignment: .top) {
                            Button(action: {
                                self.selectedPartOfSpeech = String(definition.pos)
                            }) {
                                Text(definition.pos)
                                    .frame(width: 45, height: 22, alignment: .center)
                                    .foregroundColor(.black)
                                    .background(Color(K.posColors[definition.pos]!))
                                    .cornerRadius(5.0)
                                    .padding(4)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            Text(definition.definition)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(4)
                        }
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack() {
                    Button("Parts of Speech") {
                        self.selectedPartOfSpeech = ""
                    }
                    .padding(8)
                }
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
            }
            .sheet(item: $selectedPartOfSpeech) { selectedPOS in
                PartsOfSpeechView(selectedPartOfSpeech: selectedPOS, tokiDictViewModel: self.tokiDictViewModel)
            }
        }
    }
    
    func openPartsOfSpeechView() {
        print("Button pressed.")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
