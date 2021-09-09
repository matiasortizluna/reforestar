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
    
    private let gridItemLayout = [GridItem(.fixed(100))]
    public var currentSceneManager = CurrentSession.sharedInstance
    
    var body: some View {
        
        ZStack{
            Color.light_beish.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 5.0){
                
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow))
                    .frame(width: Help.width_screen*4.0, height: Help.height_screen*11.0, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.dark_green, lineWidth: 7)
                    )
                    .cornerRadius(25.0)
                    .padding(.top,15.0)

                VStack(alignment: .leading){
                    
                    Text("Projects")
                        .font(.system(size: Help.width_button*0.3))
                        .foregroundColor(.dark_green)
                        .bold()
                        .padding(0.5)
                        .padding(.leading,30.0)
                        .padding(.top, 10.0)
                        .frame(alignment: .leading)
                    
                    ScrollView(.horizontal, showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, content: {
                        HStack(alignment: .center){
                            LazyHGrid(rows: gridItemLayout, alignment: .center, spacing: 20, content: {
                                ProjectAreaButton(project_name: "All", project_color: Color.black, action: {
                                    print("All")
                                })
                                ForEach(currentSceneManager.getProjectsNames(), id: \.self) { project in
                                    ProjectAreaButton(project_name: project, project_color: Color.blue, action: {
                                        print(project)
                                    })
                                }
                            })
                            .padding(.horizontal,30.0)
                        }
                    })
                }
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
            VStack(alignment: .center) {

                RoundedRectangle(cornerRadius: 20.0)
                    .frame(width: Help.width_button*1.2, height: Help.height_button*1.2, alignment: .center)
                    .foregroundColor(project_color)
                    .padding(1.0)
                
                Text(self.project_name).font(.system(size: Help.width_button*0.2))
                    .foregroundColor(Color.light_beish)
                    .bold()
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .padding(1.0)

            }
            .frame(width: Help.width_button*3.0, height: Help.height_button*2.0, alignment: .center)
            .background(Color.dark_green.opacity(0.85))
            .cornerRadius(25.0)
        }
    }
}
