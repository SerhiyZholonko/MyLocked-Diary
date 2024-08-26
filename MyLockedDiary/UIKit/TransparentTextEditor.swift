//
//  File.swift
//  MyLockedDiary
//
//  Created by apple on 06.08.2024.
//

import SwiftUI

struct TransparentTextEditor: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear // Make the UITextView background clear
        textView.font = UIFont.systemFont(ofSize: 17) // Set font size
        textView.delegate = context.coordinator
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

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}
