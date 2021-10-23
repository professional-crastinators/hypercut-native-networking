//
//  NetworkingService.swift
//  
//
//  Created by Michael Verges on 10/22/21.
//

import Foundation
import Combine

public struct NetworkingService {
  public init(baseURL: String) {
    self.baseURL = URL(string: baseURL)!
  }
  public var baseURL: URL
}
