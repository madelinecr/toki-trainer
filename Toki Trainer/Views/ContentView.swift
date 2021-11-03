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
                            .frame(width: 60, height: 22, alignment: .center)
                            .background(Color(K.posColors[definition.pos]!))
                            .cornerRadius(5.0)
                            .padding(4)
                        Text(definition.definition)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(4)
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
