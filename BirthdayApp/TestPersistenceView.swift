//import SwiftUI
//import CoreData
//
//struct TestPersistenceView: View {
//    @State private var log: String = ""
//
//    var body: some View {
//        VStack {
//            TextEditor(text: $log)
//                .frame(height: 300)
//                .border(Color.gray, width: 1)
//                .padding()
//
//            HStack {
//                Button("Test SharedPersistenceController") {
//                    testSharedPersistence()
//                }
//                .padding()
//
//                Button("Add Test Friend") {
//                    addTestFriend()
//                }
//                .padding()
//
//                Button("Clear Friends") {
//                    clearFriends()
//                }
//                .padding()
//            }
//        }
//        .padding()
//    }
//
//    /// Test if SharedPersistenceController is set up correctly
//    func testSharedPersistence() {
//        
//        let controller = SharedPersistenceController.shared        
//        let context = SharedPersistenceController.shared.container.viewContext
//        print("TestPersistenceView Context: \(context)")
//
//        log = ""
//        if let storeURL = controller.container.persistentStoreDescriptions.first?.url {
//            log += "Store URL: \(storeURL.absoluteString)\n"
//        } else {
//            log += "Store URL not found!\n"
//        }
//
//        // Check if data can be fetched
//        let fetchRequest: NSFetchRequest<Friend> = Friend.fetchRequest()
//        do {
//            let friends = try context.fetch(fetchRequest)
//            log += "Fetched \(friends.count) friends from Core Data.\n"
//            for friend in friends {
//                log += "Friend: \(friend.firstName ?? "Unknown") \(friend.lastName ?? "Unknown"), Birthday: \(friend.dateOfBirth?.description ?? "No Date")\n"
//            }
//        } catch {
//            log += "Failed to fetch friends: \(error.localizedDescription)\n"
//        }
//    }
//
//    /// Add a test friend to Core Data
//    func addTestFriend() {
//        let controller = SharedPersistenceController.shared
//        let context = controller.container.viewContext
//
//        let newFriend = Friend(context: context)
//        newFriend.firstName = "Test"
//        newFriend.lastName = "User"
//        newFriend.dateOfBirth = Calendar.current.date(byAdding: .year, value: -30, to: Date())
//
//        do {
//            try context.save()
//            log += "Added Test Friend: Test User\n"
//        } catch {
//            log += "Failed to add Test Friend: \(error.localizedDescription)\n"
//        }
//    }
//
//    /// Clear all friends from Core Data
//    func clearFriends() {
//        let controller = SharedPersistenceController.shared
//        let context = controller.container.viewContext
//
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Friend.fetchRequest()
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(deleteRequest)
//            try context.save()
//            log += "Cleared all friends from Core Data.\n"
//        } catch {
//            log += "Failed to clear friends: \(error.localizedDescription)\n"
//        }
//    }
//}
