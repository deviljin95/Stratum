//
//  ViewController.swift
//

import UIKit
import CloudKit
import Vision
import VisionKit

class ViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate, CameraViewDelegate {

    // MARK: - Proprietà
    let globalColor = UIColor(red: 77/255, green: 80/255, blue: 97/255, alpha: 1.0)
    let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)

    var scannedText1 = ""
    var cameraDelegate: CameraViewDelegate?

    var traductionArray = [Testo]()
    var filterArray = [Testo]()
    var isFiltering: Bool = false

    // Controller Architetturali
    let dao = TestoDAO()
    let cancellazioneController = CancellazioneController()

    private var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)

    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - UI Actions
    @IBAction func searchAction(_ sender: UIBarButtonItem) {
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
        searchController.searchBar.barTintColor = globalColor
        searchController.searchBar.tintColor = .white
        searchController.searchBar.backgroundColor = .green
        searchController.searchBar.isTranslucent = false
        searchController.obscuresBackgroundDuringPresentation = false

        searchController.searchBar.searchTextField.textColor = .white
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable

        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }

    @IBAction func sheetAction(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        optionMenu.addAction(UIAlertAction(title:"Type/Paste", style: .default, handler: { action in
            let lc = self.storyboard?.instantiateViewController(identifier: "AddTraductionViewController") as! AddTraductionViewController
            self.navigationController?.pushViewController(lc, animated: true)
        }))

        optionMenu.addAction(UIAlertAction(title:"Scan", style: .default, handler: { action in
            let scanVC = VNDocumentCameraViewController()
            scanVC.delegate = self
            self.present(scanVC, animated: true)
        }))

        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.delegate = self
        refreshControl.tintColor = .white
        self.tableView.backgroundView?.alpha = 0
        activityIndicatorView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = globalColor

        getAllTraduction()
        configureOCR()

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = globalColor

        // Ascolta la notifica dal AddTraductionViewController per ricaricare i dati
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTraduction), name: NSNotification.Name("NotificationID"), object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isFiltering = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 295, height: 245))
        let image = UIImage(named: "FirstWaiting")
        imageView.image = image
        imageView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 3)

        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView!.addSubview(imageView)

        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
            activityIndicatorView.alpha = 1
            activityIndicatorView.color = .white
        } else {
            tableView.addSubview(refreshControl)
        }

        refreshControl.addTarget(self, action: #selector(reloadTraduction), for: .valueChanged)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: "Updating", attributes: attributes)
    }

    // MARK: - SearchControl Functions
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count > 0) {
            isFiltering = true
            filterArray = traductionArray.filter {
                $0.titolo.range(of: searchText, options: .caseInsensitive) != nil ||
                $0.tag.range(of: searchText, options: .caseInsensitive) != nil
            }
        } else {
            isFiltering = false
            filterArray = traductionArray
        }
        self.tableView.reloadData()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isFiltering = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltering = false
        tableView.reloadData()
    }

    // MARK: - OCR Setup
    private func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([self.ocrRequest])
        } catch {
            print(error)
        }
    }

    private func configureOCR() {
        ocrRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            var ocrText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                ocrText += topCandidate.string + "\n"
            }
            DispatchQueue.main.async {
                self.scannedText1 = ocrText
            }
        }
        ocrRequest.recognitionLevel = .accurate
        ocrRequest.usesLanguageCorrection = true
    }

    func passCameraText(cameraText: String) {
        self.cameraDelegate?.passCameraText(cameraText: cameraText)
        let lc = storyboard?.instantiateViewController(identifier: "AddTraductionViewController") as! AddTraductionViewController
        lc.scannedText = cameraText
        self.navigationController?.pushViewController(lc, animated: true)
    }

    // MARK: - Gestione Dati (DAO e Controllers)
    @objc func reloadTraduction() {
        getAllTraduction()
    }

    func getAllTraduction() {
        activityIndicatorView.startAnimating()

        // Uso il DAO per recuperare i dati, separando la logica dal ViewController
        dao.recuperaTutti { [weak self] (testi, error) in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.activityIndicatorView.stopAnimating()

                if let error = error {
                    print("Errore nel recupero dati: \(error.localizedDescription)")
                    return
                }

                if let testi = testi {
                    self?.traductionArray = testi
                    self?.tableView.reloadData()
                    self?.checkForMainImage()
                }
            }
        }
    }

    func checkForMainImage() {
        if self.traductionArray.count > 0 {
            UIView.animate(withDuration: 0.3) {
                self.tableView?.backgroundView?.alpha = 0
                self.tableView?.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.tableView?.backgroundView?.alpha = 1
                self.tableView?.alpha = 1
            }
        }
    }
}

// MARK: - TableView DataSource & Delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filterArray.count : traductionArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell

        let testoSelezionato = isFiltering ? filterArray[indexPath.row] : traductionArray[indexPath.row]

        cell.tableTitle.text = testoSelezionato.titolo
        cell.tableTag.text = testoSelezionato.tag

        if !(cell.tableTag.text?.hasPrefix("#") ?? true) {
            cell.tableTag.text?.insert("#", at: cell.tableTag.text!.startIndex)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let masterViewController = storyboard?.instantiateViewController(withIdentifier: "MasterViewController") as! MasterViewController

        let testoSelezionato = isFiltering ? filterArray[indexPath.row] : traductionArray[indexPath.row]

        masterViewController.textTitleMaster = testoSelezionato.titolo
        masterViewController.textDetailMaster = testoSelezionato.tag
        masterViewController.secondTextMaster = testoSelezionato.areaTesto
        masterViewController.idtrad = testoSelezionato.id?.recordName

        searchController.isActive = false
        self.navigationController?.pushViewController(masterViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !isFiltering
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let idTesto = traductionArray[indexPath.row].id else { return }

            // Aggiornamento grafico immediato (Optimistic UI)
            traductionArray.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
            checkForMainImage()

            // Cancellazione effettiva tramite il Controller dedicato
            cancellazioneController.cancellaPremuto(idTesto: idTesto) { success in
                if !success {
                    print("Errore durante l'eliminazione sul cloud")
                    // Qui potresti ricaricare la tabella in caso di errore
                }
            }
        }
    }
}

// MARK: - VNDocumentCameraViewControllerDelegate
extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }

        processImage(scan.imageOfPage(at: 0))
        controller.dismiss(animated: true, completion: {
            self.passCameraText(cameraText: self.scannedText1)
        })
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true)
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
}