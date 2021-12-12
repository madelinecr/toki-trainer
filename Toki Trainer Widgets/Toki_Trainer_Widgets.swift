//
//  Toki_Trainer_Widgets.swift
//  Toki Trainer Widgets
//
//  Created by Avery Ada Pace on 12/3/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    var tokiJSONLoader = TokiJSONLoader()
    var tokiDictionary: [TokiDictEntry]
    
    init() {
        tokiDictionary = tokiJSONLoader.loadDictionary()!
    }
    
    func getRandomEntry(configuration: ConfigurationIntent) -> DefinitionEntry {
        let randomDictionary = tokiDictionary.shuffled()
        let entry = DefinitionEntry(date: Date(), configuration: configuration, word: randomDictionary.first!.word, definition: randomDictionary.first!.definitions[0].definition)
        return entry
    }
    
    func placeholder(in context: Context) -> DefinitionEntry {
        getRandomEntry(configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (DefinitionEntry) -> ()) {
        let entry = getRandomEntry(configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DefinitionEntry] = []

        for i in 0...5 {
            entries.append(getRandomEntry(configuration: configuration))
        }
        

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DefinitionEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let word: String
    let definition: String
}

struct Toki_Trainer_WidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color("LightPurple")
            VStack(alignment: .leading) {
                Text(entry.word)
                    .foregroundColor(Color("FontColorTitle"))
                    .font(.title)
                    .padding(8)
                Text(entry.definition)
                    .foregroundColor(Color("FontColorSubtitle"))
                    .padding(8)
            }
        }
    }
}

@main
struct Toki_Trainer_Widgets: Widget {
    let kind: String = "Toki_Trainer_Widgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Toki_Trainer_WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Toki Pona Random Word")
        .description("Gives you a random word of the moment.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct Toki_Trainer_Widgets_Previews: PreviewProvider {
    static var tokiDictionary: [TokiDictEntry] = TokiJSONLoader().loadDictionary()!.shuffled()
    
    static var previews: some View {
        Toki_Trainer_WidgetsEntryView(entry: DefinitionEntry(date: Date(), configuration: ConfigurationIntent(), word: tokiDictionary.first!.word, definition: tokiDictionary.first!.definitions[0].definition))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
