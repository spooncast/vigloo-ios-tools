import Foundation

public protocol LifeTrackable: AnyObject {
    static var lifeConfiguration: LifeConfiguration { get }
}

// MARK: - default
public extension LifeTrackable {
    static var lifeConfiguration: LifeConfiguration {
        return LifeConfiguration(groupName: "\(type(of: self))")
    }
}

public extension LifeTrackable {
    func trackLifetime() {
        #if DEBUG
            var configuration = Self.lifeConfiguration
            configuration.name = "\(type(of: self))"

            LifeTracker.shared.track(self, configuration: configuration)

            let token = LifeToken(configuration: configuration)
            let tokenID = UnsafeRawPointer(Unmanaged.passUnretained(token).toOpaque())
            objc_setAssociatedObject(
                self,
                tokenID,
                token,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        #endif
    }
}
