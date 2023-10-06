public enum ValidationType {
    /// No validation.
    case none

    /// Validate success codes (only 2xx).
    case successCodes

    /// Validate success codes and redirection codes (only 2xx and 3xx).
    case successAndRedirectCodes

    /// Validate only the given status codes.
    case customCodes([Int])

    /// The list of HTTP status codes to validate.
    var statusCodes: [Int] {
        switch self {
        case .successCodes:
            return Array(200 ..< 300)
        case .successAndRedirectCodes:
            return Array(200 ..< 400)
        case let .customCodes(codes):
            return codes
        case .none:
            return Array(Int.min ..< Int.max)
        }
    }
}
