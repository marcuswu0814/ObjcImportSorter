
import XCTest
import PathKit
@testable import ObjcImportSorterCore

class ImportSorterE2ETest: XCTestCase {
    
    let tempDir = Path("/tmp/ObjcImportSorterCoreTest")
    lazy var generalHeaderFilePath: Path = tempDir + Path("a.h")
    lazy var mocFilePath: Path = tempDir + Path("coreDataMOC.h")
    lazy var ifFilePath: Path = tempDir + Path("ifdefContent.h")

    override func setUp() {
        super.setUp()
        
        try? tempDir.mkdir()
        
        let testContent = TestDataFactory.generalHeader
        let mocContent = TestDataFactory.mocHeader
        let ifContent = TestDataFactory.ifdefContent

        try? generalHeaderFilePath.write(testContent)
        try? mocFilePath.write(mocContent)
        try? ifFilePath.write(ifContent)

        Path.current = tempDir
    }
    
    func test__shouldSortImportAlphabetical() {
        let sut = ImportSorter()
        sut.sort(by: .h)
        
        let fileContent: String? = try? generalHeaderFilePath.read()
        let exceptResult = TestDataFactory.exceptGeneralHeader
        
        XCTAssertEqual(fileContent, exceptResult)
    }
    
    func test__whenFileIsCoreDataMOC__shuoldNotModifieldAnything() {
        let sut = ImportSorter()
        sut.sort(by: .h)
        
        let fileContent: String? = try? mocFilePath.read()
        let exceptResult = TestDataFactory.mocHeader
        
        XCTAssertEqual(fileContent, exceptResult)
    }
    
    func test__whenFileContainsCompilerIfKeyWord__shouldSkipTheSection() {
        let sut = ImportSorter()
        sut.sort(by: .h)
        
        let fileContent: String? = try? ifFilePath.read()
        let exceptResult = TestDataFactory.exceptIfdefContent
        
        XCTAssertEqual(fileContent, exceptResult)
    }
    
    override func tearDown() {
        try? generalHeaderFilePath.delete()
        try? mocFilePath.delete()
        try? tempDir.delete()
        try? ifFilePath.delete()

        super.tearDown()
    }
}

