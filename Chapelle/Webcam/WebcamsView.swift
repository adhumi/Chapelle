import SwiftUI

struct WebcamsView: View {
    var body: some View {
        ScrollView {
            ForEach(WebcamLocation.allCases) { location in
                WebcamCell(location: location)
                    .padding()
            }
        }
        .background(Color("ListBackground"))
        .navigationTitle("Webcams")
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
}

struct WebcamView_Previews: PreviewProvider {
    static var previews: some View {
        WebcamsView()
    }
}
