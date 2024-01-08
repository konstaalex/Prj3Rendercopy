
//  HomePageView.swift
//  StalkerApp
//  Created by Patras Alexandru on 26.11.2023.

import SwiftUI

struct HomePageView: View {
    @State private var showingSheet = false
    @State private var users: [User] = []
    @State private var selectedUser: User?
    
    var body: some View {
        NavigationView{
            // Zstack allows overlaying on the Z axis.
            // order of views determines their placements btw 
            ZStack{
                Color(UIColor.systemBackground)
                    .ignoresSafeArea(.all)
                CustomMapView()
                VStack(alignment: .leading) {
                    
                  
                    CustomHeader()
                    .padding()
                    
                    Spacer()
                    Button(action: {
                        showingSheet.toggle()
                        
                    }) {
                        Image(systemName: "person.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(.black)
                            .padding()
                    }
                    .sheet(isPresented: $showingSheet) {
                        BottomSheetView(users: $users, selectedUser: $selectedUser)                            .presentationDetents([.medium, .large])
                            .presentationDragIndicator(.visible)
                            .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    }
                }
            }
            
        }
    }
    struct BottomSheetView: View {
        @State var searchText = ""
        @Binding var users: [User]
        @Binding var selectedUser: User?
        
        var body: some View {
            NavigationView {
                VStack(alignment: .leading) {
                    Text("STALKERS")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    List {
                        if users.isEmpty {
                            Text("No stalker added!")
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            ForEach(users, id: \.id) { user in
                                Text(user.username)
                            }
                        }
                    }
                    .searchable(text: $searchText)
                    .scrollContentBackground(.hidden)
                    
                    NavigationLink(destination: SearchView(selectedUser: $selectedUser)) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                            .foregroundColor(.black)
                            .padding()
                    }
                    .padding()
                }
            }
        }
    }
}
#Preview {
    HomePageView()
}

