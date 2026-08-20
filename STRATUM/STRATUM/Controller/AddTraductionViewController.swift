//
//  AddTraductionViewController.swift
//

import Foundation
import UIKit
import CloudKit

class AddTraductionViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    struct StructTraduction {
        var id: CKRecord.ID?
        var title: String
        var tag: String
        var text: String
    }

    let globalColor = UIColor(red: 77/255, green: 80/255, blue: 97/255, alpha: 1.0)
    let backColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    var traductionArray = [StructTraduction]()
    var scannedText = ""
    var item = CKRecord(recordType: "Traduction")

    let inserimentoController = InserimentoController()

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var textLabel: UITextView!
    @IBOutlet weak var tagLabel: UITextField!


    // MARK: - Nuova Funzione di Salvataggio Pulita (MVC/DAO)
    @IBAction func saveNewTraduction(_ sender: Any) {

        // Controllo campi vuoti
        if titleLabel.text == "" || textLabel.text == "" || tagLabel.text == "" {
            let alert = UIAlertController(title: "Warning", message: "Check if all fields are correct", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        // Mostra l'indicatore di caricamento
        let alert = UIAlertController(title: NSLocalizedString("Uploading to iCloud", comment: ""), message: nil, preferredStyle: .alert)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.center = CGPoint(x: 30, y: 30)
        activityIndicator.startAnimating()
        alert.view.addSubview(activityIndicator)
        self.present(alert, animated: true, completion: nil)

        // Usiamo il Controller per salvare
        inserimentoController.salvaPremuto(titolo: titleLabel.text!, tag: tagLabel.text!, testo: textLabel.text!, data: Date()) { [weak self] success, errorMessage in

            // Torniamo sul thread principale per aggiornare la UI
            DispatchQueue.main.async {
                alert.dismiss(animated: true) {
                    if success {
                        // Se ha successo, notifichiamo la Homepage (ViewController) per ricaricare i dati
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)

                        // Torniamo indietro alla schermata precedente in modo fluido
                        self?.navigationController?.popViewController(animated: true)
                    } else {
                        // Gestione dell'errore (se CloudKit fallisce o non c'è rete)
                        let errorAlert = UIAlertController(title: "Errore", message: errorMessage ?? "Impossibile salvare il testo. Riprova.", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self?.present(errorAlert, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    // MARK: - Funzioni originali della UI
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = globalColor
        titleLabel.backgroundColor = backColor
        tagLabel.backgroundColor = backColor
        textLabel.backgroundColor = backColor

        textLabel.layer.borderWidth = 1
        titleLabel.layer.borderWidth = 1
        tagLabel.layer.borderWidth = 1

        titleLabel.delegate = self
        textLabel.delegate = self
        tagLabel.delegate = self

        self.textLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.textLabel.layer.borderWidth = 0.5
        self.textLabel.textColor = .black

        titleLabel.becomeFirstResponder()

        titleLabel.addDoneButton(myAction: #selector(self.titleLabel.resignFirstResponder))
        tagLabel.addDoneButton(myAction: #selector(self.tagLabel.resignFirstResponder))
        textLabel.addDoneButton2(myAction: #selector(self.textLabel.resignFirstResponder))
        textLabel.text = scannedText
    }

    // MARK: - Funzioni originali CloudKit Share
    func fetchShare(_ cloudKitShareMetadata: CKShare.Metadata){
        let op = CKFetchRecordsOperation(recordIDs: [cloudKitShareMetadata.rootRecordID])

        op.perRecordCompletionBlock = { record, _, error in
            guard error == nil, record != nil else{
                print("error \(error?.localizedDescription ?? "")")
                return
            }
            DispatchQueue.main.async {
                self.item = record!
            }
        }
        op.fetchRecordsCompletionBlock = { _, error in
            guard error != nil else{
                print("error \(error?.localizedDescription ?? "")")
                return
            }
        }
        CKContainer.default().sharedCloudDatabase.add(op)
    }

    func displaySignUpPendingAlert() -> UIAlertController {
        //create an alert controller
        let pending = UIAlertController(title: "Creating New User", message: nil, preferredStyle: .alert)

        //create an activity indicator
        let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        //add the activity indicator as a subview of the alert controller's view
        pending.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
        indicator.startAnimating()

        self.present(pending, animated: true, completion: nil)

        return pending
    }

}

// MARK: - Extensions originali
extension UITextField {
    func addDoneButton(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myAction)

        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)

        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }
}

extension UITextView {
    func addDoneButton2(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myAction)

        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)

        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }
}