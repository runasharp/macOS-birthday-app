
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var friends: FetchedResults<Friend>

    @State private var isAddingFriend = false
    @State private var selectedFriend: Friend?
    @State private var isDebugMode = false // State to toggle debug mode

    var sortedFriends: [Friend] {
        friends.sorted { first, second in
            let daysToFirst = daysUntilNextBirthday(from: first.dateOfBirth ?? Date())
            let daysToSecond = daysUntilNextBirthday(from: second.dateOfBirth ?? Date())

            if daysToFirst == daysToSecond {
                return (first.firstName ?? "") < (second.firstName ?? "")
            }
            return daysToFirst < daysToSecond
        }
    }

    var body: some View {
        VStack {
            if isDebugMode {
                // Debug mode UI
            } else {
                List {
                    ForEach(sortedFriends, id: \.self) { friend in
                        HStack {
                            if let photoData = friend.photo, let image = NSImage(data: photoData) {
                                Image(nsImage: image)
                                    .resizable()
                                    .scaledToFill() // или .scaledToFit(), смотря что нужно
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .scaledToFill() // или .scaledToFit(), смотря что нужно
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }

                            VStack(alignment: .leading) {
                                Text("\(friend.firstName ?? "") \(friend.lastName ?? "")")
                                    .font(.headline)
                                if let dateOfBirth = friend.dateOfBirth {
                                    Text("Next Birthday: \(daysUntilNextBirthday(from: dateOfBirth)) days")
                                        .font(.subheadline)
                                    Text("Turns \(calculateAge(on: dateOfBirth)) years old")
                                        .font(.caption)
                                }
                            }

                            Spacer()

                            // Pencil icon
                            Button(action: {
                                selectedFriend = friend
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(BorderlessButtonStyle())

                            // Trash icon
                            Button(action: {
                                delete(friend)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: { isAddingFriend.toggle() }) {
                            Label("Add Friend", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $isAddingFriend) {
                    AddFriendView()
                        .environment(\.managedObjectContext, viewContext)
                }
                .sheet(item: $selectedFriend) { friend in
                    EditFriendView(friend: friend)
                        .environment(\.managedObjectContext, viewContext)
                }
            }
        }
    }

    private func delete(_ friend: Friend) {
        withAnimation {
            viewContext.delete(friend)
            try? viewContext.save()
        }
    }
}
