//
//  ProfileView.swift
//  SkyBooking
//
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileView: View {
    
    @State var myImage: UIImage?
    @State var isCamera = false
    @State var isGallery = false
    
    @State private var message: String = ""
    @State private var myBookings: [Booking] = []
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    @State var myProfile = Profile(
        fullName: "",
        email: "",
        phoneNumber: "",
        nationality: "",
        imageURL: "",
        userID: ""
    )
    
    private var db = Firestore.firestore()
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 25) {
                    Text("Your Profile")
                        .font(.title)
                        .bold()
                }
                .padding(.top, 10)
                VStack {
                    if let myImage = myImage {
                        Image(uiImage: myImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                    else if let url = URL(string: myProfile.imageURL),
                            !myProfile.imageURL.isEmpty {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        }placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.gray)
                    }
                    
                    HStack {
                        Button("Camera") {
                            isCamera = true
                        }
                        Button("Gallery") {
                            isGallery = true
                        }
                    }
                    .tint(.brown)
                    .buttonStyle(.borderedProminent)
                    .font(.caption)
                }
                
                ScrollView {
                    VStack(spacing: 15) {
                        TextField("Full Name", text: $myProfile.fullName)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .keyboardType(.default)
                        
                        TextField("Email", text: $myProfile.email)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        TextField("Phone", text: $myProfile.phoneNumber)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .keyboardType(.phonePad)
                        
                        TextField("Nationality", text: $myProfile.nationality)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .keyboardType(.default)
                        TextField("Image URL", text: $myProfile.imageURL)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .keyboardType(.URL)
                        Button {
                            if !myProfile.fullName.isEmpty && !myProfile.phoneNumber.isEmpty {
                                updateProfile()
                            } else {
                                message = "Please provide your email and phone number"
                            }
                        } label: {
                            Text("UPDATE")
                                .frame(maxWidth: .infinity)
                                .frame(height: 45)
                                .background(Color.brown)
                                .foregroundColor(.white)
                                .bold()
                                .cornerRadius(12)
                        }
                        Button {
                            signOut()
                        } label: {
                            Text("SIGN OUT")
                                .frame(maxWidth: .infinity)
                                .frame(height: 45)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .bold()
                                .cornerRadius(12)
                        }
                        .padding(.top, 5)
                    }
                    Text(message)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .bold()
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .gray.opacity(0.2), radius: 6)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("My Bookings")
                        .font(.headline)
                    
                    if myBookings.isEmpty {
                        Text("No bookings yet")
                            .foregroundStyle(.gray)
                    } else {
                        ForEach(myBookings) { booking in
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Flight: \(booking.flightId)")
                                    .font(.subheadline)
                                    .bold()
                                Text("Date: \(booking.bookingDate)")
                                    .foregroundStyle(.gray)
                                Text("Status: \(booking.status)")
                                    .foregroundStyle(.green)
                                HStack {
                                    Spacer()
                                }
                                Button {
                                    cancelBooking(bookingToCancel: booking)
                                } label: {
                                    Text("Cancel")
                                        .font(.caption)
                                        .bold()
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }

                                
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
                
            }
            .padding()
            
            .sheet(isPresented: $isCamera) {
                CameraManager(selectedImage: $myImage, selectedSource: .camera)
            }
            .sheet(isPresented: $isGallery) {
                CameraManager(selectedImage: $myImage, selectedSource: .photoLibrary)
            }
            .onAppear {
                fetchBookings()
                if let user = Auth.auth().currentUser {
                    myProfile.email = user.email ?? ""
                    fetchProfile()
                }
            }
        }
    }
        
    func fetchProfile() {
        db.collection("Profiles")
            .whereField("email", isEqualTo: myProfile.email)
            .getDocuments { snap, error in
                
                if let error = error {
                    message = error.localizedDescription
                    return
                }
                
                if let doc = snap?.documents.first {
                    myProfile = try! doc.data(as: Profile.self)
                }
            }
    }
    
    func updateProfile() {
        if let id = myProfile.id {
            try? db.collection("Profiles")
                .document(id)
                .setData(from: myProfile)
            
            message = "Profile Updated!"
        } else {
            message = "No profile ID"
        }
    }
    
    func fetchBookings() {
        if let user = Auth.auth().currentUser {
            db.collection("Bookings")
                .whereField("travelerId", isEqualTo: user.uid)
                .getDocuments { snap, error in
                    if let docs = snap?.documents {
                        myBookings = docs.compactMap {
                            try? $0.data(as: Booking.self)
                        }
                    }
                }
        }
    }
    
    func cancelBooking(bookingToCancel: Booking) {
        if let id = bookingToCancel.id {
            db.collection("Bookings").document(id).delete { error in
                if let error = error {
                    message = error.localizedDescription
                    return
                }
                message = "Booking cancelled successfully"
                fetchBookings()
            }
        } else {
            message = "Booking ID missing!"
        }
    }


    func signOut() {
        do {
            try Auth.auth().signOut()
            message = "Signed out successfully"
            isLoggedIn = false
        } catch {
            message = error.localizedDescription
        }
    }

}
#Preview {
    ProfileView()
}
