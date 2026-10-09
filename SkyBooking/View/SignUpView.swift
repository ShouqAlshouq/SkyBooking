//
//  SignOutView.swift
//  SkyBooking
//
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {

    @State var myImage: UIImage?
    @State var isCamera = false
    @State var isGallery = false
    @State var authError = false
    
    @State var myProfile = Profile(fullName: "", email: "", phoneNumber: "", nationality: "", imageURL: "", userID: "")
    
    @State private var password: String = ""
    @State private var message: String = ""
    
    @State private var isSignedUp = false
    
    @Environment(\.dismiss) var dismiss
    
    private var db = Firestore.firestore()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                VStack(spacing: 1) {
                    Image("Icon")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(Color.brown)
                    
                    Text("SkyBooking")
                        .font(.title)
                        .bold()
                    
                    Text("Create your account")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                
                VStack {
                    if let myImage = myImage {
                        Image(uiImage: myImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
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
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    TextField("Phone Number", text: $myProfile.phoneNumber)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .keyboardType(.phonePad)
                    
                    TextField("Nationality", text: $myProfile.nationality)
                        .padding()
                        .background(Color(.systemGray6))
                        .keyboardType(.default)
                        .cornerRadius(10)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .keyboardType(.default)
                    
                    Button {
                        signUpUser()
                    } label: {
                        Text("SIGN UP")
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(Color.brown)
                            .foregroundColor(.white)
                            .bold()
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .gray.opacity(0.2), radius: 6)
                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            
            .sheet(isPresented: $isCamera) {
                CameraManager(selectedImage: $myImage, selectedSource: .camera)
            }
            .sheet(isPresented: $isGallery) {
                CameraManager(selectedImage: $myImage, selectedSource: .photoLibrary)
            }
            .alert(isPresented: $authError) {
                Alert(title: Text("Authentication Error"), message: Text(message), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    
    
    func createProfile() {
        do {
            try db.collection("Profiles").addDocument(from: myProfile) { error in
                if let error = error {
                    message = error.localizedDescription
                    authError = true
                    return
                }
                message = "Account created successfully"
                dismiss()
            }
            
        } catch {
            message = "Error creating profile"
            authError = true
        }
    }
    
    func signUpUser() {
        Auth.auth().createUser(withEmail: myProfile.email, password: password) { result, error in
            
            if let error = error {
                message = error.localizedDescription
                authError = true
                return
            }
            
            if let user = Auth.auth().currentUser {
                myProfile.userID = user.uid
                myProfile.email = myProfile.email
                
                createProfile()
            }
        }
    }
}
#Preview {
    SignUpView()
}
