struct DeveloperOptions {
    let isActive: Bool
}

extension DeveloperOptions {
    static let usingTinyYOLOModel = DeveloperOptions(isActive: true)
    static let usingAnchors = DeveloperOptions(isActive: true)
}
