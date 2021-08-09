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
                        if(self.selectedModelManager.loggedUser != nil){
                            EditProfileAction()
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

struct EditProfileAction : View {
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    
    @State var showFormsEdit : Bool = false
    @State var form_message : String = ""
    
    @State var old_email: String = CurrentSession.sharedInstance.getEmail()
    @State var email: String = ""
    @State var confirm_email: String = ""
    
    
    @State var password: String = ""
    @State var confirm_password: String = ""
    
    @State var old_display_name: String = CurrentSession.sharedInstance.getDisplayName()
    @State var display_name: String = ""
    
    @State var image : Image = Image(systemName: "person")
    
    
    var body: some View{
        
        EditProfileButton(showFormsEdit: self.$showFormsEdit)
            .sheet(isPresented: self.$showFormsEdit, content: {
                NavigationView{
                    VStack{
                        Form {
                            if(form_message != ""){
                                Text(form_message)
                                    .font(.system(size: Help.width_button*0.25))
                                    .foregroundColor(Color.light_beish)
                            }
                            Section(header: Text("User's Display Name"), footer: Text("Display Name must have at least 1 character including any letter lowercase or uppercase and numbers. Not any kind of special characters")) {
                                HStack{
                                    Text("Old Display Name")
                                    Spacer()
                                    Text(old_display_name)
                                }
                                TextField("New Display Name", text: $display_name, onEditingChanged: { (changed) in
                                    if(!display_name.hasCharacters()){
                                        self.form_message = "This is not a valid Display Name. Please check it again"
                                    }else {
                                        self.form_message = ""
                                    }
                                })
                            }
                            
                            Section(header: Text("User's Email")) {
                                
                                HStack{
                                    Text("Old Email Name")
                                    Spacer()
                                    Text(old_email)
                                }
                                
                                TextField("New E-mail", text: $email, onEditingChanged: { (changed) in
                                    if(!self.email.isEmpty && !self.email.isAnEmail()){
                                        self.form_message = "This is not a valid email. Please check it again"
                                    }else {
                                        self.form_message = ""
                                    }
                                })
                                
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                
                                TextField("Confirm New E-mail", text: $confirm_email, onEditingChanged: { (changed) in
                                    if(self.email != self.confirm_email){
                                        self.form_message = "Both emails don't match. Please check it again"
                                    }else {
                                        self.form_message = ""
                                    }
                                })
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                            }
                            
                            
                            Section(header: Text("New User's Password"), footer: Text("Password must have a minimum of 8 characters with at least 1 Alphabet and 1 Number")){
                                
                                SecureField("New Password", text: $password, onCommit: {
                                    if(!self.password.isEmpty && !self.password.isGoodPassword()){
                                        self.form_message = "This is not a valid password. Please check it again"
                                    }else {
                                        self.form_message = ""
                                    }
                                })
                                
                                SecureField("Confirm New Password", text: $confirm_password, onCommit: {
                                    if(self.password != self.confirm_password){
                                        self.form_message = "Both passwords don't match. Please check it again"
                                    }else  {
                                        self.form_message = ""
                                    }
                                })
                            }
                            
                            
                            Section(header: Text("User's Profile Picture")) {
                                TextField("Picture", text: $email)
                            }
                            
                            Section(content: {
                                Button(action: {
                                    form_message = "Profile edited succesfully"
                                    if(display_name != old_display_name){
                                        CurrentSession.sharedInstance.setNewDisplayName(new: display_name)
                                    }
                                    if(self.old_email != self.confirm_email){
                                        CurrentSession.sharedInstance.setNewEmail(new: confirm_email)
                                    }
                                    if(!self.confirm_password.isEmpty){
                                        CurrentSession.sharedInstance.setNewPassword(new: confirm_password)
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                        self.selectedModelManager.loggedUser = Auth.auth().currentUser
                                        self.showFormsEdit.toggle()
                                    })
                                    
                                },label: {
                                    HStack(alignment: .center){
                                        Text("Save Changes")
                                        Image(systemName: "checkmark.circle.fill")
                                    }
                                })
                            })
                            .disabled(self.form_message != "" && self.password != self.confirm_password)
                        }
                    }
                    .navigationTitle(Text("Edit Profile")).navigationBarTitleDisplayMode(.large)
                    .navigationBarItems(trailing: Button(action: {
                        self.showFormsEdit.toggle()
                        
                        display_name = ""
                        email = ""
                        confirm_email = ""
                        password = ""
                        confirm_password = ""
                        
                    }, label: {
                        Text("Cancel").bold()
                    }))
                }
            })
        
    }
}


