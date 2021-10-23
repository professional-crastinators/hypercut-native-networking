//
//  UploadAudioRequest.swift
//  
//
//  Created by Michael Verges on 10/22/21.
//

import Foundation
import HypercutFoundation
import Combine

public struct UploadAudioRequest: Request {
  
  let audioData: Data
  
  public init(_ audioData: Data) {
    self.audioData = audioData
  }
  
  public func request(for baseURL: URL) -> URLRequest {
    let url = URL(
      string: "upload", 
      relativeTo: baseURL)!
    
    var request = URLRequest.init(url: url)
    request.httpMethod = "POST"
    request.httpBody = try? JSONEncoder().encode([
      "file": audioData
    ])
    
    return request
  }
  
  public func publisher(for baseURL: URL) -> some Publisher {
    let request = request(for: baseURL)
    return URLSession.shared
      .dataTaskPublisher(for: request)
      .map { $0.data }
      .decode(type: FileID.self, decoder: JSONDecoder())
  }
}
