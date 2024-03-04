//
//  AllDetailView.swift
//  tosless
//
//  Created by Joshua Tint on 2/20/24.
//

import Foundation
import SwiftUI


struct DetailListView: View {
    let details: ResultDetails
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Array(details.sortedDetails()), id: \.self) {detail in
                    NavigationLink {
                        DetailView(detail: detail)
                    } label: {
                        detail.badge(alignment: nil)
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
