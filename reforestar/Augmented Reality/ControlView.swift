//
//  ControlView.swift
//  ARSwiftUI
//
//  Created by Matias Ariel Ortiz Luna on 19/04/2021.
//

import SwiftUI

struct ControlView: View {
    @Binding var heightValue : Double
     @Binding var minimumValue : Double
     @Binding var maximumValue : Double
    
    @State var isControlVisible : Bool = true
    
    var body: some View{
        
        VStack{
                
            ReforestManu(heightValue: $heightValue, minimumValue: $minimumValue, maximumValue: $maximumValue, isControlVisible: $isControlVisible)
            
        }
        
    }

}

struct ShowControlView: View{
    @Binding var isControlVisible: Bool
    
    var body: some View{
        Spacer()
            HStack{
                Spacer()
                
                ZStack{
                    Color.black.opacity(0.25)
                    
                    Button(action:{
                        print("Control Visibility Toogle Button")
                        self.isControlVisible.toggle()
                    }){
                        Image(systemName: isControlVisible ? "chevron.left" : "rectangle")
                            .font(.system(size: 30))
                            .foregroundColor(.yellow)
                            .buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(width: 50, height: 50,alignment: .bottomTrailing)
                .cornerRadius(8.0)
            }
            .padding(20)
            .frame(width: 100, height: 100, alignment: .bottomTrailing)
        
    }
}

struct ReforestManu: View {
    @Binding var heightValue : Double
     @Binding var minimumValue : Double
     @Binding var maximumValue : Double
    @Binding var isControlVisible : Bool
    
    var body: some View{
       
    if(isControlVisible){
        VStack{
         
                OptionsControlButton()
                 
                Spacer()
                Spacer()
                    
                SizeControlSlider(heightValue: $heightValue, minimumValue: $minimumValue, maximumValue: $maximumValue)
                    
                Spacer()
                    
                TreesCatalogMenu()
                
        }
        .frame(minWidth: 60, idealWidth: 75, maxWidth: 75, minHeight: 300, idealHeight: 500, maxHeight: 700, alignment: .center)
        .background(Color.black.opacity(0.5))
        .cornerRadius(20.0)
        .padding(5.0)
    }
        ShowControlView(isControlVisible: $isControlVisible)
    
    }
}

struct OptionsControlButton: View {
    var body: some View{
        HStack{
            Spacer()
            
            ZStack{
                Color.black.opacity(0.25)
                
                Button(action: {
                    print("Tapped on Options Button")
                }){
                    Image(systemName: "gearshape")
                        .font(.system(size: 30))
                        .foregroundColor(Color.green)
                        .buttonStyle(PlainButtonStyle())
                        
                }
            }
            .frame(width: 50, height: 50, alignment: .center)
            .cornerRadius(10.0)
            .padding(15)
            
            Spacer()
            
        }
        
    }
}

struct SizeControlSlider: View{
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
                /*
                    .overlay(
                        RoundedRectangle(cornerRadius: 15.0)
                            .stroke(lineWidth: 2.0)
                            .foregroundColor(Color.green)
                    )*/
                    
            }
            .frame(minWidth: 200, idealWidth: 300, maxWidth: 300, minHeight: 20, idealHeight: 20, maxHeight: 20, alignment: .center)
            .padding(15)
        }
        
    }
    
}

struct TreesCatalogMenu: View{
    var body: some View{
        HStack{
            
            ZStack{
                Color.black.opacity(0.25)
                
                Button(action: {
                    print("Tapped on Trees Catalog Button")
                }){
                    Image(systemName: "book")
                        .font(.system(size: 30))
                        .foregroundColor(Color.green)
                        .buttonStyle(PlainButtonStyle())
                        
                }
            }
            .frame(width: 50, height: 50, alignment: .center)
            .cornerRadius(10.0)
            .padding(15)
        }
        
    }
}
