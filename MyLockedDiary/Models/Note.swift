//
//  Note.swift
//  MyLockedDiary
//
//  Created by apple on 06.08.2024.
//

import Foundation
import SwiftData
import SwiftUI

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


