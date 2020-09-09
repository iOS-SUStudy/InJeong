//
//  ContentView.swift
//  Landmarks
//
//  Created by 최인정 on 2020/09/08.
//  Copyright © 2020 indoni. All rights reserved.
//

import SwiftUI

struct LandmarkDetail: View {
    
    @EnvironmentObject var userData: UserData
    
    var landmark: Landmark
    
    var landmarkIndex: Int {
        userData.landmarks.firstIndex(where: { $0.id == landmark.id })!
    }
    
    var body: some View {
        
        VStack {
            MapView(coordinate: landmark.locationCoordinate).edgesIgnoringSafeArea(.top)
                .frame(height: 300)
            
            CircleImage(image: landmark.image).offset(y:-130).padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(landmark.name)
                        .font(.title)
                    
                    // Favorite value
                    Button(action: {
                        self.userData.landmarks[self.landmarkIndex].isFavorite.toggle()
                    }) {
                        if self.userData.landmarks[self.landmarkIndex].isFavorite {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color.yellow)
                        } else {
                            Image(systemName: "star")
                                .foregroundColor(Color.gray)
                        }
                    }
                    
                    // Featured value
                    Button(action: {
                        self.userData.landmarks[self.landmarkIndex].isFeatured.toggle()
                    }) {
                        if self.userData.landmarks[self.landmarkIndex].isFeatured {
                            Image(systemName: "heart.fill")
                                .foregroundColor(Color.red)
                        } else {
                            Image(systemName: "heart")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                
                HStack {
                    Text(landmark.park)
                        .font(.subheadline)
                    Spacer()
                    Text(landmark.state)
                        .font(.subheadline)
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationBarTitle(Text(landmark.name), displayMode: .inline)
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetail(landmark: landmarkData[0])
            .environmentObject(UserData())
    }
}
