//
//  RouteRowView.swift
//  SkyBooking
//
//

import SwiftUI

struct RouteCardView: View {
    var route: Route
    
    var statusColor: Color {
        
        switch route.status.lowercased() {
        case "scheduled": return .blue
        case "departed": return .green
        case "delayed": return .orange
        case "canceled": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(route.airline.name)
                        .font(.headline)
                        .bold()
                    Text("Flight \(route.number)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(route.status)
                    .font(.caption)
                    .bold()
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
                    .cornerRadius(8)
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Label(route.movement.airport?.iata ?? "N/A", systemImage: "airplane.departure")
                        .font(.subheadline)
                    Text(route.movement.scheduledTime?.local ?? "--")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.title2)
                    .foregroundColor(.brown)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Label(route.movement.airport?.icao ?? "N/A", systemImage: "airplane.arrival")
                        .font(.subheadline)
                    Text(route.movement.scheduledTime?.utc ?? "--")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 6) {
                if let model = route.aircraft?.model {
                    Label("Aircraft: \(model)", systemImage: "airplane")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                if let callSign = route.callSign {
                    Label("Call Sign: \(callSign)", systemImage: "waveform")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                if let code = route.codeshareStatus {
                    Label("Codeshare: \(code)", systemImage: "person.2.fill")
                        .font(.caption)
                        .foregroundColor(.gray)
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

#Preview {
    RouteCardView(route: Route(
        number: "",
        status: "",
        airline: Airline(name: "", iata: "", icao: ""),
        movement: Movement(
            airport: Airport(
                name: "",
                iata: "",
                icao: "",
                countryCode: "",
                timeZone: ""
            ),
            scheduledTime: TimeInfo(utc: "", local: ""),
            revisedTime: nil,
            terminal: ""
        ),
        aircraft: Aircraft(model: ""),
        callSign: "",
        codeshareStatus: ""
    ))
}
