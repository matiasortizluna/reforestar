//
//  ProjectsDetailContentView.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 12/08/2021.
//

import Foundation
import SwiftUI

struct ProjectsDetailContentView : View {
    
    let stringlatin : String
    
    var body: some View{
        ZStack{
            Color.light_beish.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 20.0){
                
                Spacer()
                
                VStack(alignment: .leading){
                    Text("Description")
                        .font(.system(size: Help.width_button*0.4))
                        .foregroundColor(.dark_green)
                        .bold()
                        .shadow(radius: 5)
                    Text("At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusan.")
                        .font(.system(size: Help.width_button*0.4))
                        .foregroundColor(.dark_green)
                        .lineLimit(6)
                        .minimumScaleFactor(0.8)
                        .padding()
                        .multilineTextAlignment(.leading)
                        .shadow(radius: 5)
                }
                
                
                VStack{
                    HStack(alignment: .center, spacing: 10.0){
                        Spacer()
                        Text("Status")
                            .font(.system(size: Help.width_button*0.3))
                            .foregroundColor(.light_beish)
                            .bold()
                            .padding(0.5)
                        Spacer()
                        Text("Planning")
                            .font(.system(size: Help.width_button*0.3))
                            .foregroundColor(.light_green)
                            .padding(0.5)
                        Spacer()
                    }
                    .padding(7.5)
                    
                    Divider().background(Color.light_beish).padding(.horizontal,10.0)
                    
                    HStack(alignment: .center, spacing: 10.0){
                        Spacer()
                        Text("Trees")
                            .font(.system(size: Help.width_button*0.3))
                            .foregroundColor(.light_beish)
                            .padding(0.5)
                        Spacer()
                        Text("3")
                            .font(.system(size: Help.width_button*0.3))
                            .foregroundColor(.light_green)
                            .padding(0.5)
                        Spacer()
                    }
                    .padding(7.5)
                    
                    Divider().background(Color.light_beish).padding(.horizontal,10.0)
                    
                    HStack(alignment: .center, spacing: 10.0){
                        Spacer()
                        Text("Areas")
                            .font(.system(size: Help.width_button*0.3))
                            .foregroundColor(.light_beish)
                            .bold()
                            .padding(0.5)
                        Spacer()
                        Text("3")
                            .font(.system(size: Help.width_button*0.3))
                            .foregroundColor(.light_green)
                            .bold()
                            .padding(0.5)
                        Spacer()
                    }
                    .padding(7.5)
                    
                }
                .background(Color.dark_green)
                .cornerRadius(15.0)
                .shadow(radius: 5)
                .frame(width: Help.height_screen*6.0, height: Help.height_button*5.0, alignment: .center)
                
                Spacer()
                
                VStack(alignment: .center){
                    Button(action: {
                        print("dasdsada")
                    }){
                        HStack{
                            Image(systemName: "cursorarrow.rays")
                                .font(.system(size: Help.width_button*0.4))
                                .foregroundColor(.light_beish)
                                .padding(0.5)
                            Text("Select")
                                .font(.system(size: Help.width_button*0.3))
                                .foregroundColor(.light_beish)
                                .bold()
                                .padding(0.5)
                        }
                        .padding(5.0)
                    }
                    .padding(3.0)
                    .buttonStyle(PlainButtonStyle())
                    .background(Color.dark_green.opacity(95.0))
                    .cornerRadius(15.0)
                    .shadow(radius: 5)
                    .frame(width: Help.width_button*8.0, height: Help.height_button*0.80, alignment: .center)
                }
                
                Spacer()
                
            }
            .padding(.horizontal,20.0)
        }
    }
}
