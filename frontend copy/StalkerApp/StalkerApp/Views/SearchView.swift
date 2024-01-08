//
//  SearchView.swift
//  StalkerApp
//
//  Created by Patras Alexandru on 06.12.2023.
//

import SwiftUI

struct SearchView: View {
    @State var searchText = ""
    @State private var users: [User] = []
    @Binding var selectedUser: User?
    @State private var username = ""
    @State private var password = ""
    
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return []
        } else {
            return users.filter { user in
                user.username.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    var body: some View {
        
        NavigationView {
            VStack {
                Text("Search for stalkers:")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                
                    .onAppear {
                        Task {
                            do {
                                guard let token = UserDefaults.standard.string(forKey: "jwtToken") else {
                                    print("JWT Token not available.")
                                    return
                                    
                                }
                                print("JWT Token in .onAppear: \(token)")
                                
                                let fetchedUsers = try await getUsers(token: token)
                                users = fetchedUsers
                                print(fetchedUsers)
                            } catch {
                                print("Error fetching users: \(error)")
                            }
                        }
                    }
                List(filteredUsers, id: \.id) { user in
                    HStack {
                        Text(user.username)
                            .font(.headline)
                        Spacer()
                        Button(action: {
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
        .searchable(text: $searchText)
    }
}
#Preview {
    SearchView(selectedUser: .constant(nil))
}
