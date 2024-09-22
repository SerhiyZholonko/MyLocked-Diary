//
//  NodeSchemeVersions.swift
//  MyLockedDiary
//
//  Created by apple on 15.09.2024.
//

import SwiftUI
import SwiftData


enum NodeSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version {
        Schema.Version(1, 0, 0)  // Example version 1.0.0
      }
    
    static var models: [any PersistentModel.Type] {
        [Note.self]
    }
    
    @Model
    class Note: Identifiable {
        var title: String
        var noteText: String

        init(
            title: String,
            noteText: String
        ) {
            self.title = title
            self.noteText = noteText
        }
    }
    
    
}

enum NodeSchemaV2: VersionedSchema {
    static var versionIdentifier: Schema.Version {
        Schema.Version(2, 0, 0)  // Example version 1.0.0
      }
    
    static var models: [any PersistentModel.Type] {
        [Note.self]
    }
    
    @Model
    class Note: Identifiable {
        var title: String
        var noteText: String
        var date: Date  // Add the new property

        init(
            title: String,
            noteText: String,
            date: Date = Date() // Default to the current date
        ) {
            self.title = title
            self.noteText = noteText
            self.date = date
        }
    }
}

enum NodeSchemaV3: VersionedSchema {
    static var versionIdentifier: Schema.Version {
        Schema.Version(3, 0, 0)  // Example version 1.0.0
    }

    static var models: [any PersistentModel.Type] {
        [Note.self]
    }

    @Model
    class Note: Identifiable {
        var title: String
        var noteText: String
        var date: Date
        var energyColor: String // Store the color as a hex string
        var energyImageName: String
        var emoji: String
        init(
            title: String,
            noteText: String,
            date: Date,
            energyColor: Color,
            energyImageName: String,
            emoji: String
        ) {
            self.title = title
            self.noteText = noteText
            self.date = date
            self.energyColor = energyColor.toHex() ?? "#000000" // Use a default value if conversion fails
            self.energyImageName = energyImageName
            self.emoji = emoji
        }
    }
}
