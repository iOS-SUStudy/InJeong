//
//  UserData.swift
//  Landmarks
//
//  Created by 최인정 on 2020/09/09.
//  Copyright © 2020 indoni. All rights reserved.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var showFavoritesOnly = false
    @Published var landmarks = landmarkData
    @Published var showFeaturedOnly = false
}
