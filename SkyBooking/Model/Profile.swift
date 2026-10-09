//
//  Profile.swift
//  SkyBooking
//
//
import FirebaseFirestore

struct Profile: Codable, Identifiable {
    
    @DocumentID var id: String?
    
    var fullName: String
    var email: String
    var phoneNumber: String
    var nationality: String
    var imageURL: String
    var userID: String
}
