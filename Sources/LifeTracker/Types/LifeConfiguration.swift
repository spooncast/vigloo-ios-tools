import Foundation

public struct LifeConfiguration: Sendable {
    public private(set) var groupName: String
    internal(set) var name: String

    public init(groupName: String) {
        self.groupName = groupName
        self.name = ""
    }
}
