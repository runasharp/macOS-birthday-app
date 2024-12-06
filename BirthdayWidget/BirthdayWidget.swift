import WidgetKit
import SwiftUI
import CoreData

struct FriendData {
    let firstName: String
    let lastName: String
    let daysUntil: Int
    let image: Image?
    let dateOfBirth: Date
}

struct FriendEntry: TimelineEntry {
    let date: Date
    let friends: [FriendData]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> FriendEntry {
        FriendEntry(date: Date(), friends: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (FriendEntry) -> Void) {
        let friends = loadFriends()
        let entry = FriendEntry(date: Date(), friends: friends)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<FriendEntry>) -> Void) {
        let friends = loadFriends()
        let entry = FriendEntry(date: Date(), friends: friends)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

    private func loadFriends() -> [FriendData] {
        // Use the same App Group as your app
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.runa.BirthdayApp") else {
            return []
        }

        let storeURL = containerURL.appendingPathComponent("BirthdayApp.sqlite")

        guard let modelURL = Bundle.main.url(forResource: "BirthdayApp", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            return []
        }

        let container = NSPersistentContainer(name: "BirthdayApp", managedObjectModel: model)
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]

        var result: [FriendData] = []
        let semaphore = DispatchSemaphore(value: 0)

        container.loadPersistentStores { _, error in
            if let error = error {
                print("Widget: Error loading store: \(error)")
                semaphore.signal()
                return
            }

            let context = container.viewContext
            let fetchRequest = NSFetchRequest<Friend>(entityName: "Friend")

            do {
                let fetched = try context.fetch(fetchRequest)

                // Sort by days until next birthday, then by first name
                let sorted = fetched.sorted {
                    let d1 = daysUntilNextBirthday(from: $0.dateOfBirth ?? Date())
                    let d2 = daysUntilNextBirthday(from: $1.dateOfBirth ?? Date())
                    if d1 == d2 {
                        return ($0.firstName ?? "") < ($1.firstName ?? "")
                    }
                    return d1 < d2
                }

                // Take the first 3 for the widget
                result = sorted.prefix(3).map { friend in
                    let image: Image? = {
                        if let data = friend.photo, let nsImage = NSImage(data: data) {
                            return Image(nsImage: nsImage)
                        }
                        return nil
                    }()
                    
                    return FriendData(
                        firstName: friend.firstName ?? "",
                        lastName: friend.lastName ?? "",
                        daysUntil: daysUntilNextBirthday(from: friend.dateOfBirth ?? Date()),
                        image: image,
                        dateOfBirth: friend.dateOfBirth ?? Date()
                    )
                }
            } catch {
                print("Widget: Fetch error: \(error)")
            }

            semaphore.signal()
        }

        semaphore.wait()
        return result
    }
}

struct BirthdayWidgetEntryView: View {
    var entry: FriendEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if entry.friends.isEmpty {
                Text("No upcoming birthdays")
                    .font(.caption)
            } else {
                ForEach(entry.friends.indices, id: \.self) { i in
                    HStack {
                        if let img = entry.friends[i].image {
                            img
                                .resizable()
                                .frame(width: 24, height: 24)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray)
                        }

                        VStack(alignment: .leading) {
                            Text("\(entry.friends[i].firstName) \(entry.friends[i].lastName)")
                                .font(.caption)
                            Text("\(entry.friends[i].daysUntil) days left")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("Turns \(calculateAge(on: entry.friends[i].dateOfBirth)) years old")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

@main
struct BirthdayWidget: Widget {
    let kind: String = "BirthdayWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                BirthdayWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                BirthdayWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Upcoming Birthdays")
        .description("Shows birthdays from your shared data.")
    }
}
