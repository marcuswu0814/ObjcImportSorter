
import XCTest
import PathKit
@testable import ObjcImportSorterCore

class ImportSorterE2ETest: XCTestCase {
    
    let tempDir = Path("/tmp/ObjcImportSorterCoreTest")
    lazy var generalHeaderFilePath: Path = tempDir + Path("a.h")
    lazy var mocFilePath: Path = tempDir + Path("coreDataMOC.h")

    override func setUp() {
        super.setUp()
        
        try? tempDir.mkdir()
        
        let testContent = TestDataFactory.generalHeader
        let mocContent = TestDataFactory.mocHeader

        try? generalHeaderFilePath.write(testContent)
        try? mocFilePath.write(mocContent)

        Path.current = tempDir
    }
    
    func test__shouldSortImportAlphabetical() {
        let sut = ImportSorter()
        sut.sort()
        
        guard let fileContent: String = try? generalHeaderFilePath.read() else {
            XCTFail("File content can't be nil")
            return
        }
        
        let exceptResult = TestDataFactory.exceptGeneralHeader
        
        XCTAssertTrue(fileContent == exceptResult)
    }
    
    func test__whenFileIsCoreDataMOC__shuoldNotModifieldAnything() {
        let sut = ImportSorter()
        sut.sort()
        
        guard let fileContent: String = try? mocFilePath.read() else {
            XCTFail("File content can't be nil")
            return
        }
        
        let exceptResult = TestDataFactory.mocHeader
        
        XCTAssertTrue(fileContent == exceptResult)
    }
    
    override func tearDown() {
        try? generalHeaderFilePath.delete()
        try? mocFilePath.delete()
        try? tempDir.delete()
        
        super.tearDown()
    }
}

