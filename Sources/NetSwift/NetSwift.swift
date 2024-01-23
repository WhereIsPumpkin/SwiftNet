import Foundation

@available(iOS 13.0.0, *)
public final class NetworkManager {
    public static let shared = NetworkManager()
    
    private init() {}
    
    public enum NetworkError: Error {
        case noData
    }
    
    public func fetchDecodableData<T: Decodable>(from url: URL, responseType: T.Type) async throws -> T {
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        guard !data.isEmpty else {
            throw NetworkError.noData
        }
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
    
    public func postData<T: Encodable>(to url: URL, body: T) async throws -> (Data, URLResponse) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, response) = try await URLSession.shared.data(for: request)
        return (data, response)
    }
}

