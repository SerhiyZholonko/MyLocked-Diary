//
//  File.swift
//  MyLockedDiary
//
//  Created by apple on 06.08.2024.
//

import SwiftUI

struct TransparentTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var isNumberingEnabled: Bool
    @State private var itemCount: Int = 1
    @Binding var shouldFocus: Bool // Control focus
    var font: UIFont // Add a font property
    var fontColor: Color
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.delegate = context.coordinator
        textView.text = isNumberingEnabled ? "   1. " : ""
        return textView
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
          

            if parent.isNumberingEnabled && text == "\n" {
                if currentLine.trimmingCharacters(in: .whitespaces).isEmpty {
                    parent.isNumberingEnabled = false
                    parent.itemCount = 1
                    textView.text.append("\n")
                    parent.text = textView.text
                    return false
                }

                if currentLine.trimmingCharacters(in: .whitespaces) == "\(parent.itemCount)." {
                    textView.text = nsText.replacingCharacters(in: NSRange(location: range.location - currentLine.count, length: currentLine.count), with: "")
                    parent.isNumberingEnabled = false
                    parent.itemCount = 1
                    parent.text = textView.text
                    return false
                }
                if !currentLine.trimmingCharacters(in: .whitespaces).contains("\(parent.itemCount).") {
                    let newText = "\n" + currentLine // Add a newline before the current line
                    textView.text = nsText.replacingCharacters(in: NSRange(location: range.location - currentLine.count, length: currentLine.count), with: newText)
                    parent.isNumberingEnabled = false
                    parent.itemCount = 1
                    parent.text = textView.text
                    return false
                }


                parent.itemCount += 1
                let newText = "   \(parent.itemCount). "
                textView.text = nsText.replacingCharacters(in: range, with: "\n\(newText)")
                parent.text = textView.text
                return false
            }

            return true
        }
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}
