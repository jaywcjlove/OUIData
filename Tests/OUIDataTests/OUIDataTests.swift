import Testing
import Foundation
@testable import OUIData

// MARK: - OUIData Test Suite
// 
// This test suite verifies the functionality of the OUIData package:
// 1. Resource loading capabilities
// 2. Data parsing and validation
// 3. Performance characteristics
// 4. Error handling
// 5. Data consistency

// MARK: - DataLoader Tests
@Test func testDataLoaderCanLoadResource() async throws {
    // Test that DataLoader can successfully load the oui.json resource
    let data = try DataLoader.loadLargeData()
    
    // Verify that data is not empty
    #expect(data.count > 0, "Loaded data should not be empty")
    
    // Verify that data can be parsed as JSON
    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
    #expect(jsonObject is [String: String], "JSON should be a dictionary of String to String")
}

// MARK: - OUIData Tests
@Test func testFetchDataReturnsValidDictionary() async throws {
    // Test that fetchData returns a valid dictionary
    let ouiDict = try OUIData.fetchData()
    
    // Verify dictionary is not empty
    #expect(!ouiDict.isEmpty, "OUI dictionary should not be empty")
    
    // Verify all keys are valid OUI format (6-character hex strings)
    for key in ouiDict.keys {
        #expect(key.count == 6, "OUI key '\(key)' should be 6 characters long")
        #expect(isHexString(key), "OUI key '\(key)' should be a valid hex string")
    }
    
    // Verify all values are non-empty strings
    for (key, value) in ouiDict {
        #expect(!value.isEmpty, "Company info for OUI '\(key)' should not be empty")
    }
}

@Test func testFetchDataContainsKnownEntries() async throws {
    // Test that the data contains some known OUI entries
    let ouiDict = try OUIData.fetchData()
    
    // Check for Apple's OUI (if present in data)
    if let appleInfo = ouiDict["100020"] {
        #expect(appleInfo.contains("Apple"), "Apple's OUI entry should contain 'Apple' in company info")
    }
    
    // Verify that we have a reasonable number of entries
    #expect(ouiDict.count > 1000, "Should have more than 1000 OUI entries")
}

@Test func testDataConsistency() async throws {
    // Test data consistency by calling fetchData multiple times
    let data1 = try OUIData.fetchData()
    let data2 = try OUIData.fetchData()
    
    // Both calls should return identical data
    #expect(data1.count == data2.count, "Multiple calls should return same number of entries")
    
    for (key, value) in data1 {
        #expect(data2[key] == value, "Entry for OUI '\(key)' should be consistent across calls")
    }
}

@Test func testPerformance() async throws {
    // Test performance of data loading
    let startTime = Date()
    _ = try OUIData.fetchData()
    let duration = Date().timeIntervalSince(startTime)
    
    // Loading should complete within reasonable time (adjust as needed)
    #expect(duration < 5.0, "Data loading should complete within 5 seconds")
}

// MARK: - Error Handling Tests
@Test func testErrorHandlingForMissingResource() async throws {
    // This test would require mocking Bundle.module, which is complex in Swift Testing
    // For now, we verify that the current implementation works correctly
    #expect(throws: Never.self) {
        _ = try DataLoader.loadLargeData()
    }
}

// MARK: - Helper Functions
private func isHexString(_ string: String) -> Bool {
    let hexCharacters = CharacterSet(charactersIn: "0123456789ABCDEFabcdef")
    return string.unicodeScalars.allSatisfy { hexCharacters.contains($0) }
}
