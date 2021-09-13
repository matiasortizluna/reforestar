//
//  CenterLayout.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 13/07/2021.
//

import Foundation
import SwiftUI
import MapKit
import Combine

struct CustomARUserInterface : View {
    
    //Variables of State for different Menus
    @State private var height_screen = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(30.0) : CGFloat(50.0)
    @State private var width_screen = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(60.0) : CGFloat(175.0)
    
    @State private var height_button = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(55.0) : CGFloat(72.0)
    @State private var width_button = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(55.0) : CGFloat(72.0)
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    @EnvironmentObject var userFeedbackManager : UserFeedback
    
    @State private var showTabBar : Bool = false
    @State private var showTreeCatalog : Bool = false
    @State private var showDesiredLocation : Bool = false
    
    @State public var desired_location : Dictionary<String, Any> = ["longitude" : 0.0, "latitude": 0.0]
    
    let notification_preparation_load_progress = Notification.Name("notification_preparation_load_progress")
    let notification_delete_all_trees_confirmation = Notification.Name("delete_all_trees_confirmation")
    let notification_remove_last_anchor_confirmation = Notification.Name("last_anchor_confirmation")
    let notification_placed_tree_confirmation = Notification.Name("notification_placed_tree_confirmation")
    let notification_save_progress_confirmation = Notification.Name("notification_save_progress_confirmation")
    
    init() {}
    
