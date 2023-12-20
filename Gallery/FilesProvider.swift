//
//  ItemsProvider.swift
//  Gallery
//
//  Created by ANDREY STEPANOV on 16.12.23.
//

import Foundation

class FilesProvider {
    var urls: [URL] = []
    
    func setUrls(urls: [URL]) {
        self.urls = urls
    }
    
    func getFiles() -> [URL] {
        if (urls.isEmpty) {
            print("URL NOT SET")
            return []
        }
        
        return urls.flatMap(getFiles)
    }
    
    func getFiles(url: URL) -> [URL] {
        guard url.startAccessingSecurityScopedResource() else {
                // Handle the failure here.
                return []
            }
        
        defer { url.stopAccessingSecurityScopedResource() }
        
        if (!url.hasDirectoryPath) {
            return [url]
        }
            
        var error: NSError? = nil
        var result: [URL] = [];
        NSFileCoordinator().coordinate(readingItemAt: url, error: &error) { (url) in
            let keys : [URLResourceKey] = [.nameKey, .isDirectoryKey]
            
            // Get an enumerator for the directory's content.
            guard let fileList =
                    FileManager.default.enumerator(at: url, includingPropertiesForKeys: keys) else {
                Swift.debugPrint("*** Unable to access the contents of \(url.path) ***\n")
                return
            }
            
            for case let file as URL in fileList {
                // Start accessing the content's security-scoped URL.
                guard file.startAccessingSecurityScopedResource() else {
                    continue
                }
                
                print("ADD FILE \(file.absoluteString)")
                result.append(file)
                
                // Do something with the file here.
                Swift.debugPrint("chosen file: \(file.lastPathComponent)")
                
                // Make sure you release the security-scoped resource when you finish.
                file.stopAccessingSecurityScopedResource()
            }
        }
        
        return result
    }
}
