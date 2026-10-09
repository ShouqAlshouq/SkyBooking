//
//  SignInView.swift
//  SkyBooking
//
//
import SwiftUI
import FirebaseAuth

struct SignInView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var message: String = ""
    
    @State private var authError = false
    @State private var showSignUp = false
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 25) {
                VStack(spacing: 1) {
                    Image("Icon")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(Color.brown)
                    
                    Text("SkyBooking")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("Welcome back, log in to continue")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
                
                VStack(spacing: 15) {
                    
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    Button("LOGIN") {
                        SigninUser()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .bold()
                    .cornerRadius(12)
                    
                    Button("Don't have an account? Sign Up") {
                        showSignUp = true
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .gray.opacity(0.2), radius: 6)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            
            .alert("Authentication Error", isPresented: $authError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(message)
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
    
    func SigninUser() {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if let error = error {
                message = error.localizedDescription
                authError = true
                return
            }
            isLoggedIn = true
        }
    }
}

#Preview {
    SignInView()
}

