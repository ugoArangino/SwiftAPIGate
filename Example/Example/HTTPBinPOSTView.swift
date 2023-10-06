import SwiftUI

struct HTTPBinPOSTView: View {
    @State var viewModel = HTTPBinPOSTViewModel()

    var body: some View {
        Form {
            Section {
                Button("POST", action: viewModel.post)
            }

            Section {
                if let error = viewModel.error {
                    ContentUnavailableView("Error", systemImage: "ant", description: Text(error.localizedDescription))
                } else if let response = viewModel.response {
                    Text(response.statusCode.description)
                        .bold()
                    if let text = String(data: response.data, encoding: .utf8) {
                        Text(text)
                            .font(.caption)
                    }
                }
            }
        }
        .navigationTitle("httpbin.org POST")
    }
}

#Preview {
    NavigationView {
        HTTPBinPOSTView()
    }
}
