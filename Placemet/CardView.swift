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
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: geo.size.width)
                    .clipped()
                    .padding()
                HStack {
                    if let name = business.name {
                        Text(name)
                    }
                    Spacer()
                    if let distance = business.distance {
                        Text("\(distance) meters away")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(12)
            .shadow(radius: 4)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(business: Business(name: "Fun Town", distance: 420))
    }
}
