import XCTest
@testable import ARDemos

class DataFactoryTests: XCTestCase {
    
    private let dataFactory = DataFactory()
    private let jsonTestFile = "testModel"
    private var responseData: ResponseData?
    
    override func setUp() {
        super.setUp()
        responseData = dataFactory.parseJSON(fileName: jsonTestFile)
        
    }
    
    func testParsingJSONReturnsCorrectFilePath() {
        guard let model = try? getModelFromData() else {
            XCTFail("Cannot parse JSON")
            return
        }
        XCTAssertEqual(model.filePath, "/art.scnassets/")
    }
    
    func testParsingJSONReturnsCorrectFileName() {
        guard let model = try? getModelFromData() else {
            XCTFail("Cannot parse JSON")
            return
        }
        XCTAssertEqual(model.fileName, "tars-walking")
    }
    
    func testParsingJSONReturnsCorrectFileExtension() {
        guard let model = try? getModelFromData() else {
            XCTFail("Cannot parse JSON")
            return
        }
        XCTAssertEqual(model.fileExtension, ".dae")
    }
    
    func testParsingJSONReturnsCorrectNodeName() {
        guard let node = try? getNodeFromModel() else {
            XCTFail("Cannot parse JSON")
            return
        }
        
        XCTAssertEqual(node.name, "Tarsy")
    }
    
    func testParsingJSONReturnsCorrectNodeType() {
        guard let node = try? getNodeFromModel() else {
            XCTFail("Cannot parse JSON")
            return
        }
        
        XCTAssertEqual(node.type, .object)
    }
    
    func testParsingJSONReturnsCorrectLightIntensity() {
        guard let model = try? getModelFromData() else {
            XCTFail("Cannot parse JSON")
            return
        }
        
        XCTAssertEqual(model.lightSettings.intensity, 0)
    }
    
    func testParsingJSONReturnsCorrectLightShadowMode() {
        guard let model = try? getModelFromData() else {
            XCTFail("Cannot parse JSON")
            return
        }
        
        XCTAssertEqual(model.lightSettings.shadowMode, .deferred)
    }
    
    func testParsingJSONReturnsCorrectLightShadowSampleCount() {
        guard let model = try? getModelFromData() else {
            XCTFail("Cannot parse JSON")
            return
        }
        
        XCTAssertEqual(model.lightSettings.shadowSampleCount, 16)
    }
    
    func testParsingJSONReturnsCorrectPlaneWritesToDepthBuffer() {
        guard let model = try? getModelFromData() else {
            XCTFail("Cannot parse JSON")
            return
        }
        
        XCTAssertEqual(model.planeSettings.writesToDepthBuffer, true)
    }
    
    func testParsingJSONReturnsCorrectPlaneColorBufferMask() {
        guard let model = try? getModelFromData() else {
            XCTFail("Cannot parse JSON")
            return
        }
        
        XCTAssertEqual(model.planeSettings.colorBufferWriteMask.all, false)
        XCTAssertEqual(model.planeSettings.colorBufferWriteMask.red, false)
        XCTAssertEqual(model.planeSettings.colorBufferWriteMask.green, true)
        XCTAssertEqual(model.planeSettings.colorBufferWriteMask.blue, false)
        XCTAssertEqual(model.planeSettings.colorBufferWriteMask.alpha, false)
    }

    func testParsingJSONReturnsCorrectShowStatistics() {
        guard let sceneSettings = try? getSceneSettings() else {
            XCTFail("Cannot parse JSON")
            return
        }
        
        XCTAssertEqual(sceneSettings.showsStatistics, false)
    }
    
    func testParsingJSONReturnsCorrectAutoenablesDefaultLighting() {
        guard let sceneSettings = try? getSceneSettings() else {
            XCTFail("Cannot parse JSON")
            return
        }
        
        XCTAssertEqual(sceneSettings.autoenablesDefaultLighting, false)
    }
    
    func testParsingJSONReturnsCorrectAntialiasingMode() {
        guard let sceneSettings = try? getSceneSettings() else {
            XCTFail("Cannot parse JSON")
            return
        }
        
        XCTAssertEqual(sceneSettings.antialiasingMode, .multisampling4X)
    }
    
    func testParsingJSONReturnsCorrectShowDebugOptions() {
        guard let sceneSettings = try? getSceneSettings() else {
            XCTFail("Cannot parse JSON")
            return
        }
        
        XCTAssertEqual(sceneSettings.debugOptions.showPhysicsShapes, false)
        XCTAssertEqual(sceneSettings.debugOptions.showBoundingBoxes, false)
        XCTAssertEqual(sceneSettings.debugOptions.showLightInfluences, false)
        XCTAssertEqual(sceneSettings.debugOptions.showLightExtents, false)
        XCTAssertEqual(sceneSettings.debugOptions.showPhysicsFields, false)
        XCTAssertEqual(sceneSettings.debugOptions.showWireframe, false)
        XCTAssertEqual(sceneSettings.debugOptions.renderAsWireframe, false)
        XCTAssertEqual(sceneSettings.debugOptions.showSkeletons, false)
        XCTAssertEqual(sceneSettings.debugOptions.showCreases, false)
        XCTAssertEqual(sceneSettings.debugOptions.showConstraints, false)
        XCTAssertEqual(sceneSettings.debugOptions.showCameras, false)
    }
    
}

extension DataFactoryTests {
    private func getModelFromData() throws -> Model {
        guard let responseData = responseData else {
            XCTFail("Response Data can't be nil")
            throw NSError()
        }
        guard let model = responseData.models.first else {
            XCTFail("Model array should have at least one item")
            throw NSError()
        }
        
        return model
    }
    
    private func getSceneSettings() throws -> SceneSettings {
        guard let responseData = responseData else {
            XCTFail("Response Data can't be nil")
            throw NSError()
        }
        return responseData.sceneSettings
    }
    
    private func getNodeFromModel() throws -> Node {
        guard let model = try? getModelFromData() else {
            XCTFail("Cannot parse JSON")
            throw NSError()
        }
        guard let node = model.nodes.first else {
            XCTFail("Model should have at least one node")
            throw NSError()
        }
        return node
    }
}
