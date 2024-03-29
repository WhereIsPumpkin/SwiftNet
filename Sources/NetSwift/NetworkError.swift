//
//  File.swift
//  
//
//  Created by Saba Gogrichiani on 23.01.24.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidResponse
    case decodingError(Error)
    case serverError(Int)
    case backendError(BackendError)
}
