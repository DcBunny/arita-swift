//
//  String+ONNetworkingMethods.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/7.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

extension String {
    mutating func ON_appendURLRequest(_ request: URLRequest) {
        self.append("\n\nHTTP URL :\n\t\(String(describing: request.url))")
        if request.allHTTPHeaderFields != nil {
            self.append("\n\nHTTP Header: \n\(request.allHTTPHeaderFields!)")
        } else {
            self.append("\t\t\t\t\tN/A")
        }
        if let body = request.httpBody {
            self.append("\n\nHTTP Body :\n\t\(String(describing: String(data: body, encoding: String.Encoding.utf8)))")
        }
    }
    
    func ON_defaultValue() -> String {
        if self.ON_isEmpty() {
            return "N/A"
        } else {
            return self
        }
    }
    
    func ON_isEmpty() -> Bool {
        return (self.characters.count == 0)
    }
}
