//
//  CommonNavigationController.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/28.
//

import Foundation
import UIKit

final class CommonNavigationController: UINavigationController {

    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            guard oldValue != statusBarStyle else { return }
            UIView.animate(withDuration: TimeInterval(0.4)) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.shadowImage = UIImage() //影を消す
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
