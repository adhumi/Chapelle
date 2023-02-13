import Foundation
import CoreLocation

enum GPXParserError: Error {
    case fileNotFound
    case parsingError
}

struct GPXParser {
    private let coordinateParser = WaypointsParser()
    
    func parseWaypoints(from filePath: String) throws -> [Waypoint] {
        guard let data = FileManager.default.contents(atPath: filePath) else {
            throw GPXParserError.fileNotFound
        }
        
        coordinateParser.prepare()
        
        let parser = XMLParser(data: data)
        parser.delegate = coordinateParser
        
        let success = parser.parse()
        guard success else { throw GPXParserError.parsingError }
                
        return coordinateParser.waypoints
    }
}

private class WaypointsParser: NSObject, XMLParserDelegate {
    private(set) var waypoints: [Waypoint] = []
    private var lastCoordinates: CLLocationCoordinate2D?
    
    func prepare() {
        waypoints = []
        lastCoordinates = nil
    }
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String]) {
        guard elementName == "trkpt" || elementName == "wpt" else { return }
        guard let latString = attributeDict["lat"], let lonString = attributeDict["lon"] else { return }
        guard let lat = Double(latString), let lon = Double(lonString) else { return }
        guard let latDegrees = CLLocationDegrees(exactly: lat), let lonDegrees = CLLocationDegrees(exactly: lon) else { return }
        
        lastCoordinates = CLLocationCoordinate2D(latitude: latDegrees, longitude: lonDegrees)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let lastCoordinates = lastCoordinates else { return }
        guard let elevation = Double(string) else { return }
        
        waypoints.append(Waypoint(coordinates: lastCoordinates, elevation: elevation))
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        lastCoordinates = nil
    }
}
