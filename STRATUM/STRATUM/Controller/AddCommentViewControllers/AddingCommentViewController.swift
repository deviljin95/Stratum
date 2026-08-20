//
//  AddingCommentViewController.swift
//

import Foundation
import UIKit
import CloudKit

public class AddingCommentViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var editedText = ""
    var idtrad3 = ""

    // Controller
    let inserimentoController = InserimentoController()

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var selectedText: UITextView!

    @IBAction func saveComment(_ sender: Any) {
        if selectedText.text == "" || commentTextField.text == "" {
            let alert = UIAlertController(title: "Warning", message: "Check if all fields are corrected", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        let alert = UIAlertController(title: NSLocalizedString("Uploading to iCloud", comment: ""), message: nil, preferredStyle: .alert)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.center = CGPoint(x: 30, y: 30)
        activityIndicator.startAnimating()
        alert.view.addSubview(activityIndicator)
        self.present(alert, animated: true, completion: nil)

        inserimentoController.salvaPremuto(testoSottolineato: selectedText.text!, testoCommento: commentTextField.text!, idTestoPadre: idtrad3, data: Date()) { [weak self] success, errorMessage in

            DispatchQueue.main.async {
                alert.dismiss(animated: true) {
                    if success {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
                        self?.backTwo()
                    } else {
                        let errorAlert = UIAlertController(title: "Errore", message: errorMessage ?? "Impossibile salvare", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self?.present(errorAlert, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        selectedText.delegate = self
        selectedText.text = editedText

        commentTextField.delegate = self
        commentTextField.becomeFirstResponder()
        commentTextField.textColor = .black
        commentTextField.addDoneButtonToKeyboard2(myAction: #selector(self.commentTextField.resignFirstResponder))
    }
}