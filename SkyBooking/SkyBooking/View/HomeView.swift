//
//  HomeView.swift
//  SkyBooking
//
//

import SwiftUI
//https://276f658ca04a4d3ab0818f123f38c0e6.api.mockbin.io/

struct HomeView: View {
    
    @State private var myRoutes: [Route] = []
    @State private var message = ""
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .bottomLeading) {
                    Image("homeBanner")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                        .ignoresSafeArea(edges: .top)
                    
                    LinearGradient(
                        colors: [.black.opacity(0.7), .clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .frame(height: 250)
                    .ignoresSafeArea(edges: .top)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome to")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text("SkyBooking")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Your journey starts here")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                }
                .ignoresSafeArea(edges: .top)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Live Departure Board")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if !message.isEmpty {
                            Text(message)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                        if isLoading {
                            Text("Fetching flights' data...")
                                .font(.caption)
                                .foregroundColor(.secondary)

                        } else {
                            ForEach(myRoutes) { route in
                                RouteCardView(route: route)
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                getRouteDetails()
            }
        }
    }
    
    func getRouteDetails() {
        isLoading = true
        if let myURL = URL(string: "https://276f658ca04a4d3ab0818f123f38c0e6.api.mockbin.io/") {
            URLSession.shared.dataTask(with: myURL) { myData, _, myError in
                
                if let myError = myError {
                    print(myError.localizedDescription)
                    return
                }
                
                if let myData = myData {
                    do {
                        let decoded = try JSONDecoder().decode(RoutesResponse.self, from: myData)
                        
                        DispatchQueue.main.async {
                            self.myRoutes = decoded.Routes
                        }
                    } catch {
                        print("ERROR decoding JSON:", error)
                    }
                    isLoading = false
                } else {
                    print("No data received")
                }
            }
            .resume()
            
        } else {
            print("Error creating URL")
        }
    }
}
#Preview {
    HomeView()
}
