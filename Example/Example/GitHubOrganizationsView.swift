import SwiftUI

struct GitHubOrganizationsView: View {
    @State var viewModel = GitHubOrganizationsViewModel()

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
                if organizations.isEmpty {
                    ContentUnavailableView("No results", systemImage: "shippingbox")
                } else {
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
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle("GitHub Organizations")
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

#Preview {
    NavigationView {
        GitHubOrganizationsView()
    }
}
