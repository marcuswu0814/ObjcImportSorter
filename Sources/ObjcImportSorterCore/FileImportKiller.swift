class FileImportKiller {
    
    var fileContent: String
    
    init(with fileContent: String) {
        self.fileContent = fileContent
    }
    
    func kill() -> String {
        let lines = fileContent.components(separatedBy: .newlines)

        let noImportLines = lines.filter { !$0.contains("#import ") }
        
        return noImportLines.joined(separator: "\n")
    }
    
}
