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

struct Onboarding: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var showErrorMessage: Bool = false
    
    var body: some View {
        VStack{
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: firstName){
                    showErrorMessage = false
                }
            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: lastName){
                    showErrorMessage = false
                }
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: email){
                    showErrorMessage = false
                }
            
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
                    } else {
                        showErrorMessage = true
                    }
                } else {
                    showErrorMessage = true
                }
            }
        }
        .padding()
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailFormat).evaluate(with: email)
    }
}

#Preview {
    Onboarding()
}
