//
//  CircleImage.swift
//  swiftUI_study02_injeong
//
//  Created by 최인정 on 2020/08/27.
//  Copyright © 2020 indoni. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var image: Image
    
    var body: some View {
        image.clipShape(Circle()).overlay(Circle().stroke(Color.white, lineWidth: 4)).shadow(radius: 10)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("turtlerock"))
    }
}
