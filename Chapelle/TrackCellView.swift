import SwiftUI
import MapKit

struct TrackCellView: View {
    let nordicFranceTrack: NordicFranceTrack
    
    var distanceFormatter: MKDistanceFormatter = {
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        return formatter
    }()
    
    var body: some View {
        let isOpened = nordicFranceTrack.status == .opened
        
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 12) {
                    Image(nordicFranceTrack.activity?.iconName ?? "")
                        .font(.largeTitle)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(nordicFranceTrack.difficulty?.color ?? Color.secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading) {
                        Text(nordicFranceTrack.name)
                            .font(.body.weight(.semibold))
                        
                        HStack {
                            if let length = nordicFranceTrack.length {
                                Text(distanceFormatter.string(fromDistance: CLLocationDistance(length)))
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }

                            if let denivelation = nordicFranceTrack.metadata?.denivelation {
                                Text("\(denivelation) D+")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            
                            if let status = nordicFranceTrack.status {
                                if !isOpened {
                                    Label(status.description, systemImage: status.systemImageName)
                                        .font(.footnote)
                                        .labelStyle(.iconOnly)
                                        .foregroundColor(nordicFranceTrack.status?.color ?? .gray)
                                }
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
//            // Remove as Nordic France data is not up to date
//            if nordicFranceTrack.info?.isEmpty != true {
//                Image(systemName: "info.circle")
//                    .symbolRenderingMode(.hierarchical)
//                    .foregroundColor(.blue)
//            }
        }
        .padding(.vertical, 4)
    }
}

struct TrackCellView_Preview: PreviewProvider {
    static var previews: some View {
        List {
            TrackCellView(nordicFranceTrack: .init(activity: .xcSkiing,
                                                   name: "Chalet Pin",
                                                   info: nil,
                                                   difficulty: .red,
                                                   status: .opened,
                                                   length: nil))
            
            TrackCellView(nordicFranceTrack: .init(activity: .snowshoe,
                                                   name: "Chalet Pin",
                                                   info: "Toto",
                                                   difficulty: .black,
                                                   status: .partiallyOpened,
                                                   length: nil))
            
            TrackCellView(nordicFranceTrack: .init(activity: .sled,
                                                   name: "Chalet Pin",
                                                   info: "Toto",
                                                   difficulty: nil,
                                                   status: .closed,
                                                   length: nil))
        }
    }
}
