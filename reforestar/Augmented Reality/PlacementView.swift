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
        Spacer()
        HStack(alignment: .bottom){
            Spacer()
            PlacementButton(systemIconName: "xmark.circle.fill", action: {
                print("Cancel")
                self.placementSettings.selectedModel = nil
            })
            Spacer()
            PlacementButton(systemIconName: "checkmark.circle.fill", action: {
                print("Confirm")
                self.placementSettings.confirmedModel = self.placementSettings.selectedModel
                self.placementSettings.selectedModel = nil
            })
            Spacer()
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
