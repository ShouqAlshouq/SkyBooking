//
//  BookingView.swift
//  SkyBooking
//
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct BookingView: View {
    
    @State private var message = ""
    @State private var isLoading = false
    @State private var showSuccess = false
    
    var db = Firestore.firestore()
    var flight: Flight
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 25) {
                    
                    Text("Confirm Your Booking")
                        .font(.title2)
                        .bold()
                        .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(flight.airline)
                                .font(.title3)
                                .bold()
                            Spacer()
                            Text("AED \(flight.price, specifier: "%.1f")")
                                .font(.headline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.brown.opacity(0.15))
                                .cornerRadius(10)
                        }
                        
                        Divider()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Label(flight.departureCity, systemImage: "airplane.departure")
                                    .font(.subheadline)
                                Text(flight.departureTime.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .font(.title3)
                                .foregroundColor(.brown)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 6) {
                                Label(flight.arrivalCity, systemImage: "airplane.arrival")
                                    .font(.subheadline)
                                Text(flight.arrivalTime.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            Label("Flight No: \(flight.flightNumber)", systemImage: "number")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    Button {
                        createBooking()
                    } label: {
                        Text("CONFIRM BOOKING")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.brown)
                            .foregroundColor(.white)
                            .bold()
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    if !message.isEmpty {
                        Text(message)
                            .foregroundColor(.red)
                            .bold()
                            .padding(.top, 5)
                    }
                    
                    Spacer()
                }
            }
            if isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView("Booking...")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
            }
        }
        .alert("Booking Confirmed!", isPresented: $showSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your flight has been successfully booked.")
        }
    }
    
    func createBooking() {
        if let user = Auth.auth().currentUser {
            isLoading = true
            
            let newBooking = Booking(
                bookingDate: Date().formatted(date: .abbreviated, time: .shortened),
                flightId: flight.id ?? "",
                travelerId: user.uid,
                status: "Confirmed"
            )
            
            do {
                try db.collection("Bookings").addDocument(from: newBooking)
                isLoading = false
                showSuccess = true
            } catch {
                isLoading = false
                message = "Error saving booking"
            }
        } else {
            message = "User not logged in"
        }
    }
}

#Preview {
    BookingView(flight: Flight(flightNumber: "", airline: "", departureCity: "", arrivalCity: "", departureTime: Date(), arrivalTime: Date(), price: 0.0))
}
