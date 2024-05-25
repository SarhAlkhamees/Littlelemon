//
//  Onboarding.swift
//  Littlelemon
//
//  Created by Sarah Alkhamees on 16/11/1445 AH.
//

import SwiftUI
let kFirstName = "first name key"
let kLastName = "last name key"
let kEmail = "email key"
let kIsLoggedIn = "kIsLoggedIn"

struct Onboarding: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var showErrorMessage: Bool = false
    @State var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                Image("logo-image")
                VStack(alignment: .leading) {
                    Text("Little Lemon")
                        .font(Font.custom("Markazi", size: 50).weight(.medium))
                        .foregroundStyle(.primaryColor2)
                    
                    HStack(){
                        VStack(alignment: .leading){
                            Text("Chicago")
                                .font(Font.custom("Markazi", size: 32))
                                .foregroundStyle(.secondaryColor3)
                            Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                                .font(Font.custom("Markazi", size: 16).weight(.medium))
                                .foregroundStyle(.secondaryColor3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        Image("hero-image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 110, maxHeight: 120)
                            .cornerRadius(8)
                            .padding(.bottom, 10)
                    }
                }
                .padding()
                .background(.primaryColor1)
                
                NavigationLink(destination: Home(), isActive: $isLoggedIn){
                    EmptyView()
                }
                VStack(alignment: .leading){
                    Text("First Name *")
                        .foregroundStyle(.secondary)
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: firstName){
                            showErrorMessage = false
                        }
                    Text("Last Name *")
                        .foregroundStyle(.secondary)
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: lastName){
                            showErrorMessage = false
                        }
                    Text("Email *")
                        .foregroundStyle(.secondary)
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: email){
                            showErrorMessage = false
                        }
                }
                .padding()
                
                if showErrorMessage {
                    if !email.isEmpty && !isValidEmail(email){
                        Text("Please enter a valid email address!")
                            .foregroundStyle(.red)
                            .padding()
                    } else {
                        Text("Please enter all the required fields!")
                            .foregroundStyle(.red)
                            .padding()
                    }
                }
                
                Button("Register"){
                    if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty{
                        if isValidEmail(email){
                            UserDefaults.standard.set(firstName, forKey: kFirstName)
                            UserDefaults.standard.set(lastName, forKey: kLastName)
                            UserDefaults.standard.set(email, forKey: kEmail)
                            UserDefaults.standard.set(true, forKey: kIsLoggedIn)
                            isLoggedIn = true
                        } else {
                            showErrorMessage = true
                        }
                    } else {
                        showErrorMessage = true
                    }
                }
                .frame(width: 250, height: 50)
                .font(.headline)
                .foregroundStyle(.secondaryColor4)
                .background(.primaryColor2)
                .cornerRadius(8)
                .padding(5)
                .onAppear{
                    if UserDefaults.standard.bool(forKey: kIsLoggedIn){
                        isLoggedIn = true
                    } else {
                        firstName = ""
                        lastName = ""
                        email = ""
                    }
                }
                Spacer()
            }
            Spacer()
            .padding()
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailFormat).evaluate(with: email)
    }
}

#Preview {
    Onboarding()
}
