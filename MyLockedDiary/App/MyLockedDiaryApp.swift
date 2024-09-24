//
//  MyLockedDiaryApp.swift
//  MyLockedDiary
//
//  Created by apple on 29.07.2024.
//

import SwiftUI
import SwiftData
import CoreData

@main
struct MyLockedDiaryApp: App {
    let persistenceController = PersistenceController.shared
        init() {
            let container = persistenceController.container
            // Remove the existing store to fix the schema mismatch error
            if let storeURL = container.persistentStoreDescriptions.first?.url {
                try? FileManager.default.removeItem(at: storeURL)
            }
            print("URL Data: ", URL.applicationSupportDirectory.path(percentEncoded: false))
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Note.self)
        }
    }
}
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "MyLockedDiary") // Your Core Data model name
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
