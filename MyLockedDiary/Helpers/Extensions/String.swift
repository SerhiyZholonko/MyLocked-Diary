//
//  String.swift
//  MyLockedDiary
//
//  Created by apple on 22.09.2024.
//

import SwiftUI


extension String {
    // Convert hex string to Color
    func toColor() -> Color {
        var hex = self.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        return Color(red: red, green: green, blue: blue)
    }
}
