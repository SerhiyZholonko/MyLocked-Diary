//
//  Color.swift
//  MyLockedDiary
//
//  Created by apple on 03.08.2024.
//

import SwiftUI

extension Color {
    // Lime color group

    static let lime1 = Color(red: 246 / 255, green: 233 / 255, blue: 107 / 255)
    static let lime2 = Color(red: 190 / 255, green: 220 / 255, blue: 116 / 255)
    static let lime3 = Color(red: 162 / 255, green: 202 / 255, blue: 113 / 255)
    static let lime4 = Color(red: 56 / 255, green: 127 / 255, blue: 57 / 255)
    
    static let limeColors: [Color] = [lime1, lime2, lime3, lime4]
    
    // Sky color group
       static let sky1 = Color(red: 180 / 255, green: 214 / 255, blue: 205 / 255)
       static let sky2 = Color(red: 255 / 255, green: 218 / 255, blue: 118 / 255)
       static let sky3 = Color(red: 255 / 255, green: 140 / 255, blue: 158 / 255)
       static let sky4 = Color(red: 255 / 255, green: 140 / 255, blue: 158 / 255)
       
       static let skyColors: [Color] = [sky1, sky2, sky3, sky4]
    
    // Orange color group
       static let orange1 = Color(red: 255 / 255, green: 178 / 255, blue: 0 / 255)
       static let orange2 = Color(red: 235 / 255, green: 91 / 255, blue: 0 / 255)
       static let orange3 = Color(red: 228 / 255, green: 0 / 255, blue: 58 / 255)
       static let orange4 = Color(red: 182 / 255, green: 0 / 255, blue: 113 / 255)
       
       static let orangeColors: [Color] = [orange1, orange2, orange3, orange4]
}

extension Color {
    // Convert Color to hex string
//    func toHex() -> String? {
//        guard let components = cgColor?.components, components.count >= 3 else {
//            return nil
//        }
//        let r = components[0]
//        let g = components[1]
//        let b = components[2]
//        return String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
//    }
    func toHex() -> String? {
        // Get UIColor from SwiftUI Color
        let uiColor = UIColor(self)
        // Convert UIColor to CGColor
        guard let components = uiColor.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
    // Convert hex string to Color
    static func fromHex(_ hex: String) -> Color {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        return Color(red: red, green: green, blue: blue)
    }
}
extension Color {
    init?(hex: String) {
        var hex = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        if hex.count == 6 { hex.append("FF") } // Add alpha if missing
        
        guard let int = UInt32(hex, radix: 16) else { return nil }
        let r = Double((int >> 24) & 0xFF) / 255.0
        let g = Double((int >> 16) & 0xFF) / 255.0
        let b = Double((int >> 8) & 0xFF) / 255.0
        let a = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
