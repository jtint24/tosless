//
//  ServiceResults.swift
//  tosless
//
//  Created by Joshua Tint on 2/5/24.
//

import Foundation
import SwiftUI

struct ResultService: Codable, Identifiable {
    let service: Service
    let resultDetails: ResultDetails
    let evidence: String
    let id: UUID
    
    var badge: some View {
        VStack {
            HStack {
                service.icon
                // DetailSummaryWheel(details: resultDetails)
                Text(service.name)
                    .font(.title3)
                    .bold()
                Spacer()
                Text(resultDetails.grade.rawValue)
                    .font(.title3)
                    .bold()
            }
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .green)
                Text("\(resultDetails.detailsOfLevel(.good()).count)")

                Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .red)
                Text("\(resultDetails.detailsOfLevel(.bad()).count)")

                Image(systemName: "info.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .yellow)
                Text("\(resultDetails.detailsOfLevel(.neutral).count)")

                
                
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("BackgroundColor"))
        )
    }
}
