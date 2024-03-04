//
//  ContentView.swift
//  tosless
//
//  Created by Joshua Tint on 1/24/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var listedServices: [ResultService]?
    
    var body: some View {
        
        TabView {
            NavigationStack() {
                ServiceSelectionView(listedServices: $listedServices)
            }
            .tabItem {
                Label("Import", systemImage: "magnifyingglass")
            }
            NavigationStack() {
                ServiceListView(resultServices: $listedServices)
            }
            .tabItem {
                Label("My Services", systemImage: "list.bullet")
            }
        }
        .toolbarBackground(.visible, for: .tabBar)
    }

}
