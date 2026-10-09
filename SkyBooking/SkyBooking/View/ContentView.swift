//
//  ContentView.swift
//  SkyBooking
//
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ContentView: View {
    
    @AppStorage("isLoggedIn") var isLoggedIn : Bool = false

    var body: some View {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                
                SearchFlightsView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                FlightsView()
                    .tabItem {
                        Image(systemName: "airplane")
                        Text("Flights")
                    }
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
            }
            .accentColor(.brown)
    }
    
}

#Preview {
    ContentView()
}
