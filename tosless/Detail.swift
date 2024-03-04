//
//  Detail.swift
//  tosless
//
//  Created by Joshua Tint on 1/24/24.
//

import Foundation
import SwiftUI

struct Detail: Hashable, Codable {
    var evidence: [String]
    let detailType: DetailType
    let confidence: Double
    
    func badge(alignment: Alignment?) -> AnyView {

        let alignmentCorners: UIRectCorner
        if let alignment {
            alignmentCorners = alignment == .top ? [.topLeft, .topRight] : (alignment == .center ? [] : [.bottomLeft, .bottomRight])
        } else {
            alignmentCorners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
        }
        
        
        
        return AnyView (
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        detailType.concernLevel.badge
                        Text(detailType.summary)
                            .bold()
                    }
                    //Text(" "+(evidence.first ?? ""))
                    //    .italic()
                    //    .lineLimit(1)
                }
                Spacer()
            }
                .padding()
                .frame(maxWidth: .infinity)
                .background(detailType.concernLevel.bgColor)
                .clipShape(RoundedCorner(radius: 30, corners: alignmentCorners))
        )
        
    }
}



struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
    
}
