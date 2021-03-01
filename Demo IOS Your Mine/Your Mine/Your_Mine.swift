//
//  Your_Mine.swift
//  Your Mine
//
//  Created by Phương Anh Tuấn on 28/02/2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let midnight = Calendar.current.startOfDay(for: currentDate)
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!

        let entries = [
                SimpleEntry(date: Date())
            ]

        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
                completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct Your_MineEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
        Color("WidgetBackground")
            .ignoresSafeArea()
        VStack {
            HStack {
            
                Image("ImageHeart4")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .mask(
                        RoundedRectangle(cornerRadius: 0)
                            .frame(width: 90, height: 56, alignment: .center)
                    )
                    .frame(width: 70, height: 56, alignment: .leading)
                VStack {
                    let dayCount = UserDefaults(suiteName:"group.pat.yourmine")?.string(forKey: "dayCount") ?? ""
                    Text(dayCount)
                        .font(.system(size: 20.0, weight: .semibold, design: .rounded))
                        .frame(width: 50, height: 20, alignment: .top)
                    Text("Days")
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 0.3327422738, blue: 0.3188608289, alpha: 1)))
                        .frame(width: 26, height: 28, alignment: .leading)
                        .font(.system(size: 10.0, weight: .semibold, design: .rounded))
                }
            }
            HStack {
                let maleImage = UserDefaults(suiteName:"group.pat.yourmine")?.string(forKey: "maleImage") ?? ""
                let maleImageDecoded : Data? = Data(base64Encoded: maleImage, options: .ignoreUnknownCharacters) ?? nil
                if maleImageDecoded != nil {
                    let decodedimage = UIImage(data: maleImageDecoded!)
                    if(decodedimage != nil) {
                        
                         Image(uiImage: decodedimage!)
                             .resizable()
                             .aspectRatio(contentMode: .fill)
                             .mask(
                                 RoundedRectangle(cornerRadius: 10)
                                     .frame(width: 56, height: 56, alignment: .center)
                             )
                             .frame(width: 63, height: 56, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                             .shadow(radius: 24)
                    }
                }

                let femaleImage = UserDefaults(suiteName:"group.pat.yourmine")?.string(forKey: "femaleImage") ?? ""
                let femaleImageDecoded : Data? = Data(base64Encoded: femaleImage, options: .ignoreUnknownCharacters) ?? nil
                if femaleImageDecoded != nil {
                    let decodedimage = UIImage(data: femaleImageDecoded!)
                    if(decodedimage != nil) {
                        
                         Image(uiImage: decodedimage!)
                             .resizable()
                             .aspectRatio(contentMode: .fill)
                             .mask(
                                 RoundedRectangle(cornerRadius: 10)
                                     .frame(width: 56, height: 56, alignment: .center)
                             )
                             .frame(width: 63, height: 56, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                             .shadow(radius: 24)
                    }
                }
            }
        }
        }
    }
}

@main
struct Your_Mine: Widget {
    let kind: String = "Your_Mine"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Your_MineEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Your_Mine_Previews: PreviewProvider {
    static var previews: some View {
        Your_MineEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
