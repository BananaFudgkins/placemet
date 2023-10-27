//
//  CardView.swift
//  Placemet
//
//  Created by Deja Jackson on 8/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardView: View {
    let business: Business
    
    @State var rating: Float?
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                if let image_url = business.image_url {
                    WebImage(url: image_url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width - (15 * 2), height: geo.size.width)
                        .clipped()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width - (15 * 2), height: geo.size.width)
                        .clipped()
                }
                HStack {
                    if let name = business.name {
                        Text(name)
                    }
                    Spacer()
                    if let distance = business.distance {
                        if let intDist = Int(exactly: distance.rounded()) {
                            Text(intDist == 1 ? "1 meter away" : "\(intDist) meters away")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                if let rating = rating {
                    Text("Rating: \(rating)")
                }
            }
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(12)
            .shadow(radius: 4)
            .padding(.horizontal, 15)
            .onAppear {
                getBizDetails()
            }
        }
    }
    
    private func getBizDetails() {
        guard let bizID = business.id else { return }
        
        let urlString = "https://api.yelp.com/v3/businesses/\(bizID)"
        
        guard let url = URL(string: urlString) else { fatalError("Invalid URL") }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, resp, error in
            if let error = error {
                print("Error getting biz details: \(error.localizedDescription)")
            }
            
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                
                guard let resp = json as? NSDictionary else { return }
                
                rating = resp.value(forKey: "rating") as? Float
            } catch {
                print("Whoopsie! \(error.localizedDescription)")
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(business: Business(name: "The Pink Door", distance: 420, image_url: URL(string: "https://s3-media3.fl.yelpcdn.com/bphoto/CoY9bQZtxt_1PEV_DgQWIg/o.jpg")))
    }
}
