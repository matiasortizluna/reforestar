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
    @State private var height_screen = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(40.0) : CGFloat(50.0)
    @State private var width_screen = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(125.0) : CGFloat(175.0)
    
    @State private var height_button = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(60.0) : CGFloat(72.0)
    @State private var width_button = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(57.0) : CGFloat(72.0)
    
    @EnvironmentObject var selectedModelManager : SelectedModel
    @EnvironmentObject var userFeedbackManager : UserFeedback
    
    @State private var showTabBar : Bool = false
    @State private var showTreeCatalog : Bool = false
    
    var body: some View{
        
        VStack(alignment: .center){
            
            HStack(alignment: .top){
                
                NumberOfTreesOnSceneLabel(background_color: .dark_green, height_button: self.$height_button, width_button: self.$width_button)
                Spacer()
                //CurrentCoordinatesLabel(background_color: .dark_green, height: self.$height, width: self.$width)
                Spacer()
                
            }
            
            Spacer()
            
            HStack(){
                Spacer()
                Text(self.userFeedbackManager.message)
                Spacer()
                
                if(showTabBar){
                    RightBar(height_screen: self.$height_screen, width_screen: self.$width_screen, height_button: self.$height_button, width_button: self.$width_button, showTreeCatalog: self.$showTreeCatalog)
                }
            }
            
            Spacer()
            
            HStack(){
                UndoButton(height_button: self.$height_button, width_button: self.$width_button)
                Spacer()
                SelectedModelButtonLabel(background_color: .dark_green, height_button: self.$height_button, width_button: self.$width_button, showTreeCatalog: self.$showTreeCatalog)
                Spacer()
                ShowBarButton(optionToToggle: $showTabBar, height_button: self.$height_button, width_button: self.$width_button, action: {
                    self.showTabBar.toggle()
                    self.userFeedbackManager.message="ShowBarButton pressed"
                }, icon_string1: "chevron.right.square.fill", icon_string2: "chevron.backward.square", button_title: "Menu")
                
            }
            
        }
        
    }
}

struct NumberOfTreesOnSceneLabel : View {
    
    let background_color: Color
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    @EnvironmentObject var selectedModelManager : SelectedModel
    
    var body: some View{
        
        VStack(alignment: .center){
            HStack(alignment: .center){
                Text("Nº of Trees on \nCurrent Scene")
                    .font(.system(size: self.width_button*0.2))
                    .foregroundColor(.light_beish)
                    .bold()
                Text(String(selectedModelManager.scene_anchors))
                    .font(.system(size: self.width_button*0.3))
                    .bold()
                    .foregroundColor(.light_green)
            }.padding(3.0)
        }
        .frame(width: self.width_button*2.0, height: self.height_button*0.8, alignment: .center)
        .background(self.background_color)
        .cornerRadius(15.0)
        .padding(.top, 15.0)
        .padding(.leading, 15.0)
        
    }
    
}

struct CurrentCoordinatesLabel : View {
    
    let background_color: Color
    
    @Binding var height : CGFloat
    @Binding var width : CGFloat
    
    @ObservedObject public var locationManager  = LocationManager()
    
    var body: some View{
        let coordinate = self.locationManager.coordinates != nil ? self.locationManager.coordinates!.coordinate : CLLocationCoordinate2D()
        
        VStack(alignment: .center){
            HStack(alignment: .center){
                Text("Latitude | Longitude")
                    .font(.system(size: self.height*0.3))
                    .foregroundColor(.light_beish)
            }
            HStack(alignment: .center){
                Text("\(coordinate.latitude) | \(coordinate.longitude)")
                    .font(.system(size: self.height*0.35))
                    .bold()
                    .foregroundColor(.light_green)
            }
        }
        .frame(width: self.width*1.4, height: self.height, alignment: .center)
        .background(self.background_color)
        .cornerRadius(15.0)
    }
}

struct SelectedModelButtonLabel : View {
    
    let background_color: Color
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    @EnvironmentObject var selectedModelManager : SelectedModel
    
    @Binding var showTreeCatalog : Bool
    
    var body: some View{
        
        VStack(alignment: .center){
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
            .padding(.bottom, 13.5)
            .sheet(isPresented: $showTreeCatalog, content: {
                //Browse View
                NavigationView{
                    
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
            })
        }
        
    }
}

struct UndoButton : View {
    
    @Binding var height_button : CGFloat
    @Binding var width_button : CGFloat
    
    var currentSceneManager = CurrentScene.sharedInstance
    
    let notification_name = Notification.Name("last_item_anchor")
    
    @State var optionToToggle : Bool = false
    
