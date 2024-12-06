import Foundation

func daysUntilNextBirthday(from dateOfBirth: Date) -> Int {
    let calendar = Calendar.current
    let now = Date()

    let birthdayComponents = calendar.dateComponents([.month, .day], from: dateOfBirth)
    var nextBirthdayComponents = birthdayComponents
    nextBirthdayComponents.year = calendar.component(.year, from: now)

    var nextBirthday = calendar.date(from: nextBirthdayComponents)!
    if nextBirthday < now {
        nextBirthdayComponents.year! += 1
        nextBirthday = calendar.date(from: nextBirthdayComponents)!
    }

    return calendar.dateComponents([.day], from: now, to: nextBirthday).day ?? 0
}

func calculateAge(on dateOfBirth: Date) -> Int {
    let calendar = Calendar.current
    let now = Date()

    let currentAge = calendar.dateComponents([.year], from: dateOfBirth, to: now).year ?? 0

    let birthdayComponents = calendar.dateComponents([.month, .day], from: dateOfBirth)
    var nextBirthdayComponents = birthdayComponents
    nextBirthdayComponents.year = calendar.component(.year, from: now)

    if let nextBirthday = calendar.date(from: nextBirthdayComponents), nextBirthday < now {
        return currentAge + 1
    }

    return currentAge
}
