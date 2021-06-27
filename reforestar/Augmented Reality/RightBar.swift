//
//  RightBar.swift
//  ARSwiftUI
//
//  Created by Matias Ariel Ortiz Luna on 31/05/2021.
//

import SwiftUI

struct RightBar: View {
    //Variables of Height Tree Slider
    @Binding var heightValue : Double
    @Binding var minimumValue : Double
    @Binding var maximumValue : Double
    
    //Variables of State for different Menus
    @State var showTreeCatalog : Bool = false
    
    @State var numberOfTrees : Int = 1
    
    var body: some View{
        VStack{
            //Options Button
            OptionsButton()
            
            //
            PickerSelect(numberOfTrees: $numberOfTrees)
            
            //Height Slider
            HeightSlider(heightValue: $heightValue, minimumValue: $minimumValue, maximumValue: $maximumValue)
            
            //Tree's Catalog Menu
            
            TreesCatalogMenu(showTreeCatalog: $showTreeCatalog).sheet(isPresented: $showTreeCatalog, content: {
                //Browse View
                TreesCatalog(showTreeCatalog: $showTreeCatalog)
            })
            
            
        }
        .frame(minWidth: 60, idealWidth: 75, maxWidth: 75, minHeight: 300, idealHeight: 500, maxHeight: 700, alignment: .center)
        .background(Color.black.opacity(0.5))
        .cornerRadius(20.0)
        .padding(5.0)
        
    }
}

//Options Button
struct OptionsButton: View {
    var body: some View{
        HStack{
            ZStack{
                Color.black.opacity(0.25)
                DefaultButton(icon: "gearshape", action: {
                    print("Tapped on Options Button")
                })
            }
            .cornerRadius(10.0)
        }
        .frame(width: 50, height: 50)
    }
}

struct PickerSelect: View{
    @Binding var numberOfTrees : Int
    var body: some View{
        HStack{
            Text("Trees").bold().foregroundColor(Color.white)
        }
        HStack{
            //Number of trees picker
            Picker("Trees", selection: $numberOfTrees){
                ForEach(1...10,id:\.self){
                    Text("\($0)")
                }
            }
            .frame(minWidth: 40, idealWidth: 40, maxWidth: 40, minHeight: 75, idealHeight: 75, maxHeight: 75)
        }
        .frame(width: 50, height: 100)
    }
}

//Tree's Height Slider
struct HeightSlider: View{
    @Binding var heightValue : Double
    @Binding var minimumValue : Double
    @Binding var maximumValue : Double
    
    var body: some View{
        HStack{
            Text("Height")
        }
        HStack{
            ZStack{
                Color.black.opacity(0.25)
                Slider(value: $heightValue, in: minimumValue...maximumValue,step: 1)
                    .accentColor(Color.green)
                    .rotationEffect(Angle(degrees: -90.0))
                    .frame(width: 120, height: 50)
            }
            .frame(minWidth: 50, idealWidth: 50, maxWidth: 50, minHeight: 150, idealHeight: 150, maxHeight: 150, alignment: .center)
            .cornerRadius(10.0)
        }
        
    }
}

//Tree's Catalog Button
struct TreesCatalogMenu: View{
    @Binding var showTreeCatalog : Bool
    var body: some View{
        HStack{
            ZStack{
                Color.black.opacity(0.25)
                DefaultButton(icon: "book", action: {
                    print("Tapped on Trees Catalog Button")
                    showTreeCatalog.toggle()
                })
            }
            .cornerRadius(10.0)
        }
        .frame(width: 50, height: 50)
        
    }
}
