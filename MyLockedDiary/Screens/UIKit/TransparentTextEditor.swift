//
//  File.swift
//  MyLockedDiary
//
//  Created by apple on 06.08.2024.
//

import SwiftUI

struct TransparentTextEditor: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var isNumberingEnabled: SelectedList
    @State private var itemCount: Int = 1
    @Binding var shouldFocus: Bool // Control focus
    var font: UIFont // Add a font property
    var fontColor: Color
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.delegate = context.coordinator
        textView.attributedText = formattedString()

        return textView
    }
    func formattedString() -> NSAttributedString {
        let listMarker = isNumberingEnabled.markForList // Get the attributed mark for the current case

        // Create another string and set attributes to it
        let text = NSAttributedString(string: " This is a sample text", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])

        // Combine the marker and the regular text
        let combinedString = NSMutableAttributedString()
        combinedString.append(listMarker)
        combinedString.append(text)

        return combinedString
    }
    func updateUIView(_ uiView: UITextView, context: Context) {
        
        uiView.text = text
        uiView.font = font // Update the font here if needed
        uiView.textColor = UIColor(fontColor)
        // Focus the UITextView if shouldFocus is true
        if shouldFocus {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TransparentTextEditor

        init(_ parent: TransparentTextEditor) {
            self.parent = parent
        }
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let nsText = textView.text as NSString
            let textBeforeCursor = nsText.substring(to: range.location)
            let lines = textBeforeCursor.components(separatedBy: "\n")
            let currentLine = lines.last ?? ""

            // Handling numbering or bullet points based on the `isNumberingEnabled` case
            if text == "\n" {
                switch parent.isNumberingEnabled {
                case .numbered:
                    if currentLine.trimmingCharacters(in: .whitespaces).isEmpty {
                        resetNumbering()
                        textView.text.append("\n")
                        parent.text = textView.text
                        return false
                    }

                    if currentLine.trimmingCharacters(in: .whitespaces) == "\(parent.itemCount)." {
                        resetNumbering()
                        textView.text = nsText.replacingCharacters(in: NSRange(location: range.location - currentLine.count, length: currentLine.count), with: "")
                        parent.text = textView.text
                        return false
                    }

                    parent.itemCount += 1
                    let newText = "   \(parent.itemCount). "
                    textView.text = nsText.replacingCharacters(in: range, with: "\n\(newText)")
                    parent.text = textView.text
                    return false

                case .simpleNumbered:
                    if currentLine.trimmingCharacters(in: .whitespaces).isEmpty {
                        resetNumbering()
                        textView.text.append("\n")
                        parent.text = textView.text
                        return false
                    }

                    if currentLine.trimmingCharacters(in: .whitespaces) == "\(parent.itemCount))" {
                        resetNumbering()
                        textView.text = nsText.replacingCharacters(in: NSRange(location: range.location - currentLine.count, length: currentLine.count), with: "")
                        parent.text = textView.text
                        return false
                    }

                    parent.itemCount += 1
                    let newText = "   \(parent.itemCount)) "
                    textView.text = nsText.replacingCharacters(in: range, with: "\n\(newText)")
                    parent.text = textView.text
                    return false

                case .star:
                    if currentLine.trimmingCharacters(in: .whitespaces).isEmpty {
                        resetNumbering()
                        textView.text.append("\n")
                        parent.text = textView.text
                        return false
                    }

                    if currentLine.trimmingCharacters(in: .whitespaces) == "★" {
                        resetNumbering()
                        textView.text = nsText.replacingCharacters(in: NSRange(location: range.location - currentLine.count, length: currentLine.count), with: "")
                        parent.text = textView.text
                        return false
                    }
                    
                    let newText = "\n   ★ "
                    textView.text = nsText.replacingCharacters(in: range, with: newText)
                    parent.text = textView.text
                    return false

                case .point:
                    if currentLine.trimmingCharacters(in: .whitespaces).isEmpty {
                        resetNumbering()
                        textView.text.append("\n")
                        parent.text = textView.text
                        return false
                    }
                    if currentLine.trimmingCharacters(in: .whitespaces) == "●" {
                        resetNumbering()
                        textView.text = nsText.replacingCharacters(in: NSRange(location: range.location - currentLine.count, length: currentLine.count), with: "")
                        parent.text = textView.text
                        return false
                    }
                    let newText = "\n   ● "
                    textView.text = nsText.replacingCharacters(in: range, with: newText)
                    parent.text = textView.text
                    return false

                case .heart:
                    if currentLine.trimmingCharacters(in: .whitespaces).isEmpty {
                        resetNumbering()
                        textView.text.append("\n")
                        parent.text = textView.text
                        return false
                    }
                    if currentLine.trimmingCharacters(in: .whitespaces) == "❤️" {
                        resetNumbering()
                        textView.text = nsText.replacingCharacters(in: NSRange(location: range.location - currentLine.count, length: currentLine.count), with: "")
                        parent.text = textView.text
                        return false
                    }
                    let newText = "\n   ❤️ "
                    textView.text = nsText.replacingCharacters(in: range, with: newText)
                    parent.text = textView.text
                    return false

                case .greenPoint:
                    if currentLine.trimmingCharacters(in: .whitespaces).isEmpty {
                        resetNumbering()
                        textView.text.append("\n")
                        parent.text = textView.text
                        return false
                    }
                    if currentLine.trimmingCharacters(in: .whitespaces) == "🟢" {
                        resetNumbering()
                        textView.text = nsText.replacingCharacters(in: NSRange(location: range.location - currentLine.count, length: currentLine.count), with: "")
                        parent.text = textView.text
                        return false
                    }
                    let newText = "\n   🟢 "
                    textView.text = nsText.replacingCharacters(in: range, with: newText)
                    parent.text = textView.text
                    return false

                case .none:
                    return true
                }
            }

            return true
        }

        // Helper function to reset numbering when needed
        private func resetNumbering() {
            parent.isNumberingEnabled = .none
            parent.itemCount = 1
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}
