//
//  AreasContentView.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 30/08/2021.
//

import Foundation
import SwiftUI
import MapKit

struct AreasContentView : View{
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    private let gridItemLayout = [GridItem(.fixed(150))]
    
    public var currentSceneManager = CurrentSession.sharedInstance
    
    var body: some View {
        
        ZStack{
            Color.light_beish.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 5.0){
                
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow))
                    .frame(width: Help.width_screen*4.0, height: Help.height_screen*10.0, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.dark_green, lineWidth: 7)
                    )
                    .cornerRadius(25.0)
                    .padding(.top,15.0)
                
                Spacer()
                
                VStack(alignment: .leading){
                    Text("Projects")
                        .font(.system(size: Help.width_button*0.3))
                        .foregroundColor(.dark_green)
                        .bold()
                        .padding(0.5)
                        .frame(alignment: .leading)
                    HStack{
                        
                        ScrollView(.horizontal, showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, content: {
                            
                            HStack(alignment: .center){
                                LazyHGrid(rows: gridItemLayout, alignment: .center, spacing: 30, content: {
                                    
                                    ForEach(currentSceneManager.getAllProjects(), id: \.self) { project in
                                        
                                        ProjectAreaButton(project_name: project, project_color: Color.dark_green, action: {
                                            print(project)
                                        })
                                        
                                    }
                                    
                                })
                                .padding(.horizontal,22)
                                .padding(.vertical,10)
                            }
                            
                            
                        })
                        
                    }
                    
                }
                
                Spacer()
                
            }
        }
    }
    
}

struct ProjectAreaButton: View {
    var project_name:String
    var project_color:Color
    let action: () -> Void
    
    var body: some View{
        Button(action: {
            self.action()
        }){
            VStack(alignment: .center, spacing: 3.0) {
                
                Image(systemName: "gift")
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .leading)

                Text(self.project_name).font(.title3)
                
            }
            .cornerRadius(8.0)
            .frame(minWidth: 310, idealWidth: 400, maxWidth: .infinity, minHeight: 150, idealHeight: 150, maxHeight: .infinity)
            .background(Color(UIColor.secondarySystemFill))
        }
    }
}
