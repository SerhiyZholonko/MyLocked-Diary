//
//  MainTabView.swift
//  MyLockedDiary
//
//  Created by apple on 04.08.2024.
//

import SwiftUI

struct MainTabView: View {
    @State var selectedTab = "2"
    @State private var isPressed1 = false // State for the first button
    @State private var isPressed2 = false // State for the second button
    @State private var isPressed3 = false // State for the third button
    @ObservedObject var viewModel = MainTabViewViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                CalendarHeaderView()
                    .modelContainer(for: Note.self)
                    .environmentObject(viewModel)
                    .tag("1")
                AddNewNoteView()
                    .modelContainer(for: Note.self)
                    .environmentObject(viewModel)
                    .tag("2")
                ProfileView()
                    .environmentObject(viewModel)
                    .tag("3")
            }
            
            HStack {
                // First Button
                Button {
                    selectedTab = "1"
                } label: {
                    Image("time")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(viewModel.getTintColor())
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isPressed1 = true }
                        .onEnded { _ in isPressed1 = false }
                )
                .scaleEffect(isPressed1 ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPressed1)
                
                Spacer()
                
                // Second Button
                Button {
                    selectedTab = "2"
                } label: {
                    ZStack {
                        Image("note")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(viewModel.getTintColor())
                            .frame(width: 50, height: 50)
                        
                        
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isPressed2 = true }
                        .onEnded { _ in isPressed2 = false }
                )
                .scaleEffect(isPressed2 ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPressed2)
                
                Spacer()
                
                // Third Button
                Button {
                    selectedTab = "3"
                } label: {
                    Image("user")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(viewModel.getTintColor())
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isPressed3 = true }
                        .onEnded { _ in isPressed3 = false }
                )
                .scaleEffect(isPressed3 ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPressed3)
            }
            .padding()
            .frame(maxWidth: .infinity)

        }
    }
}



#Preview {
    MainTabView()
        .modelContainer(for: Note.self, inMemory: true)

}
