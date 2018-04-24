class FirstImportPositionFinder {
    
    var fileContent: String
    
    init(with fileContent: String) {
        self.fileContent = fileContent
    }
    
    func find() -> Int? {
        let lines = fileContent.components(separatedBy: .newlines)
        
        return lines.index { line -> Bool in
            return line.contains("#import ")
        }
    }
    
}
