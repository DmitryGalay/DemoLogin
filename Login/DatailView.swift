//
//  ForgotPassword.swift
//  Login
//
//  Created by Dima on 1/23/21.
//  Copyright © 2021 Dima. All rights reserved.
//

import SwiftUI
import Combine

struct DatailView: View {
    @Environment(\.presentationMode ) var presentation
    @EnvironmentObject var email: Email
    @ObservedObject private var userViewModel = UserViewModel()
    var text: String
    let lightGrey = Color(red: 233.0/255 , green:234.0/255 ,blue:243.0/255)
    @State var invalidAttempts = 0
    @State private var isEmailValid : Bool = true
    var body: some View {
        VStack {
            //Great section Email
            VStack {
                HStack{
                    Image("e-mail")
                        .foregroundColor(.secondary).frame(width: 27 , height: 10)
                    TextField("Email" , text:$userViewModel.username, onEditingChanged: { (isChanged) in
                        if !isChanged {
                            if self.validatorEmail(self.userViewModel.username) {
                                self.userViewModel.isLimit = true
                            } else {
                                self.userViewModel.isLimit = false
                                self.userViewModel.username = ""
                            }
                        }
                    })
                }
                .padding()
                .background(lightGrey)
                .cornerRadius(25)
                .frame(width: UIScreen.main.bounds.width - 50 )
                .keyboardType(.emailAddress)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 2)
                        .foregroundColor(invalidAttempts == 0 ? Color.clear :Color.green))
                    .modifier(ShakeEffect(animatableData: CGFloat(invalidAttempts)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: $userViewModel.isLimit.wrappedValue ? 0 : 1 )
                            .foregroundColor(Color.red))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: $isEmailValid.wrappedValue ? 0 : 1)
                            .foregroundColor(Color.red))
                if !self.userViewModel.isLimit {
                    Text("Email is Not Valid")
                        .font(.callout)
                        .foregroundColor(Color.red)
                }
            }
            Spacer().frame(height:20)
            //Great text
            Text("Enter your e-mail and we will gladly mail you instructions on how to create a new one.")
            Spacer().frame(height:35)
            //Button"Reset Password" creation condition
            if !self.userViewModel.isLimit
            {
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous).fill(lightGrey).frame(height:50)
                    Button(action: {
                        withAnimation(.default) {
                            self.invalidAttempts += 1
                        }
                    }, label:  {
                        Text("Reset Password").foregroundColor(Color.blue)
                    })
                        .disabled(!self.userViewModel.isLimit)
                    //.disabled(!self.isEmailValid)
                }.padding()
            } else{
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous).fill(Color.blue).frame(height:50)
                    Button(action: {
                        withAnimation(.default) {
                            self.invalidAttempts += 1
                        }
                    }, label:  {
                        Text("Reset Password").foregroundColor(Color.white)
                    })
                    
                }.padding()
            }
            Spacer()
                .navigationBarTitle("Forgot Password")
        }.padding()
            .onAppear()
    }
    //Emale check function
    func validatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
}
