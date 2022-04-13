//
//  +String.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 18/3/22.
//

import UIKit
extension String: Identifiable {
    public var id: String { self }
}
extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
extension Optional where Wrapped == String {
    var str: String {
        return self ?? "nil"
    }
}

extension CharacterSet {
    
    static let removingCharacters = CharacterSet(charactersIn: "|+*#%;:&^$@!~.,'`|_ၤ”“")
    
    static let myanmarAlphabets = CharacterSet(charactersIn: "ကခဂဃငစဆဇဈညတဒဍဓဎထဋဌနဏပဖဗဘမယရလ၀သဟဠအ").union(.whitespacesAndNewlines)
    static let myanmarCharacters2 = CharacterSet(charactersIn: "ါာိီုူေဲဳဴဵံ့း္်ျြွှ")
    static var englishAlphabets = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
    static var lineEnding = CharacterSet(charactersIn: ".?!;:။…\t")
}

extension String {
    
    var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
    
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
    
    var isWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var whiteSpace: String {
        self.appending(" ")
    }
    func prepending(_ s: String) -> String {
        s + self
    }
    var newLine: String {
        self.appending("\n")
    }
    
    var nonLineBreak: String {
        self.replacingOccurrences(of: " ", with: "\u{00a0}")
    }
}
extension String {
    
    func exclude(in set: CharacterSet) -> String {
        let filtered = unicodeScalars.lazy.filter { !set.contains($0) }
        return String(String.UnicodeScalarView(filtered))
    }
    func include(in set: CharacterSet) -> String {
        let filtered = unicodeScalars.lazy.filter { set.contains($0) }
        return String(String.UnicodeScalarView(filtered))
    }
    
    
    
    public func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    
}

extension String {
    
    func lines() -> [String] {
        var result = [String]()
        enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }
    
    func words() -> [String] {
        let comps = components(separatedBy: CharacterSet.whitespacesAndNewlines)
        return comps.filter { !$0.isWhitespace }
    }
    
    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func range() -> NSRange {
        NSRange.init(self.startIndex..<self.endIndex, in: self)
    }
}

extension NSString {
    func range() -> NSRange {
        NSRange(location: 0, length: length)
    }
}