    var body: some View{
        ZStack(alignment: .center){
            VStack(alignment: .center, spacing: 10.0){
                Spacer()
                VStack{
                    if(self.showDesiredLocation){
                        CurrentCoordinatesLabel(background_color: .dark_green, height_button: self.$height_button, width_button: self.$width_button)
                        DesiredCoordinatesLabel(background_color: .light_green, latitude: self.desired_location["latitude"] as! CLLocationDegrees, longitude: self.desired_location["longitude"] as! CLLocationDegrees, height_button: self.$height_button, width_button: self.$width_button)
                    }
                }
                Spacer()
                VStack{
                    if(userFeedbackManager.show_message){
                        UserFeedbackMessage(height_button: self.$height_button, width_button: self.$width_button)
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration:0.5)))
                    }
                }
                Spacer()
            }
            VStack(alignment: .center){
                HStack(alignment: .top){
                    NumberOfTreesOnSceneLabel(background_color: .dark_green, height_button: self.$height_button, width_button: self.$width_button)
                    Spacer()
                    ReforestationPlanSwitch(background_color: .dark_green, height_button: self.$height_button, width_button: self.$width_button)
                }
                Spacer()
                HStack(alignment: .bottom){
                    UndoButton(height_button: self.$height_button, width_button: self.$width_button)
                    Spacer()
                    SelectedModelButtonLabel(background_color: .dark_green, height_button: self.$height_button, width_button: self.$width_button, showTreeCatalog: self.$showTreeCatalog)
                    Spacer()
                    VStack{
                        ZStack{
                            if(showTabBar){
                                RightBar(height_screen: self.$height_screen, width_screen: self.$width_screen, height_button: self.$height_button, width_button: self.$width_button, showTreeCatalog: self.$showTreeCatalog)
                            }
                        }
                        ShowBarButton(optionToToggle: $showTabBar, height_button: self.$height_button, width_button: self.$width_button, action: {
                            self.showTabBar.toggle()
                        }, icon_string1: "chevron.right.square.fill", icon_string2: "chevron.backward.square", button_title: "Menu")
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: self.notification_preparation_load_progress), perform: { obj in
                print("Notification received from a publisher To prepare load progress!")
                if(CurrentSession.sharedInstance.getReforestationPlanOption()){
                    self.showDesiredLocation = true
                    self.desired_location["latitude"] = obj.userInfo!["latitude"]
                    self.desired_location["longitude"] = obj.userInfo!["longitude"]
                    
                    self.userFeedbackManager.show_message.toggle()
                    self.userFeedbackManager.title_string = "Load Progress Process Started"
                    self.userFeedbackManager.title_color = Color.white_gray
                    self.userFeedbackManager.text_string = "Select the origin point for the trees."
                    self.userFeedbackManager.text_color = Color.white_gray
                    self.userFeedbackManager.back_color = Color.blue_info.opacity(0.95)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                        self.userFeedbackManager.show_message = false
                    })
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: self.notification_delete_all_trees_confirmation), perform: { _ in
                print("Confirmation of deleting objects")
                selectedModelManager.scene_anchors=0
                
                
                self.userFeedbackManager.title_string = "All Trees Deleted from Scene"
                self.userFeedbackManager.title_color = Color.black
                self.userFeedbackManager.text_string = "You can always add more trees to the scene :)"
                self.userFeedbackManager.text_color = Color.black
                self.userFeedbackManager.back_color = Color.red_error.opacity(0.95)
                
                self.userFeedbackManager.show_message.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    self.userFeedbackManager.show_message = false
                })
            })
            .onReceive(NotificationCenter.default.publisher(for: self.notification_remove_last_anchor_confirmation), perform: { _ in
                print("Confirmation of deleting last anchor")
                selectedModelManager.scene_anchors-=1
                
                self.userFeedbackManager.title_string = "Last Tree Deleted from Scene"
                self.userFeedbackManager.title_color = Color.black
                self.userFeedbackManager.text_string = "You can always add more trees to the scene :)"
                self.userFeedbackManager.text_color = Color.black
                self.userFeedbackManager.back_color = Color.red_error.opacity(0.95)
                
                self.userFeedbackManager.show_message.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    self.userFeedbackManager.show_message = false
                })
            })
            .onReceive(NotificationCenter.default.publisher(for: self.notification_placed_tree_confirmation), perform: { obj in
                print("Trying to place an element")
                
                if (obj.userInfo!["code"] != nil){
                    let code : Int = Int(obj.userInfo!["code"] as! NSNumber)
                    switch(code)
                    {
                    case 1:
                        print("Place 1")
                        self.showDesiredLocation = false
                        
                        self.userFeedbackManager.show_message = true
                        self.userFeedbackManager.title_string = "Success at Placing Trees"
                        self.userFeedbackManager.title_color = Color.black
                        self.userFeedbackManager.text_string = "You can always add more trees to the scene :)"
                        self.userFeedbackManager.text_color = Color.black
                        self.userFeedbackManager.back_color = Color.light_green.opacity(0.95)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                            self.userFeedbackManager.show_message = false
                        })
                    case 2:
                        print("Place 2")
                        self.userFeedbackManager.show_message = true
                        self.userFeedbackManager.title_string = "Cound't find space for Trees"
                        self.userFeedbackManager.title_color = Color.black
                        self.userFeedbackManager.text_string = "Please try again"
                        self.userFeedbackManager.text_color = Color.black
                        self.userFeedbackManager.back_color = Color.yellow_warning.opacity(0.95)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                            self.userFeedbackManager.show_message = false
                        })
                    case 3:
                        print("Place 3")
                        self.userFeedbackManager.show_message = true
                        self.userFeedbackManager.title_string = "Coudn't find surface for the Trees"
                        self.userFeedbackManager.title_color = Color.black
                        self.userFeedbackManager.text_string = "Please try again :)"
                        self.userFeedbackManager.text_color = Color.black
                        self.userFeedbackManager.back_color = Color.yellow_warning.opacity(0.95)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                            self.userFeedbackManager.show_message = false
                        })
                    case 4:
                        print("Place 4")
                        self.userFeedbackManager.show_message = true
                        self.userFeedbackManager.title_string = "Error Placing Trees"
                        self.userFeedbackManager.title_color = Color.black
                        self.userFeedbackManager.text_string = "Please Try Again :)"
                        self.userFeedbackManager.text_color = Color.black
                        self.userFeedbackManager.back_color = Color.red_error.opacity(0.95)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                            self.userFeedbackManager.show_message = false
                        })
                    case 5:
                        print("Confirmation of placing an element after Load")
                        self.userFeedbackManager.show_message = true
                        self.userFeedbackManager.title_string = "Loaded Trees Successfully"
                        self.userFeedbackManager.title_color = Color.black
                        self.userFeedbackManager.text_string = "You can always add more trees to the scene :)"
                        self.userFeedbackManager.text_color = Color.black
                        self.userFeedbackManager.back_color = Color.sucess.opacity(0.95)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                            self.userFeedbackManager.show_message = false
                        })
                    case 6:
                        //Get closer to position
                        self.userFeedbackManager.show_message = true
                        self.userFeedbackManager.title_string = "Can't Load Trees"
                        self.userFeedbackManager.title_color = Color.black
                        self.userFeedbackManager.text_string = "You're \(Float(obj.userInfo!["distance"] as! NSNumber)) m. away from location. Get at least less than 10 meters."
                        self.userFeedbackManager.text_color = Color.black
                        self.userFeedbackManager.back_color = Color.blue_info.opacity(0.95)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                            self.userFeedbackManager.show_message = false
                        })
                    default:
                        print("Default option")
                    }
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: self.notification_save_progress_confirmation), perform: { obj in
                    print("Trying to save progress")
                    
                    if (obj.userInfo!["code"] != nil){
                        let code : Int = Int(obj.userInfo!["code"] as! NSNumber)
                        switch(code)
                        {
                        case 1:
                            //Success at Saving Progress
                            self.userFeedbackManager.show_message = true
                            self.userFeedbackManager.title_string = "Success at Saving Progress"
                            self.userFeedbackManager.title_color = Color.black
                            self.userFeedbackManager.text_string = "You can always add more trees to the scene :)"
                            self.userFeedbackManager.text_color = Color.black
                            self.userFeedbackManager.back_color = Color.light_green.opacity(0.95)
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                                self.userFeedbackManager.show_message = false
                            })
                        case 2:
                            //There are no elements to be saved.
                            self.userFeedbackManager.show_message = true
                            self.userFeedbackManager.title_string = "No elements to be saved"
                            self.userFeedbackManager.title_color = Color.black
                            self.userFeedbackManager.text_string = "Place some trees and then try again :)"
                            self.userFeedbackManager.text_color = Color.black
                            self.userFeedbackManager.back_color = Color.yellow_warning.opacity(0.95)
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                                self.userFeedbackManager.show_message = false
                            })
                        case 3:
                            //There is no project selected
                            self.userFeedbackManager.show_message = true
                            self.userFeedbackManager.title_string = "No project selected"
                            self.userFeedbackManager.title_color = Color.black
                            self.userFeedbackManager.text_string = "Please select a project in order to save progress"
                            self.userFeedbackManager.text_color = Color.black
                            self.userFeedbackManager.back_color = Color.yellow_warning.opacity(0.95)    
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                                self.userFeedbackManager.show_message = false
                            })
                        default:
                            print("Default option")
                        }
                    }
                })
        }
        
    }
}

