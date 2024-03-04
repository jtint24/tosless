//
//  DetailSummary.swift
//  tosless
//
//  Created by Joshua Tint on 1/24/24.
//

import SwiftUI

struct DetailSummaryWheel: View {
    let details: ResultDetails
    
    var arcPoints: [(Color, Angle, Angle)] {
        let detailCount = details.details.count
        
        if detailCount == 0 {
            return [(Color.gray, .degrees(0), .degrees(360))]
        }
        
        
        let neutralDetailCount = details.detailsOfLevel(.neutral).count
        let goodDetailCount = details.detailsOfLevel(.good()).count
        let goodAngle = Double(goodDetailCount)/Double(detailCount) * 360.0
        let neutralAngle = Double(goodDetailCount + neutralDetailCount)/Double(detailCount) * 360.0

        return [
            (Color.green, .degrees(0), .degrees(goodAngle)),
            (Color.yellow, .degrees(goodAngle), .degrees(neutralAngle)),
            (Color.red, .degrees(neutralAngle), .degrees(360)),
            
        ]
    }
    
    var body: some View {
        Text(details.grade.rawValue)
            .font(.system(size: 70, weight: .black))
            .background(
                ArcChart(
                    points: arcPoints,
                    radius: 70,
                    strokeStyle: StrokeStyle(lineWidth: 30, lineCap: .round),
                    label: details.grade.rawValue
                )
            )
    }
}

struct ArcChart : View {
    let points: [(Color, Angle, Angle)]
    let radius: CGFloat
    let strokeStyle: StrokeStyle
    let label: String
    
    
    /*
     var paths: [any View] {
     var retPaths: [any View]
     var startAngle: Angle = .degrees(0)
     
     for (pointColor, pointAngle) in points {
     var p = Path()
     p.addArc(center: CGPoint(x: radius, y: radius), radius: radius, startAngle: startAngle, endAngle: pointAngle, clockwise: true)
     startAngle = pointAngle
     retPaths.append(p.stroke(pointColor, style: strokeStyle))
     }
     
     return retPaths
     }
     */
    
    var body: some View {
        
        ZStack {
            Circle()
                .fill(Color("baseColor"))
                .frame(width: radius*2, height: radius*2)
            ForEach(points, id: \.0) { (arcColor, startAngle, endAngle) in
                Circle()
                    .trim(from: 0.0, to: (endAngle.degrees-startAngle.degrees)/360.0)
                    .rotation(startAngle - Angle.degrees(90))
                    .stroke(arcColor, style: strokeStyle)
                    .frame(width: radius*2, height: radius*2)
            }
            
            if (points[0].2 > .degrees(0)) {
                Circle()
                    .trim(from: 0.0, to: 0.001)
                    .rotation(points[0].1 - Angle.degrees(90))
                    .stroke(points[0].0, style: strokeStyle)
                    .frame(width: radius*2, height: radius*2)
            }
        }
        
    }
}
