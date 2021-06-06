//
//  ControlView.swift
//  ARSwiftUI
//
//  Created by Matias Ariel Ortiz Luna on 19/04/2021.
//

import SwiftUI

struct InterfaceLayout: View {
    //Variables of Height Tree Slider
    @Binding var heightValue : Double
    @Binding var minimumValue : Double
    @Binding var maximumValue : Double
    
    //Variables of State for different Menus
    @State private var showTabBar : Bool = false
    
    var body: some View{
        VStack{
            if(showTabBar){

                RightBar(heightValue: $heightValue, minimumValue: $minimumValue, maximumValue: $maximumValue)

            }
            
            ShowBarButton(optionToToggle: $showTabBar, action: {
                print("Control Visibility Toogle Button")
                self.showTabBar.toggle()
            }, icon_string1: "gearshape", icon_string2: "book")
        
        }
    }
}

//Show Right Bar Button
struct ShowBarButton: View{
    @Binding var optionToToggle : Bool
    
    let action: ()->Void
    let icon_string1: String
    let icon_string2: String
    
    var body: some View{
        Spacer()
        HStack{
            ZStack{
                Color.black.opacity(0.25)
                
                DefaultButton(icon: optionToToggle ? icon_string1 : icon_string2, action: {
                    self.action()
                })
                
            }
            .frame(width: 50, height: 50,alignment: .bottomTrailing)
            .cornerRadius(8.0)
        }
        .padding(20)
        .frame(minWidth: 60, idealWidth: 75, maxWidth: 75, minHeight: 60, idealHeight: 75, maxHeight: 75, alignment: .center)
        .background(Color.black.opacity(0.5))
        .cornerRadius(20.0)
        .padding(5.0)
        
    }
}


//Default Button
struct DefaultButton: View {
    let icon: String
    let action: ()->Void
        
    var body: some View{
        Button(action: {
            self.action()
        }){
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(Color.green)
                .buttonStyle(PlainButtonStyle())
                
        }
        .frame(width: 50, height: 50)
    }
}


