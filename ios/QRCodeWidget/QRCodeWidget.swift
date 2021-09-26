//
//  QRCodeWidget.swift
//  QRCodeWidget
//
//  Created by atif on 26/09/2021.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData


struct FlutterData: Decodable, Hashable {
    let text: String
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let flutterData: FlutterData?
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), flutterData: FlutterData(text: "Hello from Flutter"));
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), flutterData: FlutterData(text: "Hello from Flutter"))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        
        let sharedDefaults = UserDefaults.init(suiteName: "group.com.conicqrcode")
        var flutterData: FlutterData? = nil
        
        if(sharedDefaults != nil) {
            do {
              let shared = sharedDefaults?.string(forKey: "qrCodeData")
              if(shared != nil){
                let decoder = JSONDecoder()
                flutterData = try decoder.decode(FlutterData.self, from: shared!.data(using: .utf8)!)
              }
            } catch {
              print(error)
            }
        }

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, flutterData: flutterData)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}



struct QRCodeWidgetEntryView : View {
   
    var entry: Provider.Entry
    
    private var FlutterDataView: some View {
        ZStack{
            Color("WidgetBackground")
            QRCodeView(code: entry.flutterData!.text).padding(12)
        }
        
    }
    
    private var NoDataView: some View {
        ZStack{
            Color("WidgetBackground")
            Text("Open Conic app to setup your profile")
                .multilineTextAlignment(.center)
                .font(.subheadline).padding(4)
        }
        
    }
    

    var body: some View {
        
      if(entry.flutterData == nil) {
        NoDataView
      } else {
        FlutterDataView
      }
    }
}

@main
struct QRCodeWidget: Widget {
    let kind: String = "QRCodeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            QRCodeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Conic")
        .description("Profile QR CODE ")
    }
}

struct QRCodeWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QRCodeWidgetEntryView(entry: SimpleEntry(date: Date(), flutterData: nil ))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            QRCodeWidgetEntryView(entry: SimpleEntry(date: Date(), flutterData: nil ))
                .preferredColorScheme(.dark)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
           
        }
    }
}
