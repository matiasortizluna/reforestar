//
//  UserProfileContentView.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 05/08/2021.
//

import Foundation
import SwiftUI
import Firebase

struct UserProfileContentView : View {
    
    @StateObject var selectedModelManager = CurrentSessionSwiftUI()
    @StateObject var userFeedbackManager = UserFeedback()
    
    var body: some View {
        
        ZStack(){
            Color.light_beish.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                HStack(alignment: .top){
                    Spacer()
                    AboutButton()
                }
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack{
                        UserPicture()
                        UserName()
                    }
                    Spacer()
                }
                HStack (alignment: .center){
                    Spacer()
                    VStack{
                        MailUsernameInformation()
                        if(self.selectedModelManager.loggedUserBool){
                            EditProfileButton()
                        }
                    }
                    Spacer()
                }
                Spacer()
                HStack (alignment: .center){
                    Spacer()
                    UserInformation()
                    Spacer()
                }
                Spacer()
                HStack (alignment: .bottom){
                    ActionButtons()
                }
                
            }
        }
        .environmentObject(selectedModelManager)
        .environmentObject(userFeedbackManager)
    }
}



struct ActionButtons : View {
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    
    var body: some View{
        if(self.selectedModelManager.loggedUserBool == false){
            
            HStack(alignment: .center, spacing: 30.0){
                RegisterAction()
                LogInAction()
            }
            .padding(.bottom,Help.border_padding*2.0)
            
        }else{
            
            LogOutButton()
            
        }
    }
    
}

struct LogInAction : View {
    
    @State var showForms : Bool = false
    
    @State var email: String = ""
    @State var password: String = ""
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    
    var body: some View{
        VStack{
            LogInButton(showForms: $showForms)
                .sheet(isPresented: $showForms, content: {
                    NavigationView{
                        VStack{
                            Form {
                                Section(header: Text("User Information")) {
                                    TextField("E-mail", text: $email)
                                    TextField("Password", text: $password)
                                }
                                Section(content: {
                                    Button(action: {
                                        
                                        Auth.auth().signIn(withEmail: "matiasariel2001@outlook.com", password: "12345678") { (result, error) in
                                            if error != nil {
                                                print("Error singing in")
                                                print(error?.localizedDescription ?? "")
                                            } else {
                                                print("You have logged in")
                                                print(result?.description)
                                                self.selectedModelManager.loggedUserBool = true
                                                //self.selectedModelManager.loggedUser = UserReforestAR(uid: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser!.displayName, email: Auth.auth().currentUser!.email, image: Auth.auth().currentUser!.photoURL)
                                                self.showForms.toggle()
                                            }
                                        }
                                        
                                    },label: {
                                        Text("Log In ")
                                    })
                                })
                            }
                        }
                        .navigationTitle(Text("Log In")).navigationBarTitleDisplayMode(.large)
                        .navigationBarItems(trailing: Button(action: {
                            self.showForms.toggle()
                        }, label: {
                            Text("Cancel").bold()
                        }))
                    }
                })
        }
    }
    
}

struct RegisterAction : View {
    
    @State var showFormsRegister : Bool = false
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var confirm_email: String = ""
    @State var confirm_password: String = ""
    
    @State var display_name: String = ""
    
    @State var image : Image = Image(systemName: "person")
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    
    var body: some View{
        
        RegisterButton(showForms: $showFormsRegister)
            .sheet(isPresented: $showFormsRegister, content: {
                NavigationView{
                    VStack{
                        Form {
                            Section(header: Text("User's Display Name")) {
                                TextField("Display Name", text: $display_name)
                            }
                            Section(header: Text("User's Email")) {
                                TextField("E-mail", text: $email)
                                TextField("Confirm E-mail", text: $confirm_email)
                            }
                            Section(header: Text("User's Password")) {
                                SecureField("Password", text: $password)
                                SecureField("Confirm Password", text: $confirm_password)
                            }
                            Section(header: Text("User's Profile Picture")) {
                                TextField("E-mail", text: $email)
                            }
                            Section(content: {
                                Button(action: {
                                    
                                    Auth.auth().createUser(withEmail: "matiasariel2001@outlook.com", password: "12345678"){ (result, error) in
                                        if error != nil {
                                            print("Error creating account")
                                            print(error?.localizedDescription ?? "")
                                            
                                        } else {
                                            print("User created sucessfully")
                                            self.selectedModelManager.loggedUserBool = true
                                            self.showFormsRegister.toggle()
                                        }
                                    }

                                },label: {
                                    Text("Register")
                                })
                            })
                        }
                    }
                    .navigationTitle(Text("Register")).navigationBarTitleDisplayMode(.large)
                    .navigationBarItems(trailing: Button(action: {
                        self.showFormsRegister.toggle()
                    }, label: {
                        Text("Cancel").bold()
                    }))
                }
            })
        
    }
    
}

