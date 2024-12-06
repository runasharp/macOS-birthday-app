//import WidgetKit
//import SwiftUI
//
//
//struct NewBirthdayEntry: TimelineEntry {
//    let date: Date
//    let message: String
//}
//
//struct NewBirthdayProvider: TimelineProvider {
//    func placeholder(in context: Context) -> NewBirthdayEntry {
//        NewBirthdayEntry(date: Date(), message: "Hello, Widget!")
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping (NewBirthdayEntry) -> Void) {
//        let entry = NewBirthdayEntry(date: Date(), message: "Snapshot Message")
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<NewBirthdayEntry>) -> Void) {
//        let viewContext = SharedPersistenceController.shared.container.viewContext
//
//        let fetchRequest: NSFetchRequest<Friend> = Friend.fetchRequest()
//        do {
//            let friends = try viewContext.fetch(fetchRequest)
//            let friendNames = friends.map { $0.firstName ?? "Unknown" }.joined(separator: ", ")
//            let entry = NewBirthdayEntry(date: Date(), message: "Friends: \(friendNames)")
//            let timeline = Timeline(entries: [entry], policy: .atEnd)
//            completion(timeline)
//        } catch {
//            let entry = NewBirthdayEntry(date: Date(), message: "Error fetching data")
//            let timeline = Timeline(entries: [entry], policy: .atEnd)
//            completion(timeline)
//        }
//    }
//}
//
//struct NewBirthdayWidgetEntryView: View {
//    var entry: NewBirthdayProvider.Entry
//
//    var body: some View {
//        Text(entry.message)
//            .font(.headline)
//            .padding()
//    }
//}
//
//@main
//struct NewBirthdayWidget: Widget {
//    let kind: String = "NewBirthdayWidget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: NewBirthdayProvider()) { entry in
//            NewBirthdayWidgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("Test Widget")
//        .description("A test widget to ensure basic functionality.")
//    }
//}
