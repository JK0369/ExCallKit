//
//  ViewController.swift
//  ExVoIP
//
//  Created by Jake.K on 2022/02/07.
//

import UIKit
import CallKit

class ViewController: UIViewController {
  let provider = CXProvider(configuration: CXProviderConfiguration())
  private let callController = CXCallController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    // 발신자 표시, 수신 차단 기능 활성화
    CXCallDirectoryManager.sharedInstance
      .reloadExtension(withIdentifier: "com.ExVoIP.CallDirectory") { error in
        print(error ?? "")
      }
  }
  
  @IBAction func didTapButton(_ sender: Any) {
    self.receiving()
  }
  
  @IBAction func didTapOutgoingButton(_ sender: Any) {
    self.outgoing()
  }
  
  // 전화 받기
  private func receiving() {
    provider.setDelegate(self, queue: nil)
    
    // TODO: UUID값과 update값은 PushKit에서 넘어온(pushRegistry 메소드) 정보를 이용하여 사용
    // PushKit 포스팅 글 참고: https://ios-development.tistory.com/875
    let update = CXCallUpdate()
    update.remoteHandle = CXHandle(type: .generic, value: "Jake")
    provider.reportNewIncomingCall(with: UUID(), update: update) { error in
      print(error ?? "")
    }
  }
  
  // 전화 하기
  private func outgoing() {
    let uuid = UUID()
    let handle = CXHandle(type: .emailAddress, value: "palatable77@gmail.com")
    
    let startCallAction = CXStartCallAction(call: uuid, handle: handle)
    let transaction = CXTransaction(action: startCallAction)
    self.callController.request(transaction) { error in
      print(error ?? "")
    }
  }
}

extension ViewController: CXProviderDelegate {
  func providerDidReset(_ provider: CXProvider) {
  }
  
  func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
    action.fulfill()
  }
  
  // 전화 받기 델리게이트 메소드
  func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
    action.fulfill()
  }
  
  // 전화 걸기 델리게이트 메소드
  func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
    action.fulfill()
  }
}
