//
//  GalleryApp.swift
//  Gallery
//
//  Created by ANDREY STEPANOV on 15.12.23.
//

import SwiftUI

@main
struct GalleryApp: App {
    var itemsClient: ItemsClient = ItemsClient()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(itemsClient)
        }
    }
}