struct ReforestationPlanSwitch: View {
    
    let background_color: Color
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    @State private var reforestation_plan : Bool = CurrentSession.sharedInstance.getReforestationPlanOption()
    var currentSessionManager = CurrentSession.sharedInstance
    
    let notification_reforestation_plan = Notification.Name("reforestationPlan")
    
    var body: some View{
        ZStack(alignment: .trailing){
            HStack(alignment: .center){
                Text("Reforestation\nRules")
                    .font(.system(size: self.width_button*0.2))
                    .foregroundColor(.light_beish)
                    .bold()
                Toggle("", isOn: $reforestation_plan).toggleStyle(SwitchToggleStyle(tint: .light_green))
                    .labelsHidden()
                    .onChange(of: reforestation_plan, perform: { _ in
                        self.currentSessionManager.toogleReforestationPlanOption()
                    })
            }
            .padding(3.0)
            .frame(width: self.width_button == 72.0 ? self.width_button*2.3 : self.width_button*3.0, height: self.height_button*0.8, alignment: .center)
        }
        .background(self.background_color)
        .cornerRadius(15.0)
        .padding(.top, 15.0)
        .padding(.trailing, 15.0)
    }
}

struct UserFeedbackMessage : View {
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    @EnvironmentObject var userFeedbackManager : UserFeedback
    
