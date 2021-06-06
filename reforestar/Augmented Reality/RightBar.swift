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
    
    var body: some View{
        
        VStack{
            //Options Button
            OptionsButton()
            Spacer()
            Spacer()
            //Height Slider
            HeightSlider(heightValue: $heightValue, minimumValue: $minimumValue, maximumValue: $maximumValue)
            Spacer()
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
            Spacer()
            ZStack{
                Color.black.opacity(0.25)
                DefaultButton(icon: "gearshape", action: {
                    print("Tapped on Options Button")
                })
            }
            .frame(width: 50, height: 50, alignment: .center)
            .cornerRadius(10.0)
            .padding(15)
            Spacer()
        }
    }
}

//Tree's Height Slider
struct HeightSlider: View{
   @Binding var heightValue : Double
    @Binding var minimumValue : Double
    @Binding var maximumValue : Double
    
    var body: some View{
        HStack{
            ZStack{
                Text(String(heightValue))
                Slider(value: $heightValue, in: minimumValue...maximumValue,step: 1)
                    .padding()
                    .accentColor(Color.green)
                    .rotationEffect(Angle(degrees: -90.0))
            }
            .frame(minWidth: 200, idealWidth: 300, maxWidth: 300, minHeight: 20, idealHeight: 20, maxHeight: 20, alignment: .center)
            .padding(15)
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
            .frame(width: 50, height: 50, alignment: .center)
            .cornerRadius(10.0)
            .padding(15)
        }
        
    }
}
