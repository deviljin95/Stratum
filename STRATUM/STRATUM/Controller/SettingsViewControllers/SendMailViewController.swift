//
//  SendMailViewController.swift


import Foundation
import MessageUI
class SendMailViewController: UIViewController,  MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBAction func sendMail(_ sender: Any) {
        
      if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            let alert = UIAlertController(title: "The email can not be sent", message: "Mail app is required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        return }
        // Send mail code
        
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
            
        picker.setSubject("Bug Report")
        picker.setMessageBody(body.text!, isHTML: true)
        picker.setToRecipients(["oreste_96@hotmail.it"])
            
        present(picker, animated: true, completion: nil)
    
    }
    @IBOutlet var body: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        body.delegate = self
    
    }
    
    
      // MARK: - Send Bug Mail Functions
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
            
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        body.text = textView.text

        if text == "\n" || range.location > 50 {
            textView.resignFirstResponder()
            return false
        }

        return true
    }
}
