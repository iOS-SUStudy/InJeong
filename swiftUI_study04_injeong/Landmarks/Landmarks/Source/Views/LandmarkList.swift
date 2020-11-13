//
//  LandmarkList.swift
//  Landmarks
//
//  Created by 최인정 on 2020/09/09.
//  Copyright © 2020 indoni. All rights reserved.
//

import SwiftUI

struct LandmarkList: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
//        NavigationView {
            List {
//                Toggle(isOn: $userData.showFavoritesOnly) {
//                    Text("Favorites only")
//                }
                
                Toggle(isOn: $userData.showFeaturedOnly) {
                    Text("Featured only")
                }
                
                ForEach(userData.landmarks) { landmark in
                    if !self.userData.showFeaturedOnly || landmark.isFeatured {
                        NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
                            LandmarkRow(landmark: landmark)
                        }
                    }
                }
                
            }
            .navigationBarTitle(Text("Landmarks"))
        }
        
        
//    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
//        LandmarkList()
//            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
        NavigationView {
            LandmarkList()
                .environmentObject(UserData())
        }
    }
}

