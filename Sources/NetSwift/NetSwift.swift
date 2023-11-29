import Foundation
 
public final class NetworkManager {
    public static let shared = NetworkManager()
 
    private init() {}
 
    public enum NetworkError: Error {
        case noData
    }

    public func fetchDecodableData<T: Decodable>(from url: URL, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