    var body: some View{
        HStack{
            VStack(alignment: .center, spacing: 3.0){
                Spacer()
                HStack(alignment: .center, spacing: 3.0){
                    Image(systemName: userFeedbackManager.icon_string)
                        .font(.system(size: self.width_button*0.45))
                        .foregroundColor(userFeedbackManager.title_color)
                        .buttonStyle(PlainButtonStyle())
                    Text(userFeedbackManager.title_string)
                        .font(.system(size: self.width_button*0.25))
                        .foregroundColor(userFeedbackManager.title_color)
                        .bold()
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                }
                HStack(alignment: .center){
                    Text(userFeedbackManager.text_string)
                        .font(.system(size: self.width_button*0.2))
                        .foregroundColor(userFeedbackManager.text_color)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                Spacer()
                HStack(alignment: .center){
                    Button( action: {
                        self.userFeedbackManager.show_message = false
                    }, label: {
                        VStack(alignment: .center){
                            Text("Dismiss")
                                .font(.system(size: self.width_button*0.15))
                                .foregroundColor(.black)
                                .bold()
                        }.padding(1.5)
                    })
                    .frame(width: self.width_button*2.0, height: self.height_button*0.5, alignment: .center)
                    .background(Color.white_gray.opacity(95.0))
                    .border(Color.gray)
                    .cornerRadius(35.0)
                    .overlay(RoundedRectangle(cornerRadius: 35.0).stroke(Color.black, lineWidth: 3))
                }
                Spacer()
            }
            .frame(width: self.width_button*5.0, height: self.height_button*2.0, alignment: .center)
        }
        .background(userFeedbackManager.back_color)
        .cornerRadius(15.0)
        .overlay(RoundedRectangle(cornerRadius: 15.0).stroke(userFeedbackManager.title_color, lineWidth: 5))
    }
}

struct NumberOfTreesOnSceneLabel : View {
    
    let background_color: Color
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    
    var body: some View{
        
        ZStack(alignment: .leading){
            HStack(alignment: .center){
                Text("Nº of Trees on \nCurrent Scene")
                    .font(.system(size: self.width_button*0.2))
                    .foregroundColor(.light_beish)
                    .bold()
                Text(String(selectedModelManager.scene_anchors))
                    .font(.system(size: self.width_button*0.3))
                    .bold()
                    .foregroundColor(.light_green)
            }
            .padding(3.0)
            .frame(width: self.width_button*2.0, height: self.height_button*0.8, alignment: .center)
        }
        .background(self.background_color)
        .cornerRadius(15.0)
        .padding(.top, 15.0)
        .padding(.leading, 15.0)
        
    }
    
}

struct CurrentCoordinatesLabel : View {
    
    let background_color: Color
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    @EnvironmentObject var locationManager : LocationManager
    var currentSceneManager = CurrentSession.sharedInstance
    
    var body: some View{
        let coordinate = self.locationManager.coordinates != nil ? self.locationManager.coordinates!.coordinate : CLLocationCoordinate2D()
        
        HStack(alignment: .top){
            VStack(alignment: .center){
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: self.width_button*0.45))
                    .foregroundColor(.light_beish)
                    .buttonStyle(PlainButtonStyle())
            }
            .padding(1.5)
            VStack(alignment: .center){
                HStack(alignment: .center){
                    Text("Current Latitude & Longitude")
                        .font(.system(size: self.width_button*0.2))
                        .foregroundColor(.light_beish)
                        .bold()
                }
                HStack(alignment: .center){
                    Text("\(coordinate.latitude)")
                        .font(.system(size: self.width_button*0.25))
                        .foregroundColor(.light_green)
                        .bold()
                    Text("|")
                        .font(.system(size: self.width_button*0.3))
                        .foregroundColor(.light_green)
                        .bold()
                    Text("\(coordinate.longitude)")
                        .font(.system(size: self.width_button*0.25))
                        .foregroundColor(.light_green)
                        .bold()
                }
            }
            .padding(1.5)
        }
        .frame(width: self.width_button*4, height: self.height_button*0.8, alignment: .center)
        .background(self.background_color)
        .cornerRadius(15.0)
        .padding(.top, 15.0)
    }
}

struct DesiredCoordinatesLabel : View {
    
    let background_color: Color
    let latitude : CLLocationDegrees
    let longitude : CLLocationDegrees
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    var currentSceneManager = CurrentSession.sharedInstance
    
