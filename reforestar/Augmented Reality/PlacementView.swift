//
//  PlacementView.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 01/06/2021.
//

import SwiftUI

struct PlacementView: View{
    @EnvironmentObject var placementSettings: PlacementSettings
    var body: some View{
        VStack(alignment: .center){
            Spacer()
            Spacer()
            Circle().background(Color.blue).frame(width: 50, height: 50)
            Spacer()
            HStack(alignment: .center){
                PlacementButton(systemIconName: "xmark.circle.fill", action: {
                    print("Cancel")
                    self.placementSettings.selectedModel = nil
                })
                PlacementButton(systemIconName: "checkmark.circle.fill", action: {
                    print("Confirm")
                    self.placementSettings.confirmedModel = self.placementSettings.selectedModel
                    self.placementSettings.selectedModel = nil
                })
            }
        }
    }
}

struct PlacementButton: View {
    let systemIconName: String
    let action:() -> Void
    
    var body: some View{
        
        Button(action: {
            self.action()
        }){
            Image(systemName: systemIconName)
                .font(.system(size: 50,weight: .light,design: .default))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 75, height: 75)
    }
}
