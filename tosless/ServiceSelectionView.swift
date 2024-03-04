//
//  ServiceSelectionView.swift
//  tosless
//
//  Created by Joshua Tint on 1/27/24.
//

import Foundation
import SwiftUI
import CoreML

struct ServiceSelectionView: View {
    @State var searchQuery = ""
    @State var searchResults = [TosdrService]()
    @Binding var listedServices: [ResultService]?

    
    init(listedServices: Binding<[ResultService]?>) {
        UITableView.appearance().backgroundColor = .white
        self._listedServices = listedServices
        
    }
    
    var body: some View {
        VStack {
            if searchQuery == "" {
                NavigationLink(destination: ServiceResultsView(service: Service(title: "Copied Service", iconURL: nil), details: ResultDetails(details: [:]), evidence: UIPasteboard.general.string ?? "", listedServices: $listedServices, id: UUID())) {
                    VStack {
                        Image(systemName: "clipboard")
                            .font(.system(size: 120))
                        Text("Get From Clipboard")
                    }
                }
            } else {
                ScrollView {
                    ForEach(searchResults, id: \.self) {searchResult in
                        if !searchResult.isDeprecated() {
                            
                            NavigationLink(destination: ServiceResultsView(service: searchResult, listedServices: $listedServices)) {
                                HStack {
                                    Spacer()
                                    Text(searchResult.name)
                                    Spacer()
                                }
                            }
                            
                            Divider()

                        }
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: ServiceResultsView(service: Service(title: "Copied Service", iconURL: nil), details: ResultDetails(details: [:]), evidence: UIPasteboard.general.string ?? "", listedServices: $listedServices, id: UUID())) {
                    HStack {
                        Text("...Or Get From Clipboard")
                        Image(systemName: "clipboard")
                            .font(.system(size: 36))
                        
                    }
                }
            }
        }
        .searchable(text: $searchQuery, prompt: "Search for an app or website...")
        .onChange(of: searchQuery) { newValue in
            getServiceSearches(query: newValue) { results in
                searchResults = results
            }
        }
        .onSubmit {
            getServiceSearches(query: searchQuery) { results in
                searchResults = results
            }
        }
        
        
        
    }
    
    
    private struct ServiceResult: Hashable {
        let initialDetails: [Detail]
        let serviceName: String
        let iconURL: URL?
    }
}
