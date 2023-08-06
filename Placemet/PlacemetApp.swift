//
//  PlacemetApp.swift
//  Placemet
//
//  Created by Deja Jackson on 8/6/23.
//

import SwiftUI

@main
struct PlacemetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
