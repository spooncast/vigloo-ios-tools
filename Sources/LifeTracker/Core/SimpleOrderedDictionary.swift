import Foundation

public struct SimpleOrderedDictionary<Key: Hashable, Value> {
    private(set) var orderedKeys: [Key] = []
    private var dict: [Key: Value] = [:]

    public var values: [Value] { orderedKeys.compactMap { dict[$0] } }
    public var isEmpty: Bool { orderedKeys.isEmpty }

    public subscript(key: Key) -> Value? {
        get { dict[key] }
        set {
            if let newValue {
                if dict[key] == nil { orderedKeys.append(key) }
                dict[key] = newValue
            } else {
                removeValue(forKey: key)
            }
        }
    }

    @discardableResult
    public mutating func removeValue(forKey key: Key) -> Value? {
        orderedKeys.removeAll { $0 == key }
        return dict.removeValue(forKey: key)
    }
}

extension SimpleOrderedDictionary: Sequence {
    public func makeIterator() -> IndexingIterator<[(Key, Value)]> {
        orderedKeys.compactMap { key in dict[key].map { (key, $0) } }.makeIterator()
    }
}
