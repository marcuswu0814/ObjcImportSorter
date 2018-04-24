import Foundation
import PathKit

public enum FileType: String {
    case m = "*.m"
    case h = "*.h"
}

public class FilePathScanner {
    
    public static func scanFile(type fileType: FileType) -> [Path]? {
        let allPaths = Bash.run("find", arguments: [Path.current.string, "-name", "\(fileType.rawValue)"])?
                            .split(separator: "\n")
                            .map { Path(String($0)) }

        return allPaths
    }
    
}
