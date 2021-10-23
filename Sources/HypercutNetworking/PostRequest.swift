//
//  PostRequest.swift
//  
//
//  Created by Michael Verges on 10/22/21.
//

import Foundation
import Combine

public protocol Request {
  associatedtype Publisher
  func request(for baseURL: URL) -> URLRequest
  func publisher(for baseURL: URL) -> Publisher
}
