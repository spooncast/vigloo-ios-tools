import Foundation

struct SimpleOrderedDictionary<Key: Hashable, Value> {
    private(set) var orderedKeys: [Key] = []
    private var dict: [Key: Value] = [:]

    var values: [Value] { orderedKeys.compactMap { dict[$0] } }
    var isEmpty: Bool { orderedKeys.isEmpty }

    subscript(key: Key) -> Value? {
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
    mutating func removeValue(forKey key: Key) -> Value? {
        orderedKeys.removeAll { $0 == key }
        return dict.removeValue(forKey: key)
    }
}

extension SimpleOrderedDictionary: Sendable where Key: Sendable, Value: Sendable {}

extension SimpleOrderedDictionary: Sequence {
    func makeIterator() -> IndexingIterator<[(Key, Value)]> {
        orderedKeys.compactMap { key in dict[key].map { (key, $0) } }.makeIterator()
    }
}
