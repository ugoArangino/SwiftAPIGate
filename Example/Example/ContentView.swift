import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            GitHubOrganizationsView()
                .tabItem {
                    Label("GitHub Organizations", systemImage: "circle.hexagongrid.fill")
                }

            HTTPBinPOSTView()
                .tabItem {
                    Label("httpbin.org POST", systemImage: "server.rack")
                }
        }
    }
}

#Preview {
    ContentView()
}