    var body: some View{ 
        HStack(alignment: .top){
            VStack(alignment: .center){
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: self.width_button*0.45))
                    .foregroundColor(.dark_green)
                    .buttonStyle(PlainButtonStyle())
            }
            .padding(1.5)
            VStack(alignment: .center){
                HStack(alignment: .center){
                    Text("Desired Latitude & Longitude")
                        .font(.system(size: self.width_button*0.2))
                        .foregroundColor(.dark_green)
                        .bold()
                }
                HStack(alignment: .center){
                    Text(String(format: "%0.6f",self.latitude))
                        .font(.system(size: self.width_button*0.2))
                        .foregroundColor(.dark_green)
                        .bold()
                    Text("|")
                        .font(.system(size: self.width_button*0.3))
                        .foregroundColor(.dark_green)
                        .bold()
                    Text(String(format: "%0.6f", self.longitude))
                        .font(.system(size: self.width_button*0.2))
                        .foregroundColor(.dark_green)
                        .bold()
                }
            }
            .padding(1.5)
        }
        .frame(width: self.width_button*4, height: self.height_button*0.8, alignment: .center)
        .background(self.background_color)
        .cornerRadius(15.0)
        .padding(.top, 15.0)
    }
}

struct SelectedModelButtonLabel : View {
    
    let background_color: Color
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    
    @Binding var showTreeCatalog : Bool
    
    var body: some View{
        HStack(alignment: .bottom){
            Button( action: {
                self.showTreeCatalog.toggle()
            }, label: {
                VStack(alignment: .center){
                    Image(systemName: "move.3d")
                        .font(.system(size: self.width_button*0.45))
                        .foregroundColor(.light_beish)
                        .buttonStyle(PlainButtonStyle())
                }.padding(1.5)
                VStack(alignment: .center){
                    HStack{
                        Text("3D Selected Model")
                            .font(.system(size: self.width_button*0.2))
                            .foregroundColor(.light_beish)
                            .bold()
                    }
                    HStack{
                        Text(self.selectedModelManager.selectedModelName)
                            .font(.system(size: self.width_button*0.3))
                            .bold()
                            .foregroundColor(.light_green)
                    }
                }.padding(1.5)
            })
            .frame(width: self.width_button*3.0, height: self.height_button*0.8, alignment: .center)
            .background(self.background_color)
            .cornerRadius(15.0)
            .padding(.bottom, 20.0)
            .sheet(isPresented: $showTreeCatalog, content: {
                //Browse View
                NavigationView{
                    ZStack{
                        Color.light_beish.edgesIgnoringSafeArea(.all)
                        
                        ScrollView(.vertical, showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, content: {
                            //All Trees
                            VerticalGrid(showTreeCatalog: $showTreeCatalog)
                        })
                        .navigationTitle(Text("Tree's Catalog")).navigationBarTitleDisplayMode(.large)
                        .navigationBarItems(trailing: Button(action: {
                            self.showTreeCatalog.toggle()
                        }, label: {
                            Text("Done").bold()
                        }))
                    }
                    
                }
                
            })
        }
    }
}

struct UndoButton : View {
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    @State var optionToToggle : Bool = false
    
    let notification_name = Notification.Name("last_item_anchor")
    
    var currentSceneManager = CurrentSession.sharedInstance
    @EnvironmentObject var userFeedbackManager : UserFeedback
    
    var body: some View {
        VStack{
            ZStack{
                DefaultButtonWithText(icon:  optionToToggle ? "arrowshape.turn.up.left.fill" : "arrowshape.turn.up.left" , icon_color: .light_beish, action: {
                    
                    self.optionToToggle.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {
                        self.optionToToggle.toggle()
                    })
                    
                    NotificationCenter.default.post(name: self.notification_name, object: nil)
                    
                }, button_title: "Undo", height_button: self.$height_button, width_button: self.$width_button)
            }
            .frame(width: self.width_button, height: self.height_button, alignment: .center)
            .background(Color.dark_green)
            .cornerRadius(20.0)
            .padding(.bottom, 15.0)
            .padding(.leading, 15.0)
        }}
}

func setupUserMessage(userFeedbackManager : UserFeedback, icon_string: String, text_color: Color, text_string: String, title_color: Color, title_string: String, back_color: Color) -> Void {
    userFeedbackManager.icon_string = icon_string
    userFeedbackManager.text_color = text_color
    userFeedbackManager.text_string = text_string
    userFeedbackManager.title_color = title_color
    userFeedbackManager.title_string = title_string
    userFeedbackManager.back_color = back_color
    userFeedbackManager.show_message = true
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
        userFeedbackManager.show_message = false
    })
    
}

