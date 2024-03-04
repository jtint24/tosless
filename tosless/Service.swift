//
//  Service.swift
//  tosless
//
//  Created by Joshua Tint on 1/24/24.
//

import Foundation
import SwiftUI


struct Service: Codable, Equatable, Hashable {
    var name: String
    let iconURL: URL?
    
    public init(title: String, iconURL: URL?) {
        self.name = title
        self.iconURL = iconURL
    }
    
    var icon : AnyView? {
        if let iconURL {
            return AnyView(
                AsyncImage(
                    url: iconURL,
                    content: {image in
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .frame(maxWidth: 30, maxHeight: 30)
                    },
                    placeholder: {
                        ProgressView()
                            // .background(RoundedRectangle(cornerRadius: 30))
                            .frame(width: 30, height: 30)
                        
                    }
                )
            )
        } else {
            return nil
        }
    }
    
    
}
