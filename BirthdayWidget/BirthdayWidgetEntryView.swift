struct BirthdayWidgetEntryView: View {
    var entry: BirthdayEntry

    var body: some View {
        if let friend = entry.friend {
            HStack {
                if let photo = friend.photo, let image = NSImage(data: photo) {
                    Image(nsImage: image)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                }

                VStack(alignment: .leading) {
                    Text("\(friend.firstName) \(friend.lastName)")
                        .font(.headline)
                    Text("\(friend.daysUntilNextBirthday) days until next birthday")
                        .font(.subheadline)
                    Text("Turns \(friend.age) years old")
                        .font(.caption)
                }
            }
            .padding()
        } else {
            Text("No upcoming birthdays")
                .font(.headline)
        }
    }
}
