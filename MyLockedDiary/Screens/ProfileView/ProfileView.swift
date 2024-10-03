//
//  ProfileView.swift
//  MyLockedDiary
//
//  Created by apple on 04.08.2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: MainTabViewViewModel
    
    var body: some View {
        NavigationStack {
            ZStack { // Use ZStack to add background behind the List
                viewModel.getThemeBackgroundColor() // Background color
                    .ignoresSafeArea() // Allow the background color to extend behind the navigation bar and bottom safe area

                List {
                    // Profile Section
                    Section {
                        NavigationLink(destination: Text("Profile")) {
                            Text("Profile")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                        NavigationLink(destination: Text("Theme")) {
                            Text("Theme")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                        NavigationLink(destination: Text("Tags")) {
                            Text("Tags")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                        NavigationLink(destination: Text("Diary Lock")) {
                            Text("Diary Lock")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                        NavigationLink(destination: Text("iCloud Sync")) {
                            Text("iCloud Sync")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                        NavigationLink(destination: Text("Export & Import")) {
                            Text("Export & Import")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                        NavigationLink(destination: Text("Widget")) {
                            Text("Widget")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                        NavigationLink(destination: Text("Share App")) {
                            Text("Share App")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                        NavigationLink(destination: Text("Settings")) {
                            Text("Settings")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                        NavigationLink(destination: Text("Family Apps")) {
                            Text("Family Apps")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                        NavigationLink(destination: Text("To-do List")) {
                            Text("To-do List")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                    }
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden) // Ensures the List background is transparent
            }
//            .background {
//                viewModel.getThemeBackgroundColor() // Background color
//            }
            .navigationTitle("Profile")
        }
//        .background {
//            viewModel.getThemeBackgroundColor() // Background color
//        }
    }
}
#Preview {
    ProfileView()
        .environmentObject(MainTabViewViewModel())
}
