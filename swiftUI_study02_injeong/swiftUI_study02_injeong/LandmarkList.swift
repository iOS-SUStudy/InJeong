//
//  LandmarkList.swift
//  swiftUI_study02_injeong
//
//  Created by 최인정 on 2020/08/27.
//  Copyright © 2020 indoni. All rights reserved.
//

import SwiftUI

struct LandmarkList: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $userData.showFavoritesOnly) {
                    Text("Favorites only")
                }
                
                
                ForEach(userData.landmarks) { landmark in
                    if !self.userData.showFavoritesOnly || landmark.isFavorite {
                        NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
                            LandmarkRow(landmark: landmark)
                        }
                    }
                }
                .navigationBarTitle(Text("LandMark"))
            }
        }
    }
    
    struct LandmarkList_Previews: PreviewProvider {
        static var previews: some View {
            //ForEach(["iPhone XS Max"], id: \.self) { deviceName in
                LandmarkList().environmentObject(UserData())
                    //.previewDevice(PreviewDevice(rawValue: deviceName))
                   // .previewDisplayName(deviceName)
           // }
        }
    }
}
