//
//  Flight.swift
//  SkyBooking
//
//
import FirebaseFirestore

struct Flight: Codable, Identifiable {
    
    @DocumentID var id: String?
    var flightNumber: String
    var airline: String
    var departureCity: String
    var arrivalCity: String
    var departureTime: Date
    var arrivalTime: Date
    var price: Double
}
