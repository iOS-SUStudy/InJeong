//
//  BadgeSymbol.swift
//  Landmarks
//
//  Created by 최인정 on 2020/09/10.
//  Copyright © 2020 indoni. All rights reserved.
//

import SwiftUI

struct BadgeSymbol: View {
    static let symbolColor = Color(red: 40.0 / 255, green: 120.0 / 255, blue: 30.0 / 255)
    
    var body: some View {
        
         GeometryReader { geometry in
           Path { path in
               let width = min(geometry.size.width, geometry.size.height)
               let height = width * 0.50
               let spacing = width * 0.025
               let middle = width / 2
               let topWidth = 0.226 * width
               let topHeight = 0.488 * height
               
               path.addLines([
                   CGPoint(x: middle, y: spacing),
                   CGPoint(x: middle - topWidth, y: topHeight - spacing),
                   CGPoint(x: middle, y: topHeight / 2 + spacing),
                   CGPoint(x: middle + topWidth, y: topHeight - spacing),
                   CGPoint(x: middle, y: spacing)
               ])

            
                path.move(to: CGPoint(x: middle, y: topHeight / 2 + spacing * 3))
            
                path.addLines([
                    CGPoint(x: middle - topWidth, y: topHeight + spacing),
                    CGPoint(x: spacing, y: height - spacing),
                    CGPoint(x: width - spacing, y: height - spacing),
                    CGPoint(x: middle + topWidth, y: topHeight + spacing),
                    CGPoint(x: middle, y: topHeight / 2 + spacing * 3)
                ])
           }
            .fill(Self.symbolColor)
       }
    }
}

struct BadgeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        BadgeSymbol()
    }
}
