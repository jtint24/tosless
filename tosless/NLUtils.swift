//
//  NLUtils.swift
//  tosless
//
//  Created by Joshua Tint on 1/27/24.
//

import Foundation
import NaturalLanguage

func getSentences(_ text: String, onSentence: (String) -> Void ) -> Void {
    let tokenizer = NLTokenizer(unit: .sentence)
    tokenizer.string = text
    
    tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
        onSentence(String(text[range.lowerBound..<range.upperBound]))
        return true
    }
}
