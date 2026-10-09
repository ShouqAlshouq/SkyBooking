//
//  FlightsView.swift
//  SkyBooking
//
//

import SwiftUI
import FirebaseFirestore

struct FlightsView: View {
    
    @State private var listFlights: [Flight] = []
    var db = Firestore.firestore()
    @State var message = ""
    @State private var myListener: FirebaseFirestore.ListenerRegistration?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(listFlights) { flight in
                        FlightCardView(flight: flight)
                    }
                }
                .padding()
            }
            .navigationTitle("Available Flights")

        }
        
        .onAppear {
            readLiveFlights()
        }
        .onDisappear {
            stopReadLiveFlights()
        }
        
    }
    
    struct FlightCardView: View {
        var flight: Flight

        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                
                HStack {
                    Text(flight.airline)
                        .font(.headline)
                        .bold()
                    
                    Spacer()
                    
                    Text("AED \(flight.price, specifier: "%.1f")")
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.brown.opacity(0.15))
                        .cornerRadius(10)
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(flight.departureTime.formatted(date: .abbreviated, time: .shortened))
                            .font(.title3)
                            .bold()
                        Label(flight.departureCity, systemImage: "airplane.departure")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .font(.title2)
                        .foregroundColor(.brown)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 6) {
                        Text(flight.arrivalTime.formatted(date: .abbreviated, time: .shortened))
                            .font(.title3)
                            .bold()
                        Label(flight.arrivalCity, systemImage: "airplane.arrival")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Divider()
                
                Label("Flight No: \(flight.flightNumber)", systemImage: "number")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack {
                    Spacer()
                    NavigationLink(destination: BookingView(flight: flight)) {
                        Text("BOOK FLIGHT")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.brown)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .bold()
                    }
                }
                
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .shadow(radius: 2)
            .padding(.horizontal)
        }
    }

    func readLiveFlights(){
        
        myListener = db.collection("Flights").addSnapshotListener({ mySnap, myError in
            
            if let myError = myError {
                self.message = myError.localizedDescription
                return
            }
            
            if let mySnap = mySnap {
                
                do {
                    listFlights = mySnap.documents.compactMap { document in
                        try! document.data(as: Flight.self)
                    }
                } catch {
                    self.message = "Error decoding Firebase data"
                }
                
            }
            
        })
        
    }
    
    func stopReadLiveFlights(){
        
        myListener?.remove()
        
    }
}

#Preview {
    FlightsView()
}
