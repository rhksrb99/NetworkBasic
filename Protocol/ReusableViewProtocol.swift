//
//  ReusableViewProtocol.swift
//  NetworkBasic
//
//  Created by 박관규 on 2022/08/02.
//

import UIKit

// 프로토콜을 이용한 화면 전환을 하기 위한 과정
// identifier를 각각의 컨트롤러에 지정해줄 수 있다.
protocol ReusableViewProtocol {
    static var reuseIdentifier: String { get }
}

extension UIViewController: ReusableViewProtocol { //extension 저장 프로퍼티 불가능
    static var reuseIdentifier: String { // 연산 프로퍼티 get만 사용한다면 get 생략가능
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableViewProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
