import SwiftUI

struct ContentView: View {
    @State var viewModel = ViewModel()

    private var modeBinding: Binding<FetchMode> {
        .init {
            viewModel.mode
        } set: { newValue in
            viewModel.setMode(newValue)
        }
    }

    var body: some View {
        VStack {
            Picker("Mode", selection: modeBinding) {
                ForEach(FetchMode.allCases, id: \.rawValue) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            if let error = viewModel.error {
                ContentUnavailableView("Error", systemImage: "ant", description: Text(error.localizedDescription))
            } else if let organizations = viewModel.organizations {
                List(organizations) { organization in
                    VStack(alignment: .leading) {
                        Text(organization.login)
                            .bold()
                        if let description = organization.description?.emptyErased {
                            Text(description)
                                .font(.caption)
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

private extension String {
    var emptyErased: String? {
        guard !isEmpty else {
            return nil
        }
        return self
    }
}
