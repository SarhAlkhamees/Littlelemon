//
//  UserProfile.swift
//  Littlelemon
//
//  Created by Sarah Alkhamees on 16/11/1445 AH.
//

import SwiftUI

struct UserProfile: View {
    @State var firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    @State var lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
    @State var email = UserDefaults.standard.string(forKey: kEmail) ?? ""
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack{
            Text("Personal information")
            Image("profile-image-placeholder")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
            
            VStack(alignment: .leading){
                Text("First name: ")
                TextField("First name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Last name: ")
                TextField("Last name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Email: ")
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            Button("Logout"){
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            }
            Spacer()
        }
    }
}

#Preview {
    UserProfile()
}
