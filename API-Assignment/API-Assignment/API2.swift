//
//  API2.swift
//  API-Assignment
//
//  Created by user on 30/05/2023.
//

import SwiftUI
struct ObjectsResponse: Codable {
    var ObjectsResults: [Objects]
}

struct Objects: Codable {
    var objectID : String
    var primaryImageSmall: String
    var department: String
    var title: String
    var culture: String
    var period: String
    //var constituents: [String:String, Int]
}


struct API2: View {
    @State private var ObjectsResults = [Objects]()
    var body: some View {
        
        VStack{

            Text("Museme Arts :")
                .font(.title2)
                .foregroundColor(.red)
                .bold()
                 
            List(ObjectsResults, id: \.objectID) { item in
                VStack(alignment: .leading) {
                    Image("primaryImageSmall")
                    Text(item.title)
                        .font(.headline)
                    Text(item.department)
                    Text(item.culture)
                    Text(item.period)
                }
            }
            
            .task {
                await loadData()
            }
        }
    }
    
    func loadData() async {
        
        guard let url = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/objects/[objectID]") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedObjectsResponse = try? JSONDecoder().decode(ObjectsResponse.self, from: data) {
                ObjectsResults = decodedObjectsResponse.ObjectsResults
            }
                
            } catch {
                print("Invalid data")
            }
        }
}

struct API2_Previews: PreviewProvider {
    static var previews: some View {
        API2()
    }
}