struct LogInButton : View {
    
    @Binding  var showForms : Bool
    
    var body: some View{
        
        VStack (alignment: .center){
            Button(action: {
                showForms.toggle()
            }){
                HStack{
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .font(.system(size: Help.width_button*0.4))
                        .foregroundColor(.white_gray)
                        .padding(0.5)
                    Text("Log In")
                        .font(.system(size: Help.width_button*0.25))
                        .foregroundColor(.white_gray)
                        .bold()
                        .padding(0.5)
                }
                .padding(10.0)
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.blue_info.opacity(95.0))
            .cornerRadius(15.0)
            .shadow(radius: 5)
        }
        
    }
    
}

struct RegisterButton : View {
    
    @Binding  var showForms : Bool
    
    var body: some View{
        
        VStack (alignment: .center){
            Button(action: {
                showForms.toggle()
            }){
                HStack{
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: Help.width_button*0.4))
                        .foregroundColor(.white_gray)
                        .padding(0.5)
                    Text("Register")
                        .font(.system(size: Help.width_button*0.25))
                        .foregroundColor(.white_gray)
                        .bold()
                        .padding(0.5)
                }
                .padding(10.0)
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.light_green.opacity(70.0))
            .cornerRadius(15.0)
            .shadow(radius: 5)
        }
    }
    
}

struct AboutButton : View {
    
    var body: some View {
        
        Button(action: {
            print("About pressed")
            //Open view controller
        }){
            
            Image(systemName: "info.circle")
                .font(.system(size: Help.width_button*0.5))
                .foregroundColor(.dark_green)
                .buttonStyle(PlainButtonStyle())
                .padding(0.5)
        }
        .padding(.trailing,Help.border_padding*2.0)
    }
}

struct UserPicture : View {
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    
    var body: some View {
        
        Image(systemName: self.selectedModelManager.loggedUser == nil ? "person" : "person.fill")
            //Image(self.selectedModelManager.loggedUser == nil ? "person" : self.selectedModelManager.loggedUser?.getImage())
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .shadow(radius: 10)
            .overlay(
                Circle().stroke(Color.dark_green, lineWidth: 2))
            .frame(width: Help.width_button*3.0, height: Help.height_button*3.0, alignment: .center)
            .padding(.bottom,10.0)
    }
}

struct UserInformation : View {
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    
    var body: some View {
        
        HStack{
            VStack{
                Text("Projects")
                    .font(.system(size: Help.width_button*0.3))
                    .foregroundColor(.light_beish)
                    .bold()
                    .padding(0.5)
                Divider()
                    .background(Color.light_beish)
                Text(selectedModelManager.loggedUser == nil ? "1" : "XX")
                    .font(.system(size: Help.width_button*0.4))
                    .foregroundColor(.light_green)
                    .bold()
                    .padding(0.5)
            }
            .padding(7.5)
            VStack{
                Text("Planted Trees")
                    .font(.system(size: Help.width_button*0.3))
                    .foregroundColor(.light_beish)
                    .bold()
                    .padding(0.5)
                Divider()
                    .background(Color.light_beish)
                Text(selectedModelManager.loggedUser == nil ? "1" : "XX")
                    .font(.system(size: Help.width_button*0.4))
                    .foregroundColor(.light_green)
                    .bold()
                    .padding(0.5)
            }
            .padding(7.5)
            VStack{
                Text("Areas")
                    .font(.system(size: Help.width_button*0.3))
                    .foregroundColor(.light_beish)
                    .bold()
                    .padding(0.5)
                Divider()
                    .background(Color.light_beish)
                Text(selectedModelManager.loggedUser == nil ? "1" : "XX")
                    .font(.system(size: Help.width_button*0.4))
                    .foregroundColor(.light_green)
                    .bold()
                    .padding(0.5)
            }
            .padding(7.5)
        }
        .background(Color.dark_green)
        .cornerRadius(15.0)
        .shadow(radius: 5)
        .frame(width: Help.height_screen*10.0, height: Help.height_button*2.0, alignment: .center)
        
    }
    
}

