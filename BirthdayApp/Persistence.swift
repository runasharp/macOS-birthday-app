import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Use the App Group container
        guard let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.runa.BirthdayApp") else {
            fatalError("Could not find App Group container URL.")
        }

        // Name must match your .xcdatamodeld name
        let modelName = "BirthdayApp"
        let storeURL = appGroupURL.appendingPathComponent("\(modelName).sqlite")

        // Load the model
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Model not found.")
        }

        container = NSPersistentContainer(name: modelName, managedObjectModel: model)

        let description = NSPersistentStoreDescription(url: storeURL)
        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        }

        // Optionally enable history tracking or other store options as needed
        // description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            print("Core Data Store Location: \(description.url?.absoluteString ?? "Unknown")")
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
