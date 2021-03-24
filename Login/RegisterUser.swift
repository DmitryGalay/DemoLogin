//
//  Register.swift
//  Login
//
//  Created by Dima on 1/23/21.
//  Copyright © 2021 Dima. All rights reserved.
//

import SwiftUI
struct RegisterUser : View {
    @Environment(\.presentationMode ) var presentation
    @EnvironmentObject var email: Email
    @ObservedObject private var userViewModel = UserViewModel()
    @State var isOnToogle = false
    @State var hidde = false
    @State private var isEmailValid : Bool = true
    @State private var registerToogle: Bool = false
    let lightGrey = Color(red: 233.0/255 , green:234.0/255 ,blue:243.0/255)
    @State var invalidAttempts = 0
    var text : String
    var body: some View {
        VStack{
            //Great username,password and email section
            VStack{
                ////Great userName section
                HStack{
                    Image("person")
                        .foregroundColor(.secondary).frame(width: 27 , height: 10)
                    TextField("Username" , text:$userViewModel.username)
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
                //Great section Email
                HStack{
                    Image("e-mail")
                        .foregroundColor(.secondary).frame(width: 27 , height: 10)
                    
                    TextField("Email" , text:$userViewModel.emailname, onEditingChanged: { (isChanged) in
                        if !isChanged {
                            if self.validatorEmail(self.userViewModel.emailname) {
                                self.isEmailValid = true
                            } else {
                                self.isEmailValid = false
                                self.userViewModel.emailname = ""
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
                            .stroke(lineWidth: $isEmailValid.wrappedValue ? 1 : 0)
                            .foregroundColor(Color.red))
                //Great password section
                ZStack {
                    Group {
                        if self.hidde {
                            HStack{
                                Image("lock")
                                    .foregroundColor(.secondary).frame(width: 27)
                                TextField("Password" , text:$userViewModel.password)
                            }.padding()
                                .frame(width: UIScreen.main.bounds.width - 50 )
                                .background(lightGrey)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(invalidAttempts == 0 ? Color.clear :Color.green))
                                .modifier(ShakeEffect(animatableData: CGFloat(invalidAttempts)))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(lineWidth: $userViewModel.isLimit.wrappedValue ? 0 : 1 )
                                        .foregroundColor(Color.red))
                        } else {
                            HStack{
                                Image("lock")
                                    .foregroundColor(.secondary).frame(width: 17)
                                SecureField("Password" , text:$userViewModel.password)
                            }.padding()
                                .frame(width: UIScreen.main.bounds.width - 50 )
                                .background(lightGrey)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(invalidAttempts == 0 ? Color.clear :Color.green))
                                
                                .modifier(ShakeEffect(animatableData: CGFloat(invalidAttempts)))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(lineWidth: $userViewModel.isLimit.wrappedValue ? 1 : 0 )
                                        .foregroundColor(Color.red))
                        }
                        Button(action: {
                            self.hidde.toggle()
                        }) {
                            Image(systemName: self.hidde ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor((self.hidde == true) ?
                                    Color.blue : Color.secondary)
                                .modifier(ShakeEffect(animatableData: CGFloat(invalidAttempts)))
                        }.padding(.leading ,300 )
                    }
                }
            }
            //Great toogle and text
            HStack {
                //Great text
                VStack {
                    HStack {
                        Text("I accept the").foregroundColor(Color.gray)
                        Button(action: {}, label: {
                            Text("Terms of service ")
                        })
                        Text("and")
                    }
                    HStack {
                        Button(action: {}, label: {
                            Text("Privacy Policy ")
                        })
                        Text("for")
                        Button(action: {}, label: {
                            Text("StreamsCloud ")
                        })
                    }
                }.padding()
                    .frame(width: UIScreen.main.bounds.width - 150 , height: 5 )
                    .font(.system(size: 14))
                toogle()
                Button("") {
                    self.registerToogle.toggle()
                }
            }
            //Button"Register" creation condition
            if  !self.userViewModel.isLimit{
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous).fill(lightGrey).frame(height:50)
                    Button(action: {
                        withAnimation(.default) {
                            self.invalidAttempts += 1
                        }
                    }, label:  {
                        Text("Register").foregroundColor(Color.blue)
                    }).disabled(!self.userViewModel.isLimit)
                }.padding()
            }else {
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous).fill(Color.blue).frame(height:50)
                    Button(action: {
                        withAnimation(.default) {
                            self.invalidAttempts += 1
                        }
                    }, label:  {
                        Text("Register").foregroundColor(Color.white)
                    })
                }.padding()
            }
            Spacer().frame(height: 160)
                .navigationBarTitle("Register user")
        }.padding()
            .onAppear()
    }
    
    func toogle() -> some View {
        return Toggle(isOn: $isOnToogle, label: {
            Text("").foregroundColor(isOnToogle ?Color.blue : Color.black)
        }).padding()
    }
    
    func validatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
}
