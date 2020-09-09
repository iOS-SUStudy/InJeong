//
//  LandmarkRow.swift
//  swiftUI_study02_injeong
//
//  Created by 최인정 on 2020/08/27.
//  Copyright © 2020 indoni. All rights reserved.
//

import SwiftUI

struct LandmarkRow: View {
    
    var landmark: Landmark
    var body: some View {
        HStack {
            landmark.image
                .resizable()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(landmark.name)
                Text(landmark.state)
                    .font(.subheadline)

            }
            
            Spacer()
            if landmark.isFavorite {
                Image(systemName: "star.fill")
                    .imageScale(.medium)
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LandmarkRow(landmark: landmarkData[0])
            LandmarkRow(landmark: landmarkData[1])
        }
         .previewLayout(.fixed(width: 300, height: 70))
    }
}
