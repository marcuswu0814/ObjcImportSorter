import Foundation
import Rainbow

struct PartDetail {
    var isFirstPart: Bool
    var isIfdefPart: Bool
    var firstImportPosition: Int
    var contentOrigin: String
    var contentWithoutImport: String
    var internalImports: [String]
    var frameworkImports: [String]
}

class ImportSortLogic {
    
    func sortInternalImports(_ imports: [String]) -> [String] {
        return imports.sorted()
    }
    
    func sortFrameworkImports(_ imports: [String]) -> [String] {
        var sortedResult = [[String]]()
        var dictionary = [String: [String]]()
        
        imports.forEach { each in
            let frameworkName = String(each.split(separator: "/")[0])
            
            if dictionary[frameworkName] != nil {
                dictionary[frameworkName]?.append(each)
            } else {
                dictionary[frameworkName] = [each]
            }
        }
        
        dictionary.sorted { $0.key < $1.key }.forEach { arg in
            sortedResult.append(arg.value.sorted())
        }
        
        return sortedResult.joined(separator: [""]).compactMap { $0 }
    }
    
}

public class ImportSorter {
    
    public init() {
        
    }
    
    public func sort(by type: FileType) {
        let filePaths = FilePathScanner.scanFile(type: type)
        
        var count = 0
        
        filePaths?.forEach({ path in
            count += 1
            if count % 100 == 0 {
                print("Count: \(count)".green)
            }
            
            guard let fileContent: String = try? path.read() else {
                return
            }
            
            guard isNotMOCFile(by: fileContent) else {
                return
            }
            
            let fileParts = filePart(by: fileContent)
            let details = partDetails(by: fileParts)
            
            let position = details.filter { $0.isFirstPart }.first?.firstImportPosition
            
            guard let firstImportPosition = position else {
                return
            }

            let allInternalImports = details.filter { !$0.isIfdefPart }.map { $0.internalImports }.flatMap { $0 }
            let allFrameworkImports = details.filter { !$0.isIfdefPart }.map { $0.frameworkImports }.flatMap { $0 }
            let allSortedFrameworkImports = ImportSortLogic().sortFrameworkImports(allFrameworkImports)
            let allSortedInternalImports = ImportSortLogic().sortInternalImports(allInternalImports)
            let noImportFileContent = details.map { $0.isIfdefPart ? $0.contentOrigin : $0.contentWithoutImport }.joined(separator: "\n\n").appending("\n\n")
            
            let bothImportsNotEmpty = allSortedFrameworkImports.count > 0 && allSortedInternalImports.count > 0
            let combine = bothImportsNotEmpty ?
                allSortedInternalImports + [""] + allSortedFrameworkImports :
                allSortedInternalImports + allSortedFrameworkImports
            
            var lines = noImportFileContent.components(separatedBy: .newlines)
            lines.insert(contentsOf: combine + [""], at: firstImportPosition)
            
            let finalImportPosition = firstImportPosition + combine.count
            var countOfEmptyLine = 0
            
            for line in lines[finalImportPosition...] {
                if line == "" {
                    countOfEmptyLine += 1
                } else {
                    break
                }
            }
            
            let startIndex = finalImportPosition
            let endIndex = finalImportPosition + countOfEmptyLine - 1
            
            if (endIndex >= startIndex) {
                let range = startIndex..<endIndex
                lines.removeSubrange(range)
            }
            
            try? path.write(lines.joined(separator: "\n"))
        })
    }
    
    func isNotMOCFile(by content: String) -> Bool {
        if let count = content.regex("@interface.*NSManagedObject")?.count, count > 0 {
            return false
        }
        
        return true
    }
    
    func partDetails(by fileParts: [String]) -> [PartDetail] {
        var result = [PartDetail]()
        
        for (index, filePart) in fileParts.enumerated() {
            let firstPosition = FirstImportPositionFinder(with: filePart).find() ?? 0
            
            let internalImports = filePart.findInternalImport()
            let frameworkImports = filePart.findFrameworkImport()
            
            let lines = filePart.components(separatedBy: .newlines)
            let isIfdefPart = lines.filter { $0.contains("#if") }.count > 0

            let excludeImportContent = FileImportKiller(with: filePart).kill().trimmingCharacters(in: .newlines)
            
            let partDetail = PartDetail(isFirstPart: index == 0,
                                        isIfdefPart: isIfdefPart,
                                        firstImportPosition: firstPosition,
                                        contentOrigin: filePart,
                                        contentWithoutImport: excludeImportContent,
                                        internalImports: internalImports,
                                        frameworkImports: frameworkImports)
            
            result.append(partDetail)
        }
        
        return result
    }
    
    func filePart(by fileContent: String) -> [String] {
        let lines = fileContent.components(separatedBy: .newlines)
        var result = [String]()
        var sectionContents = [String]()
        var isIfdefSection: Bool = false {
            didSet {
                result.append(sectionContents.joined(separator: "\n"))
                sectionContents.removeAll()
            }
        }
        
        for line in lines {
            if line.hasPrefix("#if") {
                isIfdefSection = true
                sectionContents.append(line)
            } else if line.hasPrefix("#endif") {
                sectionContents.append(line)
                isIfdefSection = false
            } else {
                sectionContents.append(line)
            }
        }
        
        result.append(sectionContents.joined(separator: "\n"))

        return result.filter { $0 != "" }.map { $0.trailingTrim(.whitespacesAndNewlines) }
    }
    
}

extension String {
    func trailingTrim(_ characterSet : CharacterSet) -> String {
        if let range = rangeOfCharacter(from: characterSet, options: [.anchored, .backwards]) {
            return String(self[..<range.lowerBound]).trailingTrim(characterSet)
        }
        return self
    }
}
