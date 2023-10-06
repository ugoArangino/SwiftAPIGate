struct Organization: Codable, Equatable, Identifiable {
    let id: Int
    let login: String
    let description: String?
}
