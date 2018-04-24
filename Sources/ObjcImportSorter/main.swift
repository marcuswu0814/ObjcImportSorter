import Commander
import ObjcImportSorterCore

Group {
    
    $0.command("sort") {
//        let allPaths = FilePathScanner.scanFile(type: .h)
        
        ImportSorter().sort()
//        print("Test")
    }
    
}.run()
