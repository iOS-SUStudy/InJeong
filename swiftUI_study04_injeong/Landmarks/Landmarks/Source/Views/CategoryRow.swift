//
//  CategoryRow.swift
//  Landmarks
//
//  Created by 최인정 on 2020/09/24.
//  Copyright © 2020 indoni. All rights reserved.
//

import SwiftUI

struct CategoryRow: View {
    var categoryName: String
    var items: [Landmark]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(self.categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(self.items) { landmark in
                        NavigationLink(
                            destination: LandmarkDetail(landmark: landmark)
                        ) {
                            CategoryItem(landmark: landmark)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
       
    }
}

struct CategoryItem: View {
    var landmark: Landmark
    var body: some View {
        VStack(alignment: .leading) {
            landmark.image
                .renderingMode(.original) // 이미지 자체를 그냥 넣어주는 것
                                          // .template는 아무것도 안나옴(이미지를 넣을 공간만!)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(6)
            Text(landmark.name)
                .foregroundColor(.primary) // 원래색으로 (버튼 파란색이지만 원래색으로!)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRow(
            categoryName: landmarkData[0].category.rawValue,
            items: Array(landmarkData.prefix(4))
        )
    }
}
