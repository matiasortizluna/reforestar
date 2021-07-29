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
    @State private var height = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(40.0) : CGFloat(50.0)
    @State private var width = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(125.0) : CGFloat(175.0)
    
    @State private var height_button = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(57.0) : CGFloat(72.0)
    @State private var width_button = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(57.0) : CGFloat(72.0)
    
    @EnvironmentObject var selectedModelManager : SelectedModel
    @EnvironmentObject var userFeedbackManager : UserFeedback
    
    @State private var showTabBar : Bool = false
    @State private var showTreeCatalog : Bool = false
    
    var body: some View{
        
        VStack(alignment: .center){
            
            HStack(alignment: .top){
                Spacer()
                NumberOfTreesOnSceneLabel(background_color: .dark_green, height: self.$height, width: self.$width)
                //CurrentCoordinatesLabel(background_color: .dark_green, height: self.$height, width: self.$width)
                Spacer()
                
            }
            
            Spacer()
            
            HStack(){
                Spacer()
                Text(self.userFeedbackManager.message)
                Spacer()
                
                if(showTabBar){
                    RightBar(height: self.$height_button, width: self.$width_button, showTreeCatalog: self.$showTreeCatalog)
                    
                }
            }
            
            Spacer()
            
            HStack(){
                UndoButton(height_button: self.$height_button, width_button: self.$width_button)
                Spacer()
                SelectedModelButtonLabel(background_color: .dark_green, height: self.$height, width: self.$width, showTreeCatalog: self.$showTreeCatalog)
                Spacer()
                ShowBarButton(optionToToggle: $showTabBar, height_button: self.$height_button, width_button: self.$width_button, action: {
                    self.showTabBar.toggle()
                    self.userFeedbackManager.message="ShowBarButton pressed"
                }, icon_string1: "gearshape", icon_string2: "book")
                
            }
            
        }
        
    }
}


struct RightBar : View {
    
    @Binding var height : CGFloat
    @Binding var width : CGFloat
    
    @Binding var showTreeCatalog : Bool
    @State private var showOptionsMenu : Bool = false
    
    @EnvironmentObject var userFeedbackManager : UserFeedback
    @EnvironmentObject var selectedModelManager : SelectedModel
    
    var body: some View{
        
        VStack{
            
            Spacer()
            //
            if(self.selectedModelManager.selectedModelName=="quercus_suber"){
                PickerSelect(width: self.$width, height: $height)
            }else{
                Text("").hidden()
            }

            Spacer()
            //Height Slider
            HeightSlider(width_screen: self.$width, height_screen: self.$height)
            Spacer()
            OptionsButton(height_button: self.$height, width_button: self.$width, showOptionsMenu: $showOptionsMenu, action: {
                self.userFeedbackManager.message="OptionsButton pressed"
                self.showOptionsMenu.toggle()
            }).popover(isPresented: $showOptionsMenu, arrowEdge: .trailing, content: {
                OptionsMenu(showOptionsMenu: $showOptionsMenu, height_button: self.$height, width_button: self.$width)
            })
            
            
        }
        .frame(minWidth: self.width, maxWidth: self.width, minHeight: 150, maxHeight: .infinity, alignment: .center)
        .background(Color.dark_green)
        .cornerRadius(20.0)
        .padding(.trailing, 15.0)
    }
}

struct NumberOfTreesOnSceneLabel : View {
    
    let background_color: Color
    
    @Binding var height : CGFloat
    @Binding var width : CGFloat

    @EnvironmentObject var selectedModelManager : SelectedModel
    
