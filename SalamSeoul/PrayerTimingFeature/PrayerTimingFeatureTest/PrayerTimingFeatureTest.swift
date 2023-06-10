//
//  PrayerTimingFeatureTest.swift
//  PrayerTimingFeatureTest
//
//  Created by 추현호 on 2023/05/09.
//

import XCTest
import ComposableArchitecture
@testable import SalamSeoul

final class PrayerTimingFeatureTest: XCTestCase {
    func testFetchCalendarItem() {
    }
}

import Foundation

class MockURLProtocol: URLProtocol {
  // request를 받아서 mock response(HTTPURLResponse, Data?)를 넘겨주는 클로저 생성
  static var requestHandler: ((URLRequest) -> (HTTPURLResponse?, Data?, Error?))?
  
  // 매개변수로 받는 request를 처리할 수 있는 프로토콜 타입인지 검사하는 함수
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  // Request를 canonical(표준)버전으로 반환하는데,
  // 거의 매개변수로 받은 request를 그래도 반환
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  // test case별로 mock response를 생성하고,
  // URLProtocolClient로 해당 response를 보내는 부분
  override func startLoading() {
    guard let handler = MockURLProtocol.requestHandler else {
      fatalError()
    }
    
    // request를 매개변수로 전달하여 handler를 호출하고, 반환되는 response와 data, error를 저장
    let (response, data, error) = handler(request)
    
    // 저장한 error를 client에게 전달
    if let error = error {
      client?.urlProtocol(self, didFailWithError: error)
    }
    
    // 저장한 response를 client에게 전달
    if let response = response {
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    }
    
    // 저장한 data를 client에게 전달
    if let data = data {
      client?.urlProtocol(self, didLoad: data)
    }
    
    // request가 완료되었음을 알린다
    client?.urlProtocolDidFinishLoading(self)
  }
  
  override func stopLoading() {
    // request가 취소되거나 완료되었을 때 호출되는 부분
  }
}
