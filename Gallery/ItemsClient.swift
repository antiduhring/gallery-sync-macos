//
//  ItemsClient.swift
//  Gallery
//
//  Created by ANDREY STEPANOV on 15.12.23.
//

import Foundation


class ItemsClient: ObservableObject {
    @Published var items: [Item] = []
    let itemsProvider = FilesProvider()
    let urlSession = URLSession.shared
    let SERVER_URL: String = "https://antiduhring-gallery-staging-14336907a0b3.herokuapp.com"
//    let SERVER_URL: String = "http://192.168.2.102:8080"
    let UPLOAD_SERVER_URL: String = "https://antiduhring-gallery-staging-14336907a0b3.herokuapp.com"
//    let UPLOAD_SERVER_URL: String = "http://192.168.2.102:8080"
    
    func loadItems() {
        guard let url = URL(string: SERVER_URL) else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)
        let dataTask = urlSession.dataTask(with: urlRequest) {(data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedItems = try JSONDecoder().decode([Item].self, from: data)
                        self.items = decodedItems
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    func syncItems() async {
        let files = itemsProvider.getFiles()
        for file in files {
            await createItem(file: file)
            
        }
    }
    
    func setUrls(urls: [URL]) {
        itemsProvider.setUrls(urls: urls)
    }
    
    private func createItem(file: URL) async{
        await uploadFile(file: file)
    }
    
    private func uploadFile(file: URL) async {
print("UPLOAD FILE \(file.absoluteString) HAS DIRECTORY PATH\(file.hasDirectoryPath)")
        do {
            guard file.startAccessingSecurityScopedResource() else {
                    print("NOT ACCESSIBLE")
                    return
            }
            
            defer { file.stopAccessingSecurityScopedResource() }
            let data = try Data(contentsOf: file)
            await upload(data: data)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func upload(data: Data) async {
        guard let url = URL(string: UPLOAD_SERVER_URL) else { fatalError("Missing URL") }
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        
        request.httpMethod = "POST"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.setValue("Some name", forHTTPHeaderField: "name")
        
        let task = urlSession.uploadTask(
            with: request,
            from: data
        )
        
        task.resume()
    }
    
    private func createItem(item: Item) async {
        print("ADD ITEM");
        guard let encoded = try? JSONEncoder().encode(item) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: SERVER_URL)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            // handle the result
        } catch {
            print("Checkout failed: \(error.localizedDescription)")
        }
    }
}
