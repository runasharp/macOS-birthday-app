import SwiftUI

struct EditFriendView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    var friend: Friend

    @State private var firstName: String
    @State private var lastName: String
    @State private var dateOfBirth: Date
    @State private var photo: NSImage?

    init(friend: Friend) {
        self.friend = friend
        _firstName = State(initialValue: friend.firstName ?? "")
        _lastName = State(initialValue: friend.lastName ?? "")
        _dateOfBirth = State(initialValue: friend.dateOfBirth ?? Date())
        if let photoData = friend.photo {
            _photo = State(initialValue: NSImage(data: photoData))
        }
    }

    var body: some View {
        Form {
            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
            DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)

            HStack {
                Text("Photo")
                Spacer()
                if let photo = photo {
                    Image(nsImage: photo)
                        .resizable()
                        .scaledToFill() // или .scaledToFit(), смотря что нужно
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                Button("Select Photo") {
                    if let selected = selectPhoto() {
                        photo = selected
                    }
                }
            }

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.red)

                Spacer()

                Button("Save") {
                    updateFriend()
                    dismiss()
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.blue)
            }
        }
        .padding()
    }

    private func updateFriend() {
        friend.firstName = firstName
        friend.lastName = lastName
        friend.dateOfBirth = dateOfBirth
        friend.photo = photo?.toData()

        do {
            try viewContext.save()
        } catch {
            print("Failed to update friend: \(error)")
        }
    }
}
