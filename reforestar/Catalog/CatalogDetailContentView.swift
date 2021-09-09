//
//  ProjectsDetailContentView.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 12/08/2021.
//

import Foundation
import SwiftUI

struct CatalogDetailContentView : View {
    
    let catalog_latin_name : String
    let catalog_common_name: String
    let catalog_space_betwen: Int
    let catalog_min_height: Int
    let catalog_max_height: Int
    let catalog_description_tree: String
    let catalog_has3dmodel: Bool
    
    var body: some View{
        ZStack{
            Color.light_beish.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 15.0){
                
                VStack(alignment: .center,spacing: 10.0){
                    Text(catalog_common_name)
                        .font(.system(size: Help.width_button*0.4))
                        .foregroundColor(.dark_green)
                        .bold()
                    Image(catalog_latin_name)
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 5)
                        .cornerRadius(40.0)
                        .frame(width: Help.width_button*10.0, height: Help.width_button*5.0, alignment: .center)
                }
                
                Spacer()
                
                HStack{
                    VStack{
                        Image(systemName: "arrow.left.and.right")
                            .font(.system(size: Help.width_button*0.4))
                            .foregroundColor(.light_beish)
                            .padding(3.2)
                        Text("Space Between")
                            .font(.system(size: Help.width_button*0.3))
                            .foregroundColor(.light_beish)
                            .bold()
                            .padding(0.5)
                            .multilineTextAlignment(.center)
                        Divider()
                            .background(Color.light_beish)
                        Text("\(self.catalog_space_betwen) m")
                            .font(.system(size: Help.width_button*0.35))
                            .foregroundColor(.light_green)
                            .bold()
                            .padding(0.5)
                            .multilineTextAlignment(.center)
                    }
                    .padding(7.5)
                    VStack{
                        Image(systemName: "arrow.down.to.line")
                            .font(.system(size: Help.width_button*0.4))
                            .foregroundColor(.light_beish)
                        Text("Min Height")
                            .font(.system(size: Help.width_button*0.3))
                            .foregroundColor(.light_beish)
                            .bold()
                            .padding(0.5)
                            .multilineTextAlignment(.center)
                        Divider()
                            .background(Color.light_beish)
                        Text("\(self.catalog_min_height) m")
                            .font(.system(size: Help.width_button*0.35))
                            .foregroundColor(.light_green)
                            .bold()
                            .padding(0.5)
                    }
                    .padding(7.5)
                    VStack{
                        Image(systemName: "arrow.up.to.line")
                            .font(.system(size: Help.width_button*0.4))
                            .foregroundColor(.light_beish)
                        Text("Max Height")
                            .font(.system(size: Help.width_button*0.3))
                            .foregroundColor(.light_beish)
                            .bold()
                            .padding(0.5)
                            .multilineTextAlignment(.center)
                        Divider()
                            .background(Color.light_beish)
                        Text("\(self.catalog_max_height) m")
                            .font(.system(size: Help.width_button*0.35))
                            .foregroundColor(.light_green)
                            .bold()
                            .padding(0.5)
                    }
                    .padding(7.5)
                }
                .background(Color.dark_green)
                .cornerRadius(15.0)
                .shadow(radius: 5)
                .frame(width: Help.height_screen*12.0, height: Help.height_button*2.0, alignment: .center)
                
                HStack{
                    Text(self.catalog_description_tree.isEmpty ? "No available Description" : self.catalog_description_tree)
                        .font(.system(size: Help.width_button*0.4))
                        .foregroundColor(.dark_green)
                        .lineLimit(5)
                        .minimumScaleFactor(0.8)
                        .padding()
                        .multilineTextAlignment(.leading)
                        .shadow(radius: 5)
                }
                
                Spacer()
                
                if(self.catalog_has3dmodel){
                    VStack(alignment: .center){
                        Button(action: {
                            print("Selected Model")
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
                }
                
                Spacer()
                
            }
            .padding(.horizontal,20.0)
        }
    }
}

