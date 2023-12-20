//
//  ContentView.swift
//  Gallery
//
//  Created by ANDREY STEPANOV on 15.12.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var itemsClient:ItemsClient
    
    var body: some View {
        ScrollView{
            Text("Items")
                .font(.title)
                .bold()
            
            VStack(alignment: .leading) {
                ForEach(itemsClient.items) {item in
                    Text("\(item.id) \(item.name)")
                }
            }
            
        }
        .padding(.vertical)
        .onAppear {
            Task{
                await itemsClient.syncItems()
            }
            itemsClient.loadItems()
        }
        Button("REFRESH") {
            itemsClient.loadItems()
        }.padding()
        
        Button("SYNC") {
            Task{
                await itemsClient.syncItems()
            }
        }.padding()
        
        Browser().environmentObject(itemsClient)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ItemsClient())
    }
}
