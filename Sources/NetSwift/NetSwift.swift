import Foundation

@available(iOS 13.0.0, *)
public final class NetworkManager {
    public static let shared = NetworkManager()
    
    private init() {}
    
    public func fetchDecodableData<T: Decodable>(from url: URL, responseType: T.Type) async throws -> T {
        var request = URLRequest(url: url)
        // request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        guard !data.isEmpty else {
            throw NetworkError.noData
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    public func postData<T: Encodable>(to url: URL, body: T) async throws -> (Data, URLResponse) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, response) = try await URLSession.shared.data(for: request)
        return (data, response)
    }
    
    public func postDataWithHeaders<T: Encodable>(to url: URL, body: T, headers: [String: String]) async throws -> (Data, URLResponse) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(body)
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            /// let backendError = try JSONDecoder().decode(BackendError.self, from: data)
            /// throw NetworkError.backendError(backendError)
            
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        return (data, response)
    }

}

