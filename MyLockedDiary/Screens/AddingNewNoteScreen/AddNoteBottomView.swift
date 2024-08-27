//
//  AddNoteBottomView.swift
//  MyLockedDiary
//
//  Created by apple on 27.08.2024.
//

import SwiftUI

struct AddNoteBottomView: View {
    var body: some View {
		VStack {
			HStack {
				Button {
					print("rectangle.portrait")
				} label: {
					Image(systemName:"rectangle.portrait")
						.resizable()
						.frame(width: 24, height: 24)
						.padding(.horizontal, 6)
				}
				Button {
					print("photo")
				} label: {
					Image(systemName: "photo")
						.resizable()
						.frame(width: 24, height: 24)
						.padding(.horizontal, 6)
				}
				Button  {
					print("list.bullet")
				} label: {
					Image(systemName: "list.bullet")
						.resizable()
						.frame(width: 24, height: 24)
						.padding(.horizontal, 6)
				}
				Button  {
					print("smile")
				} label: {
					Image("smile")
						.resizable()
						.frame(width: 24, height: 24)
						.padding(.horizontal, 6)
				}
				Button  {
					print("textformat.size")
				} label: {
					Image(systemName: "textformat.size")
						.resizable()
						.frame(width: 24, height: 24)
						.padding(.horizontal, 6)
				}
				Button  {
					print("tag")
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
		.background(.secondary)
		.cornerRadius(10)
    }
}

#Preview {
    AddNoteBottomView()
}