    var body: some View{
        
        VStack(alignment: .center){
            HStack(alignment: .center){
                Text("Nº of Trees on Current Scene")
                    .font(.system(size: self.height*0.3))
                    .foregroundColor(.light_beish)
            }
            HStack(alignment: .center){
                Text(String(selectedModelManager.scene_anchors))
                    .font(.system(size: self.height*0.35))
                    .bold()
                    .foregroundColor(.light_green)
            }
        }
        .frame(width: self.width*1.4, height: self.height, alignment: .center)
        .background(self.background_color)
        .cornerRadius(15.0)
        //.padding(.top, 30.0)
        
        /*
         HStack(alignment: .center){
         VStack(alignment: .leading){
         Text("Nº of Trees on \nCurrent Scene")
         .font(.system(size: self.height*0.3))
         .foregroundColor(.light_beish)
         }
         VStack(alignment: .trailing){
         Text("10")
         .font(.system(size: self.height*0.35))
         .bold()
         .foregroundColor(.light_green)
         }
         }
         .frame(width: self.width, height: self.height, alignment: .center)
         .background(self.background_color)
         .cornerRadius(15.0)
         //.padding(.top, 30.0)
         */
        
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
        //.padding(.top, 30.0)
    }
    
}

struct SelectedModelButtonLabel : View {
    
    let background_color: Color
    
    @Binding var height : CGFloat
    @Binding var width : CGFloat
    
    @EnvironmentObject var selectedModelManager : SelectedModel
    
    @Binding var showTreeCatalog : Bool
    
    var body: some View{
        
        VStack(alignment: .center){
            Button( action: {
                self.showTreeCatalog.toggle()
            }, label: {
                VStack(alignment: .center){
                    HStack{
                        Text("Selected Model")
                            .font(.system(size: self.height*0.3))
                            .foregroundColor(.light_beish)
                    }
                    HStack{
                        Text(self.selectedModelManager.selectedModelName)
                            .font(.system(size: self.height*0.35))
                            .bold()
                            .foregroundColor(.light_green)
                    }
                }
            })
            .frame(width: self.width, height: self.height, alignment: .center)
            .background(self.background_color)
            .cornerRadius(15.0)
            .padding(.bottom, 30.0)
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
    
    var body: some View {
        
        ZStack{
            DefaultButton(icon: "book", icon_color: .light_beish, action: {
                print("Undo Button pressed")
                NotificationCenter.default.post(name: self.notification_name, object: nil)
                
            }, height_button: self.$height_button, width_button: self.$width_button)
        }
        .frame(width: self.width_button, height: self.height_button, alignment: .center)
        .background(Color.dark_green)
        .cornerRadius(20.0)
        .padding(.bottom, 20.0)
        
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
    
    var body: some View{
        HStack{
            ZStack{
                DefaultButton(icon: optionToToggle ? icon_string1 : icon_string2, icon_color: .light_beish, action: {
                    self.action()
                }, height_button: self.$height_button, width_button: self.$width_button)
                
            }
            .frame(width: self.width_button, height: self.height_button, alignment: .center)
            .background(Color.dark_green)
            .cornerRadius(20.0)
            .padding(.trailing, 15.0)
            .padding(.top, 5.0)
            .padding(.bottom, 20.0)
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
                DefaultButton(icon: "gearshape", icon_color: .light_beish, action: {
                    self.action()
                }, height_button: self.$height_button, width_button: self.$width_button)
            }
            .frame(width: self.width_button, height: self.height_button, alignment: .center)
            .background(Color.dark_green)
            .cornerRadius(20.0)
            .padding(.trailing, 15.0)
            .padding(.top, 20.0)
            .padding(.bottom, 5.0)
        }
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
                        Text("Delete all Trees")
                            .foregroundColor(Color.white)
                            .font(.system(size: self.width_button/4))
                            
                    }
                    .frame(width: self.width_button*2.0, height: self.height_button*0.60, alignment: .center)
                    .background(Color.red)
                    .cornerRadius(15.0)
                    .padding(5.0)
                }
                .padding(10.0)
                
                Divider()
                
                HStack{
                    VStack{
                        Text("Selected Project")
                            .foregroundColor(Color.dark_green)
                            .font(.system(size: self.width_button/4))
                            .bold()
                        
                        Picker("Projects", selection: $selectedProject){
                            ForEach(self.currentSceneManager.getAllProjects(),id:\.self){
                                
                                Text("\($0)")
                                    .foregroundColor(Color.dark_green)
                                    .font(.system(size: self.width_button/4))
                                    .bold()
                            
                            }.onChange(of: selectedProject) { _ in
                                self.currentSceneManager.setSelectedProject(project: selectedProject)
                            }
                        }
                        .frame(width: self.width_button*3.0, height:  self.height_button*2.0, alignment: .center)
                        .clipped()
                        .padding(5.0)
                    }
                    
                }
                .padding(10.0)
                
                HStack{
                    
                    VStack{
                        Button(action: {
                            print("Save Button Pressed")
                            NotificationCenter.default.post(name: self.notification_save_progress, object: nil)
                        }){
                            Text("Save")
                                .foregroundColor(Color.white)
                                .font(.system(size: self.width_button/4))
                                .bold()
                        }
                        .frame(width: self.width_button, height: self.height_button*0.60, alignment: .center)
                        .background(Color.light_green)
                        .cornerRadius(15.0)
                        .padding(5.0)
                    }
                    
                    VStack{
                        Button(action: {
                            print("Load Button Pressed")
                            NotificationCenter.default.post(name: self.notification_load_progress, object: nil)
                        }){
                            Text("Load")
                                .foregroundColor(Color.white)
                                .font(.system(size: self.width_button/4))
                                .bold()
                        }
                        .frame(width: self.width_button, height: self.height_button*0.60, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                        .padding(5.0)
                    }
                    
                }
                .padding(10.0)
                
                
                
            }.padding(5.0)
        }
        
    }
}

