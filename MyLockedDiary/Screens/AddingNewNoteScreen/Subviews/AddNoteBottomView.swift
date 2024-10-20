//
//  AddNoteBottomView.swift
//  MyLockedDiary
//
//  Created by apple on 27.08.2024.
//

import SwiftUI

struct AddNoteBottomView: View {
    var dismissKeybourd: () -> Void
    @EnvironmentObject var viewModel: MainTabViewViewModel

    @Binding var currentView: NoteViewCase

    var body: some View {
		VStack {
			HStack {
				Button  {
                    dismissKeybourd()
                    currentView = .listBullet

					print("list.bullet")
				} label: {
					Image(systemName: "list.bullet")
						.resizable()
						.frame(width: 24, height: 24)
						.padding(.horizontal, 6)
				}
				Button  {
                    dismissKeybourd()
                    currentView = .textFormatSize

					print("textformat.size")
				} label: {
					Image(systemName: "textformat.size")
						.resizable()
						.frame(width: 24, height: 24)
						.padding(.horizontal, 6)
				}
				Button  {
                    dismissKeybourd()
                    currentView = .tag
				} label: {
					Image(systemName: "tag")
						.resizable()
						.frame(width: 24, height: 24)
						.padding(.horizontal, 6)
				}
			}
			.padding()
			.tint(.black)
		}
        .background(viewModel.getSelectedColor())
		.cornerRadius(10)
    }
}

#Preview {
    AddNoteBottomView(dismissKeybourd: {}, currentView: .constant(.none))
}


enum NoteViewCase {
    case rectanglePortrait
    case photo
    case listBullet
    case smile
    case textFormatSize
    case tag
    case none
}
