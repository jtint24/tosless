//
//  ResultPoints.swift
//  tosless
//
//  Created by Joshua Tint on 1/24/24.
//

import Foundation
import NaturalLanguage
import CoreML


struct ResultDetails: Codable {
    var details: [DetailType: Detail]
    var completed = false
    
    init(details: [DetailType: Detail]) {
        self.details = details
    }
    
    var grade: Grade {
        if !completed || details.count == 0 {
            return .Unknown
        }
        var score = 0
        for detail in details {
            switch detail.key.concernLevel {
            case .bad(let points):
                score -= points
            case .good(let points):
                score += points
            default: break
            }
        }
        
        return Grade.fromScore(score)
    }
    
    func sortedDetails() -> [Detail] {
        let goodDetails = detailsOfLevel(.good())
        let badDetails = detailsOfLevel(.bad())
        let neutralDetails = detailsOfLevel(.neutral)
        
        let sorter: (Detail, Detail) -> Bool = {d1, d2 in
            Double(d1.detailType.concernLevel.points) * d1.confidence > Double(d2.detailType.concernLevel.points) * d2.confidence
        }
        
        
        return goodDetails.sorted(by: sorter) +
        badDetails.sorted(by: sorter) +
        neutralDetails.sorted(by: sorter)
    }
    
    var featuredDetails: [Detail] {
        let goodDetails = detailsOfLevel(.good())
        let badDetails = detailsOfLevel(.bad())
        let neutralDetails = detailsOfLevel(.neutral)
                
        let goodCount = Int(round((6.0 * Double(goodDetails.count)) / Double(details.count)))
        let badCount = min(6-goodCount, Int(round((6.0 * Double(badDetails.count)) / Double(details.count))))
        let neutralCount = 6-goodCount-badCount
        
        let sorter: (Detail, Detail) -> Bool = {d1, d2 in
            let d1Score = Double(d1.detailType.concernLevel.points) * d1.confidence
            let d2Score = Double(d2.detailType.concernLevel.points) * d2.confidence
            
            if (d1Score, d1.detailType.explanation) == (d2Score, d2.detailType.explanation) {
                print("tie!")
            }
            
            return (d1Score, d1.detailType.explanation) > (d2Score, d2.detailType.explanation)
        }
        
        return Array(goodDetails.sorted(by: sorter)[0..<min(goodCount, goodDetails.count)]) +
        Array(badDetails.sorted(by: sorter)[0..<min(badCount, badDetails.count)]) +
        Array(neutralDetails.sorted(by: sorter)[0..<min(neutralCount, neutralDetails.count)])
    }
    
    
    mutating func markCompleted() {
        completed = true
    }
    
    func detailsOfLevel(_ level: DetailType.ConcernLevel) -> [Detail] {
        return Array(details.filter({detail in detail.key.concernLevel == level}).values)
    }
    
    mutating func addDetail(_ detail: Detail) {
        if details[detail.detailType] != nil {
            details[detail.detailType]!.evidence.append(contentsOf: detail.evidence)
        } else {
            details[detail.detailType] = detail
        }
    }
    
    mutating func addDetailFrom(evidence: String, model: NLModel) async {
        let predictions = model.predictedLabelHypotheses(for: evidence, maximumCount: 3)
        
        let bestDetailPrediction = predictions.max { a, b in a.value < b.value }
        let confidence = bestDetailPrediction?.value ?? 0
        
        let newDetailTypeLabel: String
        if confidence >= 0.6 {
            newDetailTypeLabel = bestDetailPrediction?.key ?? "-1"
        } else {
            newDetailTypeLabel = "-1"
        }
        
        
        print("detail type: \(newDetailTypeLabel) confidence: \(String(describing: confidence))")
        if let newDetailType = DetailTypeFactory.getDetailType(fromLabel: newDetailTypeLabel) {
            addDetail(
                    Detail(
                        evidence: [evidence],
                        detailType: newDetailType,
                        confidence: confidence
                    )
            )
        }
    }
    
    enum Grade: String, Codable {
        case A = "A"
        case B = "B"
        case C = "C"
        case D = "D"
        case F = "F"
        case Unknown = "?"
        
        static func fromScore(_ score: Int) -> Grade {
            if (score <= -100) {
                return .F
            } else if (score <= -50) {
                return .D
            } else if (score <= 0) {
                return .C
            } else if (score <= 50) {
                return .B
            } else {
                return .A
            }
        }
    }
}
