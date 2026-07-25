//
//  Const.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/28.
//


import Foundation
import UIKit

enum LayoutBreakpoint {
    static let compactThreshold: CGFloat = 500

    static var compactSideLength: CGFloat {
        return min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }

    static func isCompact(sideLength: CGFloat) -> Bool {
        return sideLength < compactThreshold
    }

    static var isCompactScreen: Bool {
        return isCompact(sideLength: compactSideLength)
    }
}

enum AppEnvironment {
    case production
    case development
    
    static var current: AppEnvironment {
        #if DEVELOPMENT
        return .development
        #else
        return .production
        #endif
    }
}

enum API {
    // guest（POST系: set/delete/postCalc）
    static var guestBaseURL: String {
        switch AppEnvironment.current {
        case .production:  return "https://vl1sxpjk81.execute-api.ap-northeast-1.amazonaws.com/guest/"
        case .development: return "https://wh9jluh066.execute-api.ap-northeast-1.amazonaws.com/dev-visitor/"
        }
    }
    // guest（GET系: getGuestInfo） productionもいずれはguestBaseURLと統合予定
    static var getGuestBaseURL: String {
        switch AppEnvironment.current {
        case .production:  return "https://vl1sxpjk81.execute-api.ap-northeast-1.amazonaws.com/guest/"
        case .development: return "https://wh9jluh066.execute-api.ap-northeast-1.amazonaws.com/dev-visitor/"
        }
    }
    // guest（GET系: calcTotalAmount / reservation） productionもいずれはguestBaseURLと統合予定
    static var calcGuestBaseURL: String {
        switch AppEnvironment.current {
        case .production:  return "https://vl1sxpjk81.execute-api.ap-northeast-1.amazonaws.com/guest/"
        case .development: return "https://wh9jluh066.execute-api.ap-northeast-1.amazonaws.com/dev-visitor/"
        }
    }
    // guest（totalAmountList） productionもいずれはguestBaseURLと統合予定
    static var totalAmountBaseURL: String {
        switch AppEnvironment.current {
        case .production:  return "https://vl1sxpjk81.execute-api.ap-northeast-1.amazonaws.com/guest/"
        case .development: return "https://wh9jluh066.execute-api.ap-northeast-1.amazonaws.com/dev-visitor/"
        }
    }
    // cat（getCatInfo）
    static var catBaseURL: String {
        switch AppEnvironment.current {
        case .production:  return "https://dqybwwjq2d.execute-api.ap-northeast-1.amazonaws.com/cat/"
        case .development: return "https://1rq9odbeaa.execute-api.ap-northeast-1.amazonaws.com/dev-cat/"
        }
    }
    // cat（getMedicalHistory） productionもいずれはcatBaseURLと統合予定
    static var medicalHistoryBaseURL: String {
        switch AppEnvironment.current {
        case .production:  return "https://dqybwwjq2d.execute-api.ap-northeast-1.amazonaws.com/cat/"
        case .development: return "https://1rq9odbeaa.execute-api.ap-northeast-1.amazonaws.com/dev-cat/"
        }
    }
    // cat（setMedicalHistory） productionもいずれはcatBaseURLと統合予定
    static var setMedicalHistoryBaseURL: String {
        switch AppEnvironment.current {
        case .production:  return "https://dqybwwjq2d.execute-api.ap-northeast-1.amazonaws.com/cat/"
        case .development: return "https://1rq9odbeaa.execute-api.ap-northeast-1.amazonaws.com/dev-cat/"
        }
    }
    // sales
    static var salesBaseURL: String {
        switch AppEnvironment.current {
        case .production:  return "https://s4e53ii5yc.execute-api.ap-northeast-1.amazonaws.com/sales/"
        case .development: return "https://27ybpzdma0.execute-api.ap-northeast-1.amazonaws.com/dev-sales/"
        }
    }
    // denomination productionもいずれはcloseBaseURLと統合予定
    static var denominationBaseURL: String {
        switch AppEnvironment.current {
        case .production:  return "https://k85cdkqe5k.execute-api.ap-northeast-1.amazonaws.com/close/"
        case .development: return "https://iv2llpr5n1.execute-api.ap-northeast-1.amazonaws.com/dev-close/"
        }
    }
    // close（checkTotalAmount）
    static var closeBaseURL: String {
        switch AppEnvironment.current {
        case .production:  return "https://k85cdkqe5k.execute-api.ap-northeast-1.amazonaws.com/close/"
        case .development: return "https://iv2llpr5n1.execute-api.ap-northeast-1.amazonaws.com/dev-close/"
        }
    }
    // care-info
    static var careInfoBaseURL: String {
        switch AppEnvironment.current {
        case .production:  return "https://au0rfnsgi3.execute-api.ap-northeast-1.amazonaws.com/care-info/"
        case .development: return "https://d630q9615e.execute-api.ap-northeast-1.amazonaws.com/dev-care/"
        }
    }
}
