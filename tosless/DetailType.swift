//
//  DetailType.swift
//  tosless
//
//  Created by Joshua Tint on 1/24/24.
//

import Foundation
import SwiftUI


struct DetailType: Hashable, Codable {
    let summary: String
    let explanation: String
    let concernLevel: ConcernLevel
    
    init(summary: String, explanation: String = "", concernLevel: ConcernLevel) {
        self.summary = summary
        self.explanation = explanation
        self.concernLevel = concernLevel
    }
    
    enum ConcernLevel: Hashable, Codable {
        case good(_ points: Int = 0)
        case bad(_ points: Int = 0)
        case neutral
        
        static func ==(lhs: ConcernLevel, rhs: ConcernLevel) -> Bool {
            switch (lhs, rhs) {
            case (good(_), good(_)):
                return true
            case (bad(_), bad(_)):
                return true
            case (neutral, neutral):
                return true
            default:
                return false
            }
        }
        
        var points: Int {
            switch self {
            case .good(let points):
                return points
            case .bad(let points):
                return points
            case .neutral:
                return 0
            }
        }
        
        var badge: some View {
            switch self {
            case .bad:
                return Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .red)
            case .good:
                return Image(systemName: "checkmark.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .green)
            case .neutral:
                return Image(systemName: "info.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .yellow)
            }
            
        }
        
        var bgColor: Color {
            switch self {
            case .bad:
                return Color("badBG")
            case .good:
                return Color("goodBG")
            case .neutral:
                return Color("neutralBG")
            }
        }
    }
}