//Show Right Bar Button
struct ShowBarButton: View{
    @Binding var optionToToggle : Bool
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    let action: ()->Void
    let icon_string1: String
    let icon_string2: String
    let button_title: String
    
    var body: some View{
        VStack{
            ZStack{
                DefaultButtonWithText(icon: optionToToggle ? icon_string1 : icon_string2, icon_color: .light_beish, action: {
                    self.action()
                }, button_title: self.button_title, height_button: self.$height_button, width_button: self.$width_button)
                
            }
            .frame(width: self.width_button, height: self.height_button, alignment: .center)
            .background(Color.dark_green)
            .cornerRadius(20.0)
            .padding(.trailing, 15.0)
            .padding(.top, 5.0)
            .padding(.bottom, 15.0)
        }
    }
}

//Options Button
struct OptionsButton: View {
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    @Binding var showOptionsMenu : Bool
    
    let action: ()->Void
    
    var body: some View{
        HStack{
            ZStack{
                DefaultButtonWithText(icon: showOptionsMenu ? "ellipsis.circle.fill" : "ellipsis.circle" , icon_color: .light_beish, action: {
                    self.action()
                }, button_title: "More", height_button: self.$height_button, width_button: self.$width_button)
            }
            .frame(width: self.width_button, height: self.height_button, alignment: .center)
        }
        .padding(5.0)
    }
}


//Default Button to be used for Buttons
struct DefaultButton: View {
    
    let icon: String
    let icon_color: Color
    let action: ()->Void
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    var body: some View{
        
        Button(action: {
            self.action()
        }){
            Image(systemName: self.icon)
                .font(.system(size: self.width_button*0.45))
                .foregroundColor(self.icon_color)
                .buttonStyle(PlainButtonStyle())
        }
        .frame(width: self.width_button*0.55, height: self.height_button*0.55, alignment: .center)
    }
}

struct DefaultButtonWithText: View {
    
    let icon: String
    let icon_color: Color
    let action: ()->Void
    let button_title : String
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    var body: some View{
        
        Button(action: {
            self.action()
        }){
            VStack{
                Image(systemName: self.icon)
                    .font(.system(size: self.width_button*0.45))
                    .foregroundColor(self.icon_color)
                    .buttonStyle(PlainButtonStyle())
                    .padding(0.5)
                Text(self.button_title)
                    .font(.system(size: self.width_button*0.2))
                    .foregroundColor(self.icon_color)
                    .bold()
                    .padding(0.5)
            }
        }
        .frame(width: self.width_button*0.60, height: self.height_button*0.60, alignment: .center)
    }
}


struct OptionsMenu: View {
    
    @Binding var showOptionsMenu : Bool
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    let notification_delete_all_trees = Notification.Name("delete_all_trees")
    let notification_save_progress = Notification.Name("notification_save_progress")
    let notification_load_progress = Notification.Name("notification_load_progress")
    
    @State private var selectedProject : String = "Default"
    var currentSceneManager = CurrentSession.sharedInstance
    
    @EnvironmentObject var locationManager : LocationManager
    
