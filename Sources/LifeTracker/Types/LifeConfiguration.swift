import Foundation

public struct LifeConfiguration {
    public private(set) var groupName: String
    public internal(set) var name: String

    public init(groupName: String) {
        self.groupName = groupName
        self.name = ""
    }
}
