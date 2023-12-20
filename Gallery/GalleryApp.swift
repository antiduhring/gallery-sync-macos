//
//  GalleryApp.swift
//  Gallery
//
//  Created by ANDREY STEPANOV on 15.12.23.
//

import SwiftUI

@main
struct GalleryApp: App {
    let filesProvider = FilesProvider()
    let itemsClient = ItemsClient()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(filesProvider)
                .environmentObject(itemsClient);
        }
    }
}
