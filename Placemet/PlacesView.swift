//
//  PlacesView.swift
//  Placemet
//
//  Created by Deja Jackson on 10/8/23.
//

import SwiftUI
import CardStack

struct PlacesView: View {
    @State var businesses = [Business]()
    @StateObject var locManager = LocationManager()
    
    var body: some View {
        VStack {
            switch locManager.locationManager.authorizationStatus {
            case .authorizedWhenInUse:
                CardStack(direction: LeftRight.direction, data: businesses) { card, direction in
                    print("Swiped \(direction).")
                } content: { business, _, _ in
                    CardView(business: business)
                }
            case .restricted, .denied:
                Text("Location permissions are restricted or were denied.")
            case .notDetermined:
                VStack {
                    Text("Asking for location permissions...")
                    ProgressView()
                }
            case .authorizedAlways:
                Text("Thanks for authorizing us to always use your location!")
            @unknown default:
                ProgressView()
            }
        }
        .onAppear(perform: {
            if locManager.locationManager.authorizationStatus == .authorizedWhenInUse {
                fetchBusinesses()
            }
        })
        .onChange(of: locManager.authorizationStatus, perform: { value in
            if value == .authorizedWhenInUse {
                fetchBusinesses()
            }
        })
    }
    
    private func fetchBusinesses() {
        guard let userLoc = locManager.locationManager.location else { return }
        
        YLPClient().searchForBusinesses(coordinates: Coordinates(latitude: userLoc.coordinate.latitude, longitude: userLoc.coordinate.longitude)) { bizes, error in
            if let error = error {
                print("Error fetching businesses: \(error.localizedDescription)")
                return
            }
            
            guard let bizes = bizes else { return }
            
            businesses = bizes
        }
    }
}

#Preview {
    PlacesView()
}
