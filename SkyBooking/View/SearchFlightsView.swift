//
//  SearchFlightsView.swift
//  SkyBooking
//
//

import SwiftUI
import FirebaseFirestore

struct SearchFlightsView: View {
    
    @State var departureCity = ""
    @State var listFlights: [Flight] = []
    @State var message = ""
    
    private var db = Firestore.firestore()
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter departure city...", text: $departureCity)
                    .keyboardType(.default)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button("Find Flights") {
                    if !departureCity.isEmpty {
                        findFlightByDepartureCity()
                    }
                    else {
                        message = "Please enter a city"
                        return
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.brown)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                Text(message)
                    .foregroundColor(.red)
                    .bold()
                    .padding()
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(listFlights) { flight in
                            FlightSearchCard(flight: flight)
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Search Flights")
        }
    }
    struct FlightSearchCard: View {
        var flight: Flight
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(flight.airline)
                        .font(.headline)
                    Spacer()
                    Text("AED \(flight.price, specifier: "%.1f")")
                        .font(.headline)
                        .foregroundStyle(Color(red: 128/255, green: 64/255, blue: 0))
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text(flight.departureTime.formatted(date: .abbreviated, time: .shortened))
                            .font(.title3)
                            .bold()
                        Text(flight.departureCity)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .bold()
                    }

                    Spacer()

                    VStack {
                        Text("✈︎ ")
                        Text("Direct")
                            .font(.caption)
                            .foregroundStyle(Color(red: 76/255, green: 153/255, blue: 0))
                            .bold()

                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text(flight.arrivalTime.formatted(date: .abbreviated, time: .shortened))
                            .font(.title3)
                            .bold()
                        Text(flight.arrivalCity)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .bold()
                    }
                }

                HStack {
                    Spacer()
                    NavigationLink(destination: BookingView(flight: flight)) {
                        Text("Book Flight")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.brown)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(Color(red: 243/255, green: 242/255, blue: 242/255))
            .cornerRadius(15)
            .shadow(radius: 2)
        }
    }
    
    func findFlightByDepartureCity() {
        db.collection("Flights")
            .whereField("departureCity", isEqualTo: departureCity)
            .getDocuments { snapshot, error in
                
                if let error = error {
                    message = error.localizedDescription
                    return
                }
                
                if let documents = snapshot?.documents {
                    
                    listFlights = documents.compactMap { doc in
                        try? doc.data(as: Flight.self)
                    }
                    
                    message = "Flights Found: \(listFlights.count)"
                    
                } else {
                    message = "No data found"
                }
            }
    }
}

#Preview {
    SearchFlightsView()
}
