//
//  Route.swift
//  SkyBooking
//
//
import Foundation

struct RoutesResponse: Codable {
    let Routes: [Route]
}

struct Route: Codable, Identifiable {
    var id = UUID()

    enum CodingKeys: String, CodingKey {
        case number, status, airline, movement, aircraft, callSign, codeshareStatus
    }

    let number: String
    let status: String
    let airline: Airline
    let movement: Movement
    let aircraft: Aircraft?
    let callSign: String?
    let codeshareStatus: String?
}

struct Airline: Codable {
    var name: String
    var iata: String
    var icao: String
}
struct Movement: Codable {
    let airport: Airport?
    let scheduledTime: TimeInfo?
    let revisedTime: TimeInfo?
    let terminal: String?
}
struct Airport: Codable {
    var name: String
    var iata: String
    var icao: String
    var countryCode: String
    var timeZone: String
}
struct TimeInfo: Codable {
    var utc: String
    var local: String
}
struct Aircraft: Codable {
    var model: String?
}
