//import CoreData
//
//struct SharedPersistenceController {
//    static let shared = SharedPersistenceController()
//
//    let container: NSPersistentContainer
//
//    init(inMemory: Bool = false) {
//        container = NSPersistentContainer(name: "BirthdayApp") // Use your Core Data model name
//
//        if let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.runa.BirthdayApp") {
//            let storeURL = appGroupURL.appendingPathComponent("BirthdayApp.sqlite")
//            print("Core Data store location: \(storeURL.absoluteString)")
//            container.persistentStoreDescriptions.first?.url = storeURL
//        } else {
//            print("App Group URL not found!")
//        }
//
//        if inMemory {
//            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
//        }
//
//        container.loadPersistentStores { description, error in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//    }
//}
