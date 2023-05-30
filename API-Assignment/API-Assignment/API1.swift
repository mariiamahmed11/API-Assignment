//
//  API1.swift
//  API-Assignment
//
//  Created by user on 30/05/2023.
//

import Foundation
import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct API1: View {
    @State private var results = [Result]()
    
    var body: some View {
        
        VStack{
            Image("img1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 390)
            
            Text("Choose song to listen for :")
                .font(.title2)
                .foregroundColor(.red)
                .bold()
            
            
            List(results, id: \.trackId) { item in
                VStack(alignment: .leading) {
                    Text(item.trackName)
                        .font(.headline)
                    Text(item.collectionName)
                }
            }
            
            .task {
                await loadData()
            }
        }
    }
    
    func loadData() async {
        
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
                
            } catch {
                print("Invalid data")
            }
        }

}

struct API1_Previews: PreviewProvider {
    static var previews: some View {
        API1()
    }
}
