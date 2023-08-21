//
//  ContentView.swift
//  Placemet
//
//  Created by Deja Jackson on 8/6/23.
//

import SwiftUI
import CoreData
import CardStack

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var businesses = [Business]()
    @StateObject var locManager = LocationManager()

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
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
        })
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(Text("PlaceMet"))
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
