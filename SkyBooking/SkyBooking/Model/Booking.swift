//
//  Booking.swift
//  SkyBooking
//
//
import FirebaseFirestore

struct Booking: Codable, Identifiable {
    
    @DocumentID var id: String?
    var bookingDate: String
    var flightId: String
    var travelerId: String
    var status: String
}