    var body: some View{
        
        ZStack{
            Color.light_beish
            
            VStack{
                HStack{
                    Button(action: {
                        print("Delete all Trees button pressed")
                        NotificationCenter.default.post(name: self.notification_delete_all_trees, object: nil)
                    }){
                        Image(systemName: "trash")
                            .font(.system(size: self.width_button*0.3))
                            .foregroundColor(Color.white)
                            .buttonStyle(PlainButtonStyle())
                        Text("Delete all Trees")
                            .foregroundColor(Color.white)
                            .font(.system(size: self.width_button*0.25))
                            .bold()
                    }
                    .frame(width: self.width_button*2.5, height: self.height_button*0.60, alignment: .center)
                    .background(Color.red)
                    .cornerRadius(15.0)
                    .padding(5.0)
                }
                .padding(10.0)
                
                Divider().font(.system(size: 3.0))
                
                HStack{
                    VStack{
                        Text("Associated Project")
                            .foregroundColor(Color.dark_green)
                            .font(.system(size: self.width_button*0.25))
                            .bold()
                        Picker("Projects", selection: $selectedProject){
                            ForEach(self.currentSceneManager.getProjectsNames(),id:\.self){
                                
                                Text("\($0)")
                                    .foregroundColor(Color.dark_green)
                                    .font(.system(size: self.width_button*0.25))
                                    .bold()
                                
                            }.onChange(of: selectedProject) { _ in
                                self.currentSceneManager.setSelectedProject(project: selectedProject)
                            }
                        }
                        .frame(width: self.width_button*3.0, height:  self.height_button*2.0, alignment: .center)
                        .clipped()
                        
                        HStack{
                            Button(action: {
                                print("Save Button Pressed")
                                self.showOptionsMenu.toggle()
                                currentSceneManager.user_location = locationManager.coordinates!.coordinate
                                NotificationCenter.default.post(name: self.notification_save_progress, object: nil)
                            }){
                                Image(systemName: "sdcard")
                                    .font(.system(size: self.width_button*0.3))
                                    .foregroundColor(Color.white)
                                    .buttonStyle(PlainButtonStyle())
                                Text("Save")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: self.width_button*0.25))
                                    .bold()
                            }
                            .frame(width: self.width_button*1.5, height: self.height_button*0.60, alignment: .center)
                            .background(Color.light_green)
                            .cornerRadius(15.0)
                            
                            Button(action: {
                                print("Load Button Pressed")
                                self.showOptionsMenu.toggle()
                                //self.showDesiredLocation.toggle()
                                NotificationCenter.default.post(name: self.notification_load_progress, object: nil)
                                
                            }){
                                Image(systemName: "arrow.down.circle")
                                    .font(.system(size: self.width_button*0.3))
                                    .foregroundColor(Color.white)
                                    .buttonStyle(PlainButtonStyle())
                                Text("Load")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: self.width_button*0.25))
                                    .bold()
                            }
                            .frame(width: self.width_button*1.5, height: self.height_button*0.60, alignment: .center)
                            .background(Color.blue)
                            .cornerRadius(15.0)
                        }
                        
                    }
                }
                .padding(10.0)
                
            }.padding(5.0)
        }
        
    }
}

struct RightBar : View {
    
    @Binding var height_screen : CGFloat
    @Binding var width_screen : CGFloat
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    @Binding var showTreeCatalog : Bool
    @State private var showOptionsMenu : Bool = false
    
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    
    var body: some View{
        
        VStack{
            if(self.selectedModelManager.selectedModelName=="Pinus pinaster"){
                PickerSelect(height_screen: self.$height_screen, width_screen: self.$width_screen, height_button: self.$height_button, width_button: self.$width_button)
            }
            HeightSlider(height_screen: self.$height_screen, width_screen: self.$width_screen, height_button: self.$height_button, width_button: self.$width_button)
            OptionsButton(height_button: self.$height_button, width_button: self.$width_button, showOptionsMenu: $showOptionsMenu, action: {
                self.showOptionsMenu.toggle()
                CurrentSession.sharedInstance.fetchNameProjectsOfUser()
            }).popover(isPresented: $showOptionsMenu, arrowEdge: .trailing, content: {
                OptionsMenu(showOptionsMenu: $showOptionsMenu, height_button: self.$height_button, width_button: self.$width_button)
            })
        }
        .frame(minWidth: self.width_button, maxWidth: self.width_button, minHeight: 400, maxHeight: 650, alignment: .center)
        .background(Color.dark_green)
        .cornerRadius(20.0)
        .padding(.trailing, 15.0)
    }
}


struct PickerSelect: View{
    
    @Binding var height_screen : CGFloat
    @Binding var width_screen : CGFloat
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    @State private var numberOfTrees : Int = CurrentSession.sharedInstance.getNumberOfTrees()
    var currentSceneManager = CurrentSession.sharedInstance
    
    var body: some View{
        HStack{
            Text("Trees")
                .foregroundColor(Color.light_beish)
                .font(.system(size: self.width_button*0.25))
                .bold()
        }
        .padding(.bottom,-1.0)
        HStack{
            //Number of trees picker
            Picker("Trees", selection: $numberOfTrees){
                ForEach(1...10,id:\.self){
                    
                    Text("\($0)")
                        .foregroundColor(Color.light_beish)
                        .font(.system(size: self.width_button*0.3))
                        .bold()
                }.onChange(of: numberOfTrees) { _ in
                    self.currentSceneManager.setNumberOfTrees(number: numberOfTrees)
                }
            }
            .frame(width: self.width_screen-20.0, height:  self.height_screen == 30.0 ? 100.0 : 200.0, alignment: .center)
            .clipped()
            .padding(.bottom,3.5)
        }
    }
}


