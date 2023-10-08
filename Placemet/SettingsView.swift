//
//  SettingsView.swift
//  Placemet
//
//  Created by Deja Jackson on 10/8/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var searchRadius: Double = 700
    
    var body: some View {
        List {
            Section {
                Button("Add a designated contact", systemImage: "person.crop.circle.fill.badge.plus") {
                    print("DO SOMETHING TWITTER BE LIKE")
                }
            } header: {
                Text("Designated Contacts")
            } footer: {
                Text("You can send designated contacts a text message about where you're going before you go to meet someone you've matched with.")
            }
            Section {
                VStack(spacing: 10) {
                    Slider(value: $searchRadius, in: 0...40000, step: 5) {
                        Text("Search radius")
                    } minimumValueLabel: {
                        Text("0 meters")
                    } maximumValueLabel: {
                        Text("40,000 meters")
                    }
                    Text(searchRadius == 1 ? "1 meter" : "\(searchRadius) meters")
                }
            } header: {
                Text("Search radius")
            }
        }
    }
}

#Preview {
    SettingsView()
}
