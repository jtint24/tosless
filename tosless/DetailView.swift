//
//  DetailView.swift
//  tosless
//
//  Created by Joshua Tint on 1/25/24.
//

import SwiftUI

struct DetailView: View {
    let detail: Detail
    
    init(detail: Detail) {
        self.detail = detail
    }
    
    var body: some View {
        
        VStack {
            ScrollView {

            HStack {
                detail.detailType.concernLevel.badge
                    .font(.title)
                
                Text(detail.detailType.summary)
                    .font(.title)
                    .bold()
                
            }
            
            Text(detail.detailType.explanation)
                .italic()
            
                ForEach(detail.evidence, id: \.self) {evidence in
                    VStack {
                        HStack {
                            Image(systemName: "quote.opening")
                            Spacer()
                        }
                        Text(evidence)
                        HStack {
                            Spacer()
                            Image(systemName: "quote.closing")
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(Color("BackgroundColor"))
                    )
                }
            }
            
            
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
        
        
        
    }
}

