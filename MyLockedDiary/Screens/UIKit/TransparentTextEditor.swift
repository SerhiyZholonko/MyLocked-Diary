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

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.delegate = context.coordinator
        textView.text = isNumberingEnabled ? " 1. " : ""
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
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
            // Get the text in the textView before the current cursor position
            let nsText = textView.text as NSString
            let textBeforeCursor = nsText.substring(to: range.location)
            let lines = textBeforeCursor.components(separatedBy: "\n")

            // Check the previous line
            if parent.isNumberingEnabled && text == "\n" {
                let currentLine = lines.last ?? ""
                let previousLine = lines.dropLast().last ?? ""

                // If the previous line is empty and the current line contains only the itemCount, handle special case
                print("parent.itemCount : \(parent.itemCount).")
                print(currentLine.trimmingCharacters(in: .whitespaces) == "\(parent.itemCount).")
                if currentLine.trimmingCharacters(in: .whitespaces) == "\(parent.itemCount)." || currentLine.trimmingCharacters(in: .whitespaces) == ""{
                    parent.isNumberingEnabled.toggle()
                    if textView.text.count >= 5 {
                        textView.text.removeLast(5)
                    }
                    parent.itemCount = 1
                } else {
                    if previousLine.trimmingCharacters(in: .whitespaces).isEmpty
                        && currentLine.trimmingCharacters(in: .whitespaces) == "\(parent.itemCount)."
                    {
                        print("parent.itemCount : \(parent.itemCount).")
                        // Remove the current line with the itemCount
                        textView.text = nsText.replacingCharacters(in: NSRange(location: range.location - currentLine.count, length: currentLine.count + 1), with: "")
                        parent.text = textView.text
    //                    parent.itemCount -= 1
                        parent.isNumberingEnabled.toggle()
                        return false
                    } else {
                        // Add new itemCount to the next line
                        parent.itemCount += 1
                        print("parent.itemCount : \(parent.itemCount).")
                        let newText = "   \(parent.itemCount). "
                        textView.text.append("\n\(newText)")
                        parent.text = textView.text
                        return false
                    }
                }
             
            }
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}

