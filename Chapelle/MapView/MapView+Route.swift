//
//  File.swift
//  Chapelle
//
//  Created by Adrien Humiliere on 18/01/2022.
//

import UIKit
import Mapbox

extension MapView {
    func addRoute(_ polyline: MGLPolyline, to mapView: MGLMapView) {
        mapView.add(polyline)
    }
}

extension TrackMetadata {
    func polyline() -> MGLPolyline? {
        guard let path = gpxPath else { return nil }
        
        do {
            let waypoints = try GPXParser().parseWaypoints(from: path)
            var coordinates = waypoints.map { $0.coordinates }
            return MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        } catch {
            return nil
        }
    }
}

extension MGLPolyline {
    func surroundingRegion() -> MGLCoordinateBounds {
        var latitudeMin: Double = .infinity
        var latitudeMax: Double = -Double.infinity
        var longitudeMin: Double = .infinity
        var longitudeMax: Double = -Double.infinity
        
        
        
        for index in 0 ..< pointCount {
            let point = coordinates[Int(index)]
            latitudeMin = min(latitudeMin, point.latitude)
            latitudeMax = max(latitudeMax, point.latitude)
            longitudeMin = min(longitudeMin, point.longitude)
            longitudeMax = max(longitudeMax, point.longitude)
        }
        
        let margin = -0.005
        return MGLCoordinateBounds(sw: CLLocationCoordinate2D(latitude: latitudeMin - margin, longitude: longitudeMin - margin),
                                   ne: CLLocationCoordinate2D(latitude: latitudeMax + margin, longitude: longitudeMax + margin))
    }
}

extension Array where Element == MGLPolyline {
    func surroundingRegion() -> MGLCoordinateBounds {
        var latitudeMin: Double = .infinity
        var latitudeMax: Double = -Double.infinity
        var longitudeMin: Double = .infinity
        var longitudeMax: Double = -Double.infinity
        
        for polyline in self {
            for index in 0..<polyline.pointCount {
                let point = polyline.coordinates[Int(index)]
                latitudeMin = Swift.min(latitudeMin, point.latitude)
                latitudeMax = Swift.max(latitudeMax, point.latitude)
                longitudeMin = Swift.min(longitudeMin, point.longitude)
                longitudeMax = Swift.max(longitudeMax, point.longitude)
            }
        }
        
        let margin = -0.005
        return MGLCoordinateBounds(sw: CLLocationCoordinate2D(latitude: latitudeMin - margin, longitude: longitudeMin - margin),
                                   ne: CLLocationCoordinate2D(latitude: latitudeMax + margin, longitude: longitudeMax + margin))
    }
}
