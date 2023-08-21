//
//  YLPClient.swift
//  Placemet
//
//  Created by Deja Jackson on 8/12/23.
//

import Foundation

class YLPClient: ObservableObject {
    func searchForBusinesses(coordinates: Coordinates, completion: @escaping ([Business]?, Error?) -> Void) {
        let requestURL = "https://api.yelp.com/v3/businesses/search?latitude=\(coordinates.latitude)&longitude=\(coordinates.longitude)"
        
        guard let url = URL(string: requestURL) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
            }
            
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                
                guard let resp = json as? NSDictionary else { return }
                
                guard let businesses = resp.value(forKey: "businesses") as? [NSDictionary] else { return }
                
                var fetchedBusinesses: [Business] = []
                
                for business in businesses {
                    var biz = Business()
                    biz.id = business.value(forKey: "id") as? String
                    biz.name = business.value(forKey: "name") as? String
                    biz.rating = business.value(forKey: "rating") as? Float
                    biz.price = business.value(forKey: "price") as? String
                    biz.is_closed = business.value(forKey: "is_closed") as? Bool
                    biz.distance = business.value(forKey: "distance") as? Double
                    
                    let url = business.value(forKey: "image_url") as? String
                    if let url = url {
                        biz.image_url = URL(string: url)
                    }
                    
                    let address = business.value(forKey: "location.display_address") as? [String]
                    biz.address = address?.joined(separator: "\n")
                    
                    fetchedBusinesses.append(biz)
                }
                
                completion(fetchedBusinesses, nil)
            } catch {
                print("Whoopsie!")
                completion(nil, error)
            }
        }
        .resume()
    }
}
