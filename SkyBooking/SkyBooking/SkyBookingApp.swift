//
//  SkyBookingApp.swift
//  SkyBooking
//
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct SkyBookingApp: App {

    @AppStorage("isLoggedIn") var isLoggedIn = false

    init() {
        FirebaseApp.configure()
        isLoggedIn = Auth.auth().currentUser != nil
    }

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView()
            } else {
                SignInView()
            }
        }
    }
}