//Tree's Height Slider
struct HeightSlider: View{
    
    @Binding var height_screen : CGFloat
    @Binding var width_screen : CGFloat
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    @State private var current_scale : Double = CurrentSession.sharedInstance.getScaleCompensation()
    var min_scale : Double = 0.01
    var max_scale : Double = 5.01
    
    var currentSceneManager = CurrentSession.sharedInstance
    
    var body: some View{
        HStack{
            Text("Scale")
                .foregroundColor(Color.light_beish)
                .font(.system(size: self.width_button*0.25))
                .bold()
        }
        .padding(0.5)
        HStack{
            Text(String(format: "%0.2f",self.current_scale))
                .foregroundColor(Color.light_green)
                .font(.system(size: self.width_button*0.3))
                .bold()
        }
        .padding(0.5)
        HStack{
            Slider(value: $current_scale, in: min_scale...max_scale,step: 0.10)
                .accentColor(Color.light_beish)
                .rotationEffect(Angle(degrees: -90.0))
                .frame(width: self.height_screen == 30.0 ? 100.0 : 200.0, height: self.width_screen-10.0, alignment: .center)
                .onChange(of: current_scale, perform: { _ in
                    print("Scale Changed: \(self.currentSceneManager.getScaleCompensation())")
                    self.currentSceneManager.setScaleCompensation(number: current_scale)
                })
        }
        .frame(width: self.width_screen-10.0, height: self.width_screen == 60.0 ? 100.0 : 200.0, alignment: .center)
        .padding(0.5)
        .padding(.bottom,3.5)
    }
}


//Tree's Catalog Button
struct TreesCatalogMenu: View{
    
    @Binding var showTreeCatalog : Bool
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    var body: some View{
        
        HStack{
            ZStack{
                DefaultButton(icon: "book", icon_color: .dark_green, action: {
                    print("Tapped on Trees Catalog Button")
                    showTreeCatalog.toggle()
                }, height_button: self.$height_button, width_button: self.$width_button)
            }
            .frame(width: self.width_button*0.8, height: self.height_button*0.8, alignment: .center)
            .background(Color.light_beish.opacity(0.65))
            .cornerRadius(15.0)
            .padding(5.0)
        }
        .padding(.bottom, 3.0)
        
    }
}

struct VerticalGrid: View{
    
    @Binding var showTreeCatalog : Bool
    private let gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @EnvironmentObject var selectedModelManager : CurrentSessionSwiftUI
    var currentSceneManager = CurrentSession.sharedInstance
    
    var body: some View{
        VStack(alignment: .center){
            LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 30, content: {
                ForEach(currentSceneManager.catalog, id: \.latin_name) { tree in
                    if(tree.hasModel){
                        ItemButton(latin_name: tree.latin_name, common_name: tree.common_name, action: {
                            self.selectedModelManager.selectedModelName = tree.latin_name
                            self.currentSceneManager.setSelectedModelName(name: tree.latin_name)
                            self.showTreeCatalog.toggle()
                        })
                    }
                }
                
            })
            .padding(.horizontal,22)
            .padding(.vertical,10)
        }
    }
}

struct ItemButton: View {
    var latin_name:String
    var common_name:String
    let action: () -> Void
    
    var body: some View{
        Button(action: {
            self.action()
        }){
            HStack {
                Spacer()
                VStack(alignment: .center){
                    Image("\(self.latin_name) 3D")
                        .resizable()
                        .frame(width: Help.width_button*1.7, height: Help.height_button*2.0)
                }
                Spacer()
                VStack(alignment: .center, spacing: 5.0) {
                    Text(self.latin_name)
                        .foregroundColor(Color.light_beish)
                        .font(.system(size: Help.width_button*0.3))
                        .bold()
                        .italic()
                    Text(self.common_name)
                        .foregroundColor(Color.light_beish)
                        .font(.system(size: Help.width_button*0.3))
                }
                Spacer()
            }
            .frame(width: Help.width_button*4.0, height: Help.height_button*3.0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(Color.dark_green)
            .cornerRadius(30.0)
        }
    }
}
