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
                       

                        NavigationLink(destination:
                                        ThemeView()
                                            .environmentObject(viewModel)
                        ) {
                            Text("Theme")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                        NavigationLink(destination:
                                        TagsView()
                                            .environmentObject(viewModel)
                        ) {
                            Text("Tags")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                        NavigationLink(destination:
                                        DiaryLockView()
                                            .environmentObject(viewModel)
                        ) {
                            Text("Diary Lock")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                        NavigationLink(destination:
                                        ICloudSyncView()
                                           .environmentObject(viewModel)

                        ) {
                            Text("iCloud Sync")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                        NavigationLink(destination:
                                        WidgetView()
                                            .environmentObject(viewModel)

                        ) {
                            Text("Widget")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                        NavigationLink(destination:
                                        ShareAppView()
                                          .environmentObject(viewModel)
                                  ) {
                            Text("Share App")
                        }
                        .listRowBackground(viewModel.getThemeBackgroundColor()) // Change to your desired color

                      
                    }
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden) // Ensures the List background is transparent
            }

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
