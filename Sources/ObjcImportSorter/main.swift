import Commander
import ObjcImportSorterCore

Group {
    
    $0.command("sort") {
        ImportSorter().sort(by: .h)
    }
    
}.run()
