//
//  CutAudioRequest.swift
//  
//
//  Created by Michael Verges on 10/22/21.
//

import Foundation
import HypercutFoundation
import Combine

public struct CutAudioRequest: Request {
  
  let fileID: FileID
  let debug: Bool
  
  public init(_ fileID: FileID, debug: Bool = false) {
    self.fileID = fileID
    self.debug = debug
  }
  
  public func request(for baseURL: URL) -> URLRequest {
    var url = URL(
      string: "cut?id=\(fileID.id)", 
      relativeTo: baseURL)!
    
    if debug {
      url = URL(
        string: "cut?id=\(fileID.id)&debug=1", 
        relativeTo: baseURL)!
    }
    
    var request = URLRequest.init(url: url)
    request.httpMethod = "GET"
    
    return request
  }
  
  // 500 - error on backend
  // 400 - no ID provided
  // 406 - invalid
  // 200 - okay
  public func publisher(for baseURL: URL) -> some Publisher {
    let request = request(for: baseURL)
    return URLSession.shared
      .dataTaskPublisher(for: request)
      .tryMap { output -> Data in
        guard
          let response = output.response as? HTTPURLResponse,
          response.statusCode == 200
        else {
          fatalError("Invalid response")
        }
        return output.data
      }
      .decode(type: CutResponse.self, decoder: JSONDecoder())
  }
}