struct EditProfileButton : View {
    @Binding var showFormsEdit : Bool
    var body: some View {
        VStack(alignment: .center){
            
            Button(action: {
                print("Edit Profile Pressed")
                self.showFormsEdit.toggle()
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



struct ActionButtons : View {
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    
    var body: some View{
        if(self.selectedModelManager.loggedUser == nil){
            
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
    @State var form_message : String = ""
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    
    var body: some View{
        VStack{
            LogInButton(showForms: $showForms)
                .sheet(isPresented: $showForms, content: {
                    NavigationView{
                        VStack{
                            Form {
                                if(form_message != ""){
                                    Text(form_message)
                                        .font(.system(size: Help.width_button*0.25))
                                        .foregroundColor(Color.light_beish)
                                }
                                Section(header: Text("User Information")) {
                                    
                                    TextField("E-mail", text: $email, onEditingChanged: { (changed) in
                                        if(self.email.isEmpty){
                                            self.form_message = "Email is empty"
                                        }else if(!self.email.isAnEmail()){
                                            self.form_message = "This is not a valid email. Please check it again"
                                        }else {
                                            self.form_message = ""
                                        }
                                    })
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                                    
                                    SecureField("Password", text: $password, onCommit: {
                                        if(self.password.isEmpty){
                                            self.form_message = "Password is empty"
                                        }else if(!self.password.isGoodPassword()){
                                            self.form_message = "This is not a valid password. Please check it again"
                                        }else {
                                            self.form_message = ""
                                        }
                                    })
                                }
                                
                                Section(content: {
                                    HStack(alignment: .center){
                                        Button(action: {
                                            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                                                if error != nil {
                                                    form_message = "Error singing in. \(error!.localizedDescription)"
                                                } else {
                                                    self.selectedModelManager.loggedUser = result?.user
                                                    CurrentSession.sharedInstance.setUser(user: result!.user)
                                                    //form_message = "You have logged in. \(result!.description)"
                                                    self.showForms.toggle()
                                                }
                                            }
                                        },label: {
                                            HStack(alignment: .center){
                                                Text("Log In ")
                                                Image(systemName: "checkmark.circle.fill")
                                            }
                                        })
                                        .disabled(self.form_message != "")
                                    }
                                })
                            }
                        }
                        .navigationTitle(Text("Log In")).navigationBarTitleDisplayMode(.large)
                        .navigationBarItems(trailing: Button(action: {
                            self.showForms.toggle()
                            
                            email = ""
                            password = ""

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
    
    @State var form_message : String = ""
    
    var body: some View{
        
        RegisterButton(showForms: $showFormsRegister)
            .sheet(isPresented: $showFormsRegister, content: {
                NavigationView{
                    VStack{
                        Form {
                            if(form_message != ""){
                                Text(form_message)
                                    .font(.system(size: Help.width_button*0.25))
                                    .foregroundColor(Color.light_beish)
                            }
                            Section(header: Text("User's Display Name"), footer: Text("Display Name must have at least 1 character including any letter lowercase or uppercase and numbers. Not any kind of special characters")) {
                                TextField("Display Name", text: $display_name, onEditingChanged: { (changed) in
                                    if(!display_name.hasCharacters()){
                                        self.form_message = "This is not a valid Display Name. Please check it again"
                                    }else {
                                        self.form_message = ""
                                    }
                                })
                            }
                            
                            Section(header: Text("User's Email")) {
                                ZStack{
                                    TextField("E-mail", text: $email, onEditingChanged: { (changed) in
                                        if(self.email.isEmpty){
                                            self.form_message = "Email is empty"
                                        }else if(!self.email.isAnEmail()){
                                            self.form_message = "This is not a valid email. Please check it again"
                                        }else {
                                            self.form_message = ""
                                        }
                                    })
                                }
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                
                                TextField("Confirm E-mail", text: $confirm_email, onEditingChanged: { (changed) in
                                    if(self.email != self.confirm_email){
                                        self.form_message = "Both emails don't match. Please check it again"
                                    }else {
                                        self.form_message = ""
                                    }
                                })
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                            }
                            
                            
                            Section(header: Text("User's Password"), footer: Text("Password must have a minimum of 8 characters with at least 1 Alphabet and 1 Number")){
                                SecureField("Password", text: $password, onCommit: {
                                    if(self.password.isEmpty){
                                        self.form_message = "Password is empty"
                                    }else if(!self.password.isGoodPassword()){
                                        self.form_message = "This is not a valid password. Please check it again"
                                    }else {
                                        self.form_message = ""
                                    }
                                })
                                
                                SecureField("Confirm Password", text: $confirm_password, onCommit: {
                                    if(self.password != self.confirm_password){
                                        self.form_message = "Both passwords don't match. Please check it again"
                                    }else {
                                        self.form_message = ""
                                    }
                                })
                            }
                            
                            
                            Section(header: Text("User's Profile Picture")) {
                                TextField("Picture", text: $email)
                            }
                            
                            Section(content: {
                                Button(action: {
                                    Auth.auth().createUser(withEmail: email, password: password){ (result, error) in
                                        if error != nil {
                                            form_message = "Error creating account. \(error!.localizedDescription)"
                                        } else {
                                            form_message = "User created sucessfully."
                                            CurrentSession.sharedInstance.setNewDisplayName(new: display_name)
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                                self.selectedModelManager.loggedUser = result?.user
                                                CurrentSession.sharedInstance.setUser(user: result!.user)
                                                self.showFormsRegister.toggle()
                                            })
                                        }
                                    }
                                },label: {
                                    HStack(alignment: .center){
                                        Text("Register")
                                        Image(systemName: "checkmark.circle.fill")
                                    }
                                })
                            })
                            .disabled(self.form_message != "" && self.password != self.confirm_password)
                        }
                    }
                    .navigationTitle(Text("Register")).navigationBarTitleDisplayMode(.large)
                    .navigationBarItems(trailing: Button(action: {
                        self.showFormsRegister.toggle()
                        
                        display_name = ""
                        email = ""
                        confirm_email = ""
                        password = ""
                        confirm_password = ""
                        
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
            Text((selectedModelManager.loggedUser?.displayName ?? "Random Name"))
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
                Text(selectedModelManager.loggedUser == nil ?  "example@email.com" : selectedModelManager.loggedUser!.email!)
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


struct LogOutButton : View {
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    
    var body: some View {
        
        VStack(alignment: .center){
            Button(action: {
                do {
                    try Auth.auth().signOut()
                    //Success
                    self.selectedModelManager.loggedUser = nil
                    CurrentSession.sharedInstance.removeUser()
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
