//
//  TreeCatalog.swift
//  ARSwiftUI
//
//  Created by Matias Ariel Ortiz Luna on 25/05/2021.
//

import SwiftUI
struct TreesCatalog: View {
    @Binding var showTreeCatalog : Bool
    
    var body: some View{
        NavigationView{
            
            ScrollView(.vertical, showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, content: {
                //All Trees
                VerticalGrid(showTreeCatalog: $showTreeCatalog)

            })
            .navigationTitle(Text("Tree's Catalog")).navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: Button(action: {
                self.showTreeCatalog.toggle()
            }, label: {
                Text("Done").bold()
            }))
   
        }
    }
}

struct VerticalGrid: View{
    @EnvironmentObject var placementSettings:PlacementSettings
    
    @Binding var showTreeCatalog : Bool
    private let gridItemLayout = [GridItem(.fixed(150))]
    let treesModels = TreeCatalogModels()
    
    var body: some View{
        VStack(alignment: .center){
            LazyVGrid(columns: gridItemLayout, alignment: .leading, spacing: 30, content: {
                
                ForEach(self.treesModels.getAll(), id: \.latin_name) { tree in
                    ItemButton(latin_name: tree.latin_name, common_name: tree.common_name, action: {
                        tree.asyncLoadModelEntity()
                        self.placementSettings.selectedModel=tree 
                        print("Selected \(tree.latin_name)")
                        self.showTreeCatalog.toggle()
                    })
                }
            })
            .padding(.horizontal,22)
            .padding(.vertical,10)
        }
        
        
    }
}

struct ItemButton: View {
    var latin_name:String
    var common_name:String
    let action: () -> Void
    
    var body: some View{
        Button(action: {
            self.action()
        }){
            HStack {
                VStack(alignment: .leading){
                    Image(systemName: "gift")
                        .resizable()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .leading)
                        //.padding(.vertical,10)
                        //.padding(.horizontal,10)
                }
                
                VStack(alignment: .center){
                    HStack(alignment: .center, spacing: 1.0, content: {
                        Text(self.latin_name).font(.title3)
                    }).padding()
                    HStack(alignment: .center, spacing: 1.0, content: {
                        Text(self.common_name).font(.title3)
                    }).padding()
                }
            }
            .cornerRadius(8.0)
            .frame(minWidth: 310, idealWidth: 400, maxWidth: .infinity, minHeight: 150, idealHeight: 150, maxHeight: .infinity)
            .background(Color(UIColor.secondarySystemFill))
        }
    }
}
