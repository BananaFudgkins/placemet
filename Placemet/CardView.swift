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
                            .font(.headline)
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
                if let rating = business.rating {
                    HStack {
                        if let intRating = Int(exactly: rating.rounded()) {
                            ForEach(1..<intRating + 1) { number in
                                Image(systemName: "star.fill")
                            }
                        }
                        
                        if rating.truncatingRemainder(dividingBy: 0.5) == 0.0 {
                            Image(systemName: "star.leadinghalf.fill")
                        }
                    }
                }
                if let price = business.price {
                    Text("\(price)")
                }
            }
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(12)
            .shadow(radius: 4)
            .padding(.horizontal, 15)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(business: Business(name: "The Pink Door", distance: 420, image_url: URL(string: "https://s3-media3.fl.yelpcdn.com/bphoto/CoY9bQZtxt_1PEV_DgQWIg/o.jpg")))
    }
}
