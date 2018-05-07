import Commander
import ObjcImportSorterCore
import Rainbow

Group {
    
    $0.command("sort") { (fileType: String) in
        guard let fileType = FileType(rawValue: "*." + fileType) else {
            print("Wrong given type".red)
            return
        }
        
        ImportSorter().sort(by: fileType)
    }
    
}.run()