    var body: some View {
        
        ZStack{
            DefaultButtonWithText(icon:  optionToToggle ? "arrowshape.turn.up.left.fill" : "arrowshape.turn.up.left" , icon_color: .light_beish, action: {
                print("Undo Button pressed")
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
    }
    
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
        HStack{
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
    
    let notification_name = Notification.Name("delete_all_trees")
    let notification_save_progress = Notification.Name("notification_save_progress")
    let notification_load_progress = Notification.Name("notification_load_progress")
    
    @State private var selectedProject : String = "Default"
    var currentSceneManager = CurrentScene.sharedInstance
    
    var body: some View{
        
        ZStack{
            Color.light_beish
            
            VStack{
                
                HStack{
                    Button(action: {
                        print("Delete all Trees button pressed")
                        NotificationCenter.default.post(name: self.notification_name, object: nil)
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
                            ForEach(self.currentSceneManager.getAllProjects(),id:\.self){
                                
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
                
                
                /*
                 Divider().font(.system(size: 3.0))
                 
                 HStack(alignment: .center){
                 VStack{
                 Text("Current Coordinates")
                 .font(.system(size: self.height_button/4))
                 .bold()
                 .foregroundColor(.dark_green)
                 HStack{
                 VStack{
                 Image(systemName: "mappin.and.ellipse")
                 .font(.system(size: self.width_button/3))
                 .foregroundColor(Color.light_beish)
                 .buttonStyle(PlainButtonStyle())
                 .padding(2.0)
                 }
                 .padding(2.0)
                 VStack(alignment: .center){
                 Text("\(self.currentSceneManager.getLocation().latitude) | \(self.currentSceneManager.getLocation().longitude)")
                 .font(.system(size: self.height_button/4))
                 .bold()
                 .foregroundColor(.light_beish)
                 .padding(2.0)
                 }.padding(2.0)
                 }
                 .background(Color.dark_green)
                 .cornerRadius(15.0)
                 .padding(2.0)
                 }
                 .padding(5.0)
                 .frame(width: self.width_button*3.5, height: self.height_button*0.8, alignment: .center)
                 }
                 .padding(10.0)
                 
                 */
                
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
    
    @EnvironmentObject var userFeedbackManager : UserFeedback
    @EnvironmentObject var selectedModelManager : SelectedModel
    
    var body: some View{
        
        VStack{
            
            Spacer()
            if(self.selectedModelManager.selectedModelName=="quercus_suber"){
                PickerSelect(height_screen: self.$height_screen, width_screen: self.$width_screen, height_button: self.$height_button, width_button: self.$width_button)
            }else{
                Text("").hidden()
            }
            
            HeightSlider(height_screen: self.$height_screen, width_screen: self.$width_screen, height_button: self.$height_button, width_button: self.$width_button)
            
            OptionsButton(height_button: self.$height_button, width_button: self.$width_button, showOptionsMenu: $showOptionsMenu, action: {
                self.userFeedbackManager.message="OptionsButton pressed"
                self.showOptionsMenu.toggle()
            }).popover(isPresented: $showOptionsMenu, arrowEdge: .trailing, content: {
                OptionsMenu(showOptionsMenu: $showOptionsMenu, height_button: self.$height_button, width_button: self.$width_button)
            })
            
            
        }
        .frame(minWidth: self.width_button, maxWidth: self.width_button, minHeight: 150, maxHeight: .infinity, alignment: .center)
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
    
    @State private var numberOfTrees : Int = CurrentScene.sharedInstance.getNumberOfTrees()
    var currentSceneManager = CurrentScene.sharedInstance
    
    var body: some View{
        HStack{
            Text("Trees")
                .foregroundColor(Color.light_beish)
                .font(.system(size: self.width_button*0.25))
                .bold()
        }
        HStack{
            //Number of trees picker
            Picker("Trees", selection: $numberOfTrees){
                ForEach(1...20,id:\.self){
                    
                    Text("\($0)")
                        .foregroundColor(Color.light_beish)
                        .font(.system(size: self.width_button*0.3))
                        .bold()
                }.onChange(of: numberOfTrees) { _ in
                    self.currentSceneManager.setNumberOfTrees(number: numberOfTrees)
                }
            }
            .frame(width: self.width_screen-20.0, height:  self.height_screen == 60.0 ? 100.0 : 200.0, alignment: .center)
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
    
    @State private var current_scale : Double = CurrentScene.sharedInstance.getScaleCompensation()
    var min_scale : Double = 0.01
    var max_scale : Double = 5.01
    
    var currentSceneManager = CurrentScene.sharedInstance
    
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
                .frame(width: self.height_screen == 60.0 ? 100.0 : 200.0, height: self.width_screen-10.0, alignment: .center)
                .onChange(of: current_scale, perform: { _ in
                    print("Scale Changed: \(self.currentSceneManager.getScaleCompensation())")
                    self.currentSceneManager.setScaleCompensation(number: current_scale)
                })
        }
        .frame(width: self.width_screen-10.0, height: self.height_screen == 60.0 ? 100.0 : 200.0, alignment: .center)
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
    private let gridItemLayout = [GridItem(.fixed(150))]
    let treesModels = TreeCatalogModels()
    
    @EnvironmentObject var selectedModelManager : SelectedModel
    var currentSceneManager = CurrentScene.sharedInstance
    
    var body: some View{
        VStack(alignment: .center){
            LazyVGrid(columns: gridItemLayout, alignment: .leading, spacing: 30, content: {
                
                ForEach(self.treesModels.getAll(), id: \.latin_name) { tree in
                    ItemButton(latin_name: tree.latin_name, common_name: tree.common_name, action: {
                        self.selectedModelManager.selectedModelName = tree.latin_name
                        self.currentSceneManager.setSelectedModelName(name: tree.latin_name)
                        self.showTreeCatalog.toggle()
                    })
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
                VStack(alignment: .leading){
                    Image(systemName: "gift")
                        .resizable()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .leading)
                }
                
                VStack(alignment: .center){
                    HStack(alignment: .center, spacing: 1.0, content: {
                        Text(self.latin_name).font(.title3)
                    }).padding()
                    HStack(alignment: .center, spacing: 1.0, content: {
                        Text(self.common_name).font(.title3)
                    }).padding()
                }
            }
            .cornerRadius(8.0)
            .frame(minWidth: 310, idealWidth: 400, maxWidth: .infinity, minHeight: 150, idealHeight: 150, maxHeight: .infinity)
            .background(Color(UIColor.secondarySystemFill))
        }
    }
}

