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
    @State var phoneNumber = UserDefaults.standard.string(forKey: kPhoneNumber) ?? ""
    @State var orderStatus = UserDefaults.standard.bool(forKey: "order status key")
    @State var passwordChanges = UserDefaults.standard.bool(forKey: "password changes key")
    @State var specialOffers = UserDefaults.standard.bool(forKey: "special offers key")
    @State var newsletter = UserDefaults.standard.bool(forKey: "newsletter key")
    @State var showErrorMessage: Bool = false
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ScrollView{
            VStack{
                ZStack{
                    Image("logo-image")
                    HStack{
                        NavigationLink(destination: Home()){
                            Image(systemName: "arrowshape.backward.fill")
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .background(.primaryColor1)
                                .clipShape(Circle())
                                .padding(.leading, 10)
                        }
                        Spacer()
                        Button {} label: {
                            Image("profile-image-placeholder")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 65, height: 65)
                                .padding(.trailing, 10)
                        }
                    }
                }
                VStack(alignment: .leading){
                    Text("Personal information")
                        .font((Font.custom("Markazi", size: 18)))
                        .padding()
                    Text("Avatar")
                        .foregroundStyle(.secondaryColor4)
                        .padding(.leading, 10)
                    HStack{
                        Image("profile-image-placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                        
                        Button("Change"){
                            
                        }
                        .frame(width: 80, height: 50)
                        .foregroundStyle(.secondaryColor3)
                        .background(.primaryColor1)
                        .cornerRadius(8)
                        .padding(10)
                        
                        Button("Remove"){
                            
                        }
                        .frame(width: 80, height: 50)
                        .foregroundStyle(.secondaryColor4)
                        .background(.secondaryColor3)
                        .cornerRadius(8)
                        .padding(10)
                    }
                    .padding(10)
                    
                    VStack(alignment: .leading){
                        Text("First name")
                            .foregroundStyle(.secondaryColor4)
                        TextField("First name", text: $firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Last name")
                            .foregroundStyle(.secondaryColor4)
                        TextField("Last name", text: $lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Email")
                            .foregroundStyle(.secondaryColor4)
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Phone number")
                            .foregroundStyle(.secondaryColor4)
                        TextField("Phone number", text: $phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
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
                    
                    VStack(alignment: .leading){
                        Text("Email Notifications")
                            .bold()
                        Toggle("Order status", isOn: $orderStatus)
                        Toggle("Password changes", isOn: $passwordChanges)
                        Toggle("Special offers", isOn: $specialOffers)
                        Toggle("Newsletter", isOn: $newsletter)
                    }
                    .padding()
                    .toggleStyle(CheckboxToggleStyle())
                    
                    HStack{
                        Spacer()
                        Button("Log out"){
                            UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                            self.presentation.wrappedValue.dismiss()
                        }
                        .frame(width: 250, height: 50)
                        .font(.headline)
                        .foregroundStyle(.secondaryColor4)
                        .background(.primaryColor2)
                        .cornerRadius(8)
                        .padding(5)
                        
                        Spacer()
                    }
                    
                    HStack{
                        Spacer()
                        Button("Discard changes"){
                            firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
                            lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
                            email = UserDefaults.standard.string(forKey: kEmail) ?? ""
                            phoneNumber = UserDefaults.standard.string(forKey: kPhoneNumber) ?? ""
                            orderStatus = UserDefaults.standard.bool(forKey: "order status key")
                            passwordChanges = UserDefaults.standard.bool(forKey: "special offers key")
                            specialOffers = UserDefaults.standard.bool(forKey: "special offers key")
                            newsletter = UserDefaults.standard.bool(forKey: "newsletter key")
                        }
                        
                        .frame(width: 150, height: 50)
                        .font(.headline)
                        .foregroundStyle(.secondaryColor4)
                        .background(.secondaryColor3)
                        .cornerRadius(8)
                        .padding(10)
                        
                        Button("Save changes"){
                            if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty{
                                if isValidEmail(email){
                                    UserDefaults.standard.set(firstName, forKey: kFirstName)
                                    UserDefaults.standard.set(lastName, forKey: kLastName)
                                    UserDefaults.standard.set(email, forKey: kEmail)
                                    UserDefaults.standard.set(phoneNumber, forKey: kPhoneNumber)
                                } else {
                                    showErrorMessage = true
                                }
                            } else {
                                showErrorMessage = true
                            }
                            UserDefaults.standard.set(orderStatus, forKey: "order status key")
                            UserDefaults.standard.set(passwordChanges, forKey: "password changes key")
                            UserDefaults.standard.set(specialOffers, forKey: "special offers key")
                            UserDefaults.standard.set(newsletter, forKey: "newsletter key")
                            print("Save the changes succefully")
                        }
                        .frame(width: 150, height: 50)
                        .font(.headline)
                        .foregroundStyle(.secondaryColor3)
                        .background(.primaryColor1)
                        .cornerRadius(8)
                        .padding(10)
                        
                        Spacer()
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(.secondary))
            }
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailFormat).evaluate(with: email)
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Button {
                configuration.isOn.toggle()
            } label: {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(configuration.isOn ? .accentColor : .secondary)
            }
            configuration.label
        }
    }
}

#Preview {
    UserProfile()
}
