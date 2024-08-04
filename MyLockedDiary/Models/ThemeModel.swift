//
//  ThemeModel.swift
//  MyLockedDiary
//
//  Created by apple on 29.07.2024.
//

import SwiftUI


class ThemeModel: ObservableObject, Identifiable, Hashable {
    let id = UUID()
    let color: [Color]
    let bgImageName: String
    let imageName: String
    

    init(bgImageName: String, color: [Color], imageName: String) {
        self.color = color
        self.bgImageName = bgImageName
        self.imageName = imageName
    }

    // Implement the Equatable protocol
    static func == (lhs: ThemeModel, rhs: ThemeModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.color == rhs.color &&
               lhs.bgImageName == rhs.bgImageName &&
               lhs.imageName == rhs.imageName
    }

    // Implement the Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(color)
        hasher.combine(bgImageName)
        hasher.combine(imageName)
    }
}
