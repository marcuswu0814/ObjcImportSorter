import Foundation

extension String {
    
    public func regex(_ pattern: String) -> [String]? {
        
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch {
            return nil
        }
    }

    public func findInternalImport() -> [String] {
        let lines = self.components(separatedBy: .newlines)
        
        let result = lines.filter {
            guard let matchCount = $0.regex("#import {0,}\".*\"")?.count else {
                return false
            }
            
            let isMatch = matchCount > 0
            
            return isMatch
        }.map { string -> String in
            guard let range = string.range(of: "\".*\"", options: .regularExpression, range: nil, locale: nil) else {
                return ""
            }
                
            return String(string[range].dropLast().dropFirst())
        }.map { "#import \"\($0)\"" }
        
        return result
    }
    
    public func findFrameworkImport() -> [String] {
        let lines = self.components(separatedBy: .newlines)

        let result = lines.filter {
            guard let matchCount = $0.regex("#import {0,}<.*>")?.count else {
                return false
            }
            
            let isMatch = matchCount > 0
            
            return isMatch
        }.map { string -> String in
            guard let range = string.range(of: "<.*>", options: .regularExpression, range: nil, locale: nil) else {
                return ""
            }
            
            return String(string[range].dropLast().dropFirst())
        }.map { "#import <\($0)>" }
        
       return result
    }
    
}

