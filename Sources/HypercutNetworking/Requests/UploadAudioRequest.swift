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
    
    let boundary = "Boundary-\(NSUUID().uuidString)"
    
    let fname = "hypercut-audio"
    let mimetype = "audio/mpeg"
    
    let body = NSMutableData()
    
    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
    body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
    body.append("hi\r\n".data(using: String.Encoding.utf8)!)
    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
    body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
    body.append("Content-Disposition:form-data; name=\"audio\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
    body.append(audioData)
    body.append("\r\n".data(using: String.Encoding.utf8)!)
    body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)

    
    request.httpBody = body as Data
//    request.httpBody = try? JSONEncoder().encode([
//      "file": audioData
//    ])
    
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
