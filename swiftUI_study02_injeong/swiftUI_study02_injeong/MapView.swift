//
//  MapView.swift
//  swiftUI_study02_injeong
//
//  Created by 최인정 on 2020/08/27.
//  Copyright © 2020 indoni. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    //추가
    var coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: 34.011_286, longitude: -116.166_868)
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        //변경
        MapView(coordinate: landmarkData[0].locationCoordinate)
    }
}