struct UserName : View {
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    
    var body: some View {
        
        HStack{
            Text(selectedModelManager.loggedUser == nil ?  "Random Name" : selectedModelManager.loggedUser!.getDisplayName())
                .foregroundColor(Color.dark_green)
                .font(.system(size: Help.width_button*0.5))
                .shadow(radius: 10)
                .padding(0.5)
        }
        .padding(10.0)
        
    }
}

struct MailUsernameInformation : View {
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    
    var body: some View {
        
        VStack{
            HStack{
                Image(systemName: "envelope")
                    .font(.system(size: Help.width_button*0.4))
                    .foregroundColor(.dark_green)
                    .padding(0.5)
                Text("e-mail:")
                    .font(.system(size: Help.width_button*0.25))
                    .foregroundColor(.dark_green)
                    .bold()
                    .padding(0.5)
                Text(selectedModelManager.loggedUser == nil ? "example@email.com" : selectedModelManager.loggedUser!.getEmail())
                    .font(.system(size: Help.width_button*0.25))
                    .foregroundColor(.dark_green)
                    .padding(0.5)
            }
            .padding(5.0)
            /*
             HStack{
             Image(systemName: "person.circle")
             .font(.system(size: Help.width_button*0.4))
             .foregroundColor(.dark_green)
             .padding(0.5)
             Text("username:")
             .font(.system(size: Help.width_button*0.25))
             .foregroundColor(.dark_green)
             .bold()
             .padding(0.5)
             Text("matiasariel")
             .font(.system(size: Help.width_button*0.25))
             .foregroundColor(.dark_green)
             .padding(0.5)
             }
             .padding(5.0)
             */
        }
        
    }
    
}

struct EditProfileButton : View {
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    
    var body: some View {
        VStack(alignment: .center){
            
            Button(action: {
                print("Edit Profile Pressed")
                print(self.selectedModelManager.loggedUserBool)
            }){
                HStack{
                    Image(systemName: "pencil")
                        .font(.system(size: Help.width_button*0.4))
                        .foregroundColor(.white_gray)
                        .padding(0.5)
                    Text("Edit Profile")
                        .font(.system(size: Help.width_button*0.25))
                        .foregroundColor(.white_gray)
                        .bold()
                        .padding(0.5)
                }
                .padding(10.0)
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.dark_green)
            .cornerRadius(15.0)
            .shadow(radius: 5)
        }
    }
    
}


struct LogOutButton : View {
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    
    var body: some View {
        
        VStack(alignment: .center){
            Button(action: {
                do {
                    try Auth.auth().signOut()
                    //Success
                    self.selectedModelManager.loggedUserBool = false
                    //self.selectedModelManager.loggedUser = nil
                    
                } catch  {
                    print("An error ocurred")
                    print("Error SwiftUI")
                }
            }){
                HStack{
                    Image(systemName: "person.crop.circle.badge.minus")
                        .font(.system(size: Help.width_button*0.4))
                        .foregroundColor(.white_gray)
                        .padding(0.5)
                    Text("Log Out")
                        .font(.system(size: Help.width_button*0.25))
                        .foregroundColor(.white_gray)
                        .bold()
                        .padding(0.5)
                }
                .padding(5.0)
            }
            .padding(3.0)
            .buttonStyle(PlainButtonStyle())
            .background(Color.red_error.opacity(95.0))
            .cornerRadius(15.0)
            .shadow(radius: 5)
            .frame(width: Help.width_button*7.0, height: Help.height_button*0.80, alignment: .center)
            
        }
        .padding(.bottom,Help.border_padding*2.0)
        
    }
    
}
