//
//  NetworkingService.swift
//  
//
//  Created by Michael Verges on 10/22/21.
//

import Foundation
import Combine

public struct NetworkingService {
  init(baseURL: String) {
    self.baseURL = URL(string: baseURL)!
  }
  var baseURL: URL
}