struct PickerSelect: View{
    
    @Binding var width : CGFloat
    @Binding var height : CGFloat
    
    @State private var numberOfTrees : Int = CurrentScene.sharedInstance.getNumberOfTrees()
    var currentSceneManager = CurrentScene.sharedInstance
    
    var body: some View{
        HStack{
            Text("Trees")
                .foregroundColor(Color.light_beish)
                .font(.system(size: self.width/4))
                .bold()
        }
        HStack{
            //Number of trees picker
            Picker("Trees", selection: $numberOfTrees){
                ForEach(1...20,id:\.self){
                    Text("\($0)")
                    
                }.onChange(of: numberOfTrees) { _ in
                    self.currentSceneManager.setNumberOfTrees(number: numberOfTrees)
                }
            }
            .frame(width: self.width-10.0, height:  self.height == 57.0 ? 100.0 : 200.0, alignment: .center)
            .clipped()
        }
    }
}


//Tree's Height Slider
struct HeightSlider: View{
    
    @Binding var width_screen : CGFloat
    @Binding var height_screen : CGFloat
    
    @State private var current_scale : Double = CurrentScene.sharedInstance.getScaleCompensation()
    var min_scale : Double = 0.01
    var max_scale : Double = 5.01
    
    var currentSceneManager = CurrentScene.sharedInstance
    
    var body: some View{
        HStack{
            Text("Scale")
                .foregroundColor(Color.light_beish)
                .font(.system(size: self.width_screen/4))
                .bold()
        }
        
        HStack{
            Text(String(format: "%0.2f",self.current_scale))
                .foregroundColor(Color.light_green)
                .font(.system(size: self.width_screen/4))
                .bold()
        }
        
        HStack{
            Slider(value: $current_scale, in: min_scale...max_scale,step: 0.10)
                .accentColor(Color.light_beish)
                .rotationEffect(Angle(degrees: -90.0))
                .frame(width: self.height_screen == 57.0 ? 100.0 : 200.0, height: self.width_screen-10.0, alignment: .center)
                .onChange(of: current_scale, perform: { _ in
                    print("Scale Changed: \(self.currentSceneManager.getScaleCompensation())")
                    self.currentSceneManager.setScaleCompensation(number: current_scale)
                })
        }
        .frame(width: self.width_screen-10.0, height: self.height_screen == 57.0 ? 100.0 : 200.0, alignment: .center)
        
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

