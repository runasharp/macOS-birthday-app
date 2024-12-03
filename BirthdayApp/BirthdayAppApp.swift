//
//  BirthdayAppApp.swift
//  BirthdayApp
//
//  Created by Anastasia Ivanova on 03.12.24.
//

import SwiftUI

@main
struct BirthdayAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
