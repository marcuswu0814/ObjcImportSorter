import Foundation
import Rainbow

public class ImportSorter {
    
    public init() {
        
    }
    
    public func sort() {
        
        // Step 1. 拿所有的`*.h` 檔案path
        let filePaths = FilePathScanner.scanFile(type: .h)
        
        // Step 2. 依序打開檔案
        
        var count = 0
        
        filePaths?.forEach({ path in
            count += 1
            if count % 100 == 0 {
                print("Count: \(count)".green)
            }
            
            guard let fileContent: String = try? path.read() else {
                return
            }
            
            // Special case for CoreData `NSManagedObject` class
            if let count = fileContent.regex("@interface.*NSManagedObject")?.count, count > 0 {
                return
            }
            
            // Step 2 - 4. 找到第一個import 的位置 (插隊，我們發現如果沒找到直接離開比較快）
            
            guard let firstPosition = FirstImportPositionFinder(with: fileContent).find() else {
                return
            }
            
            // Step 2 - 1. 找到internal import（已經獨立完成）
            let internalImports = fileContent.findInternalImport()
            
            // Step 2 - 2. 找到framework import（已經獨立完成）
            let frameworkImports = fileContent.findFrameworkImport()
            
            // Step 2 - 3. 排序，上面排完了
            
            // Step 2 - 5. 刪除所有import，得到剩餘內容
            
            let excludeImportContent = FileImportKiller(with: fileContent).kill()
            
            // Step 2 - 6. 將排序完成的import 插回
            
            let bothImportsNotEmpty = internalImports.count > 0 && frameworkImports.count > 0
            let combine = bothImportsNotEmpty ? internalImports + [""] + frameworkImports : internalImports + frameworkImports
            
            var lines = excludeImportContent.components(separatedBy: .newlines)
            lines.insert(contentsOf: combine, at: firstPosition)
            
            // Step 2 - 7. 消除最後一筆import 之後遺留的連續空白行
            
            let finalPosition = firstPosition + combine.count
            
            var countOfEmptyLine = 0
            
            for line in lines[finalPosition...] {
                if line == "" {
                    countOfEmptyLine += 1
                } else {
                    break
                }
            }
            
            let startIndex = finalPosition
            let endIndex = finalPosition + countOfEmptyLine - 1
            
            if (endIndex >= startIndex) {
                let range = Range(startIndex..<endIndex)
                lines.removeSubrange(range)
            } else {
                lines.insert("", at: startIndex)
            }
            
            try? path.write(lines.joined(separator: "\n"))
        })
    }
    
}

