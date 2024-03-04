//
//  ServiceListView.swift
//  tosless
//
//  Created by Joshua Tint on 2/6/24.
//

import Foundation
import SwiftUI


struct ServiceListView: View {
    let defaults = UserDefaults()
    @Binding var resultServices: [ResultService]?
    
    
    
    var emptyPlaceholder: some View {
        VStack {
            Spacer()
            
            Image(systemName: "wind")
                .font(.system(size: 120))
                .foregroundColor(.gray)
            Text("There's nothing here yet!")
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
    
    var body: some View {
        VStack {
            Text("My Services")
                .font(.system(size: 50, weight: .black))
            
            if let resultServices {
                if resultServices.count > 0 {
                    List() {
                        ForEach(resultServices, id: \.id) { resultService in
                            NavigationLink {
                                ServiceResultsView(service: resultService.service, details: resultService.resultDetails, evidence: resultService.evidence, listedServices: $resultServices, id: resultService.id)
                            } label: {
                                resultService.badge
                            }
                                .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(.inset)
                } else {
                    emptyPlaceholder
                }
            } else {
                emptyPlaceholder
            }
            
        }
    }
    
    func delete(at offsets: IndexSet) {
        resultServices?.remove(atOffsets: offsets)
        let encoder = JSONEncoder()
        do {
            UserDefaults.standard.set(try encoder.encode(resultServices), forKey: "Saved Services")
        } catch {
            print(error)
        }
    }
}
