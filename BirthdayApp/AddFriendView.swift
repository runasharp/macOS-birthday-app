import SwiftUI
import AppKit

struct AddFriendView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var dateOfBirth = Date()
    @State private var photo: NSImage?
    @State private var showImageEditor = false
    @State private var selectedPhoto: NSImage? = nil

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
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }

                Button("Select Photo") {
                    if let chosen = selectPhoto() {
                        selectedPhoto = chosen
                        showImageEditor = true
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
                    addFriend()
                    dismiss()
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.blue)
            }
        }
        .padding()
        // Модификатор sheet должен быть на уровне вью
        .sheet(isPresented: $showImageEditor) {
            if let editablePhoto = selectedPhoto {
                ImageEditorView(originalImage: editablePhoto)
            } else {
                Text("No photo selected")
            }
        }
    }

    private func addFriend() {
        let newFriend = Friend(context: viewContext)
        newFriend.firstName = firstName
        newFriend.lastName = lastName
        newFriend.dateOfBirth = dateOfBirth
        newFriend.photo = photo?.toData()

        do {
            try viewContext.save()
        } catch {
            print("Failed to save friend: \(error)")
        }
    }
}
