import Foundation

/// Represents an OUI data entry containing ID and company information.
public struct OUIEntry: Codable {
    /// Unique identifier for the OUI entry
    public let id: String
    /// Company information
    public let companyInfo: String
    
    /// Initialize an OUIEntry with id and company information
    public init(id: String, companyInfo: String) {
        self.id = id
        self.companyInfo = companyInfo
    }
}

/// Utility class responsible for loading raw data from resource files.
public struct DataLoader {
    /// Loads the oui.json file content from the Resources directory.
    /// - Returns: Raw JSON data
    /// - Throws: Error if resource is not found or reading fails
    public static func loadLargeData() throws -> Data {
        guard let url = Bundle.module.url(forResource: "oui", withExtension: "json") else {
            throw NSError(domain: "OUIData", code: 1, userInfo: [NSLocalizedDescriptionKey: "Resource not found"])
        }
        return try Data(contentsOf: url)
    }
}

/// Main structure that provides OUI data access interface.
public struct OUIData {
    /// Fetches the decoded array of OUI data entries.
    /// - Returns: Array of OUIEntry objects
    /// - Throws: Error when data loading or decoding fails
    public static func fetchData() throws -> [OUIEntry] {
        let data = try DataLoader.loadLargeData()
        let decoder = JSONDecoder()
        
        // Decode as dictionary first since JSON is in key-value format
        let ouiDict = try decoder.decode([String: String].self, from: data)
        
        // Convert dictionary to array of OUIEntry objects
        return ouiDict.map { OUIEntry(id: $0, companyInfo: $1) }.sorted { $0.id < $1.id }
    }
}
