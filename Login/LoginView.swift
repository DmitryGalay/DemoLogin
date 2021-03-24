//
//  ContentView.swift
//  Login
//
//  Created by Dima on 1/22/21.
//  Copyright © 2021 Dima. All rights reserved.
//

import SwiftUI
import Combine

class Email: ObservableObject {
}
struct ContentView: View {
    @ObservedObject var contentView = Email()
    @State var selecter: String?
    @State var hidde = false
    @State var flag = false
    let time = 3.0
    @State var invalidAttempts = 0
    @ObservedObject private var userViewModel = UserViewModel()
    let lightGrey = Color(red: 233.0/255 , green:234.0/255 ,blue:243.0/255)
    let forgotPass = "Forgot your password?"
    let registerNow = "Register now"
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    //Great image
                    Image("2").frame(width: 100, height: 100)
                    //Great username and password section
                    VStack {
                        //Great userName section
                        HStack{
                            Image("person")
                                .foregroundColor(.secondary).frame(width: 17 , height: 10)
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
                        Spacer().frame(height:15)
                        //Great password section
                        ZStack {
                            Group {
                                if self.hidde {
                                    HStack{
                                        Image("lock")
                                            .foregroundColor(.secondary).frame(width: 17)
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
                                }
                                Button(action: {
                                    self.hidde.toggle()
                                }) {
                                    Image(systemName: self.hidde ? "eye.fill" : "eye.slash.fill")
                                        .foregroundColor((self.hidde == true) ?
                                            Color.blue : Color.secondary)
                                        .modifier(ShakeEffect(animatableData: CGFloat(invalidAttempts)))
                                }.padding(.leading ,275 )
                            }
                        }
                    }
                    Spacer().frame(height:15)
                    //Connection with email section
                    HStack {
                        NavigationLink(destination: DatailView(text: forgotPass),tag: "act1", selection:
                            $selecter,label: {
                                Text(forgotPass).foregroundColor(Color.gray)
                                EmptyView()
                        }).padding(.leading)
                            .frame(maxWidth: 350, alignment: .trailing)
                    }
                    Spacer().frame(height:10)
                    ////Button"Login" creation condition
                    if  !self.userViewModel.isLimit {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25, style: .continuous).fill(lightGrey).frame(height:50)
                            Button(action: {
                                withAnimation(Animation.linear(duration: 1).delay(1)) {
                                    self.userViewModel.callDelay()
                                }
                            }, label:  {
                                Text("Login").foregroundColor(Color.red)
                            })
                                .disabled(!self.userViewModel.isLimit)
                        }.padding()
                    }else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25, style: .continuous).fill(Color.blue).frame(height:50)
                            VStack {
                                Button(action: {
                                    self.userViewModel.callDelay()
                                }, label:  {
                                    Text("Login").foregroundColor(Color.white)
                                })
                            }
                        }
                        .padding()}
                    Spacer().frame(height: 15)
                    HStack {
                        Text("Don't have an account?").foregroundColor(Color.gray)
                        //Connect with register section
                        NavigationLink(destination: RegisterUser(text: registerNow),tag: "act2", selection: $selecter, label: {
                            Text(registerNow)
                            EmptyView()}
                        )}
                    Spacer().frame(height:220)
                }
                if self.userViewModel.showHud{
                    HUDProgressView()
                        .transition(.scale)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}

struct HUDProgressView: View  {
    @Environment(\.presentationMode) var presentation
    var text: String
    @State var animate = false
    @State var showDetail : Bool = false
    init(showDetail:Bool = false , text: String = " " + "loading..." ) {
        self.text = text
    }
    var body: some View {
        VStack(alignment: .center) {
            Circle()
                .stroke(AngularGradient(gradient: .init(colors: [Color.primary ,Color.primary.opacity(0)]), center: .center))
                .frame(width:50 , height: 50)
                .rotationEffect(.init(degrees: animate ? 360 : 0))
                .onAppear {
                    withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                        self.animate.toggle()
                    }
            }
            Text(text)
                .foregroundColor(Color.white)
                .font(.system(size: 25))
                .background(
                    Blur(style: .systemMaterial)
                        .clipShape(Capsule())
                        .shadow(color: Color(.black).opacity(0.22), radius: 12, x: 0, y: 5)
            )
        }
        .foregroundColor(Color.black)
        .cornerRadius(5)
        .frame(maxWidth: .infinity , maxHeight: .infinity)
        .background(
            Color.primary.opacity(0.7))
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
