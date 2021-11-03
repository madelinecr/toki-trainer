//
//  ContentView.swift
//  Toki Trainer
//
//  Created by Avery Ada Pace on 11/2/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @ObservedObject var jsonLoader = TokiJSONLoader()
    
    var body: some View {
        List(jsonLoader.dictionary, id: \.word) { entry in
            VStack(alignment: .leading) {
                Text(entry.word)
                    .font(.title)
                ForEach(entry.definitions, id: \.pos) { definition in
                    HStack(alignment: .top) {
                        Text(definition.pos)
                        Text(definition.definition)
                    }
                }}

        }
        .onAppear {
            self.jsonLoader.loadDictionary()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
