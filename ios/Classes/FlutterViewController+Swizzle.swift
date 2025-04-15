import UIKit
import Flutter

@discardableResult
func swizzleFlutterViewController() -> Bool {
  swizzleFlutterViewControllerOnce
}

private let swizzleFlutterViewControllerOnce: Bool = ({
  let type = FlutterViewController.self
  return [
    exchangeSelectors(type, NSSelectorFromString("keyboardWillChangeFrame:"), #selector(FlutterViewController.cik_keyboardWillChangeFrame)),
    exchangeSelectors(type, NSSelectorFromString("keyboardWillBeHidden:"), #selector(FlutterViewController.cik_keyboardWillBeHidden)),
    exchangeSelectors(type, NSSelectorFromString("keyboardWillShowNotification:"), #selector(FlutterViewController.cik_keyboardWillShowNotification)),
  ].contains(true)
})()

extension FlutterViewController {
    @objc
    dynamic fileprivate func cik_keyboardWillChangeFrame(_ notification: Notification?) {
      guard let notification = notification else {
        return cik_keyboardWillChangeFrame(nil)
      }
      let adjusted = KeyboardManager.shared.adjustKeyboardNotification(notification)
      cik_keyboardWillChangeFrame(adjusted)
    }

    @objc
    dynamic fileprivate func cik_keyboardWillBeHidden(_ notification: Notification?) {
      guard let notification = notification else {
        return cik_keyboardWillBeHidden(nil)
      }
      cik_keyboardWillBeHidden(KeyboardManager.shared.adjustKeyboardNotification(notification))
    }

    @objc
    dynamic fileprivate func cik_keyboardWillShowNotification(_ notification: Notification?) {
      guard let notification = notification else {
        return cik_keyboardWillShowNotification(nil)
      }
      cik_keyboardWillShowNotification(KeyboardManager.shared.adjustKeyboardNotification(notification))
    }

}

