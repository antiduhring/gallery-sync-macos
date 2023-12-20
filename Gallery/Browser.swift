//
//  Browser.swift
//  Gallery
//
//  Created by ANDREY STEPANOV on 16.12.23.
//

import Foundation
import SwiftUI

struct Browser: View {
    let onSelect: (_ fileUrl: [URL]) -> Void
    @State private var fileURL: URL?
    @State var fileName = "no file chosen"
    @State var openFile = false

    var body: some View {
        VStack {
            Text(fileName)

            Button {
                self.openFile.toggle()
            } label: {
                Text("Open Document Picker")
            }
        }
        .padding()
        .fileImporter( isPresented: $openFile, allowedContentTypes: [.image,.folder], allowsMultipleSelection: true, onCompletion: {
                    (Result) in
                    
                    do{
                        let fileURL = try Result.get()
                       //todo: use callback
                        onSelect(fileURL)
                        self.fileName = fileURL.first?.lastPathComponent ?? "file not available"
                        
                    }
                    catch{
                       print("error reading file \(error.localizedDescription)")
                    }
                    
                })
    }
}
