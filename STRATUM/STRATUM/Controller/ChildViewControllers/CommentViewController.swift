//
//  CommentViewController.swift
//

import UIKit
import CloudKit

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var firstTime = Bool()
    var detailTlt2 = ""
    var detailTag2 = ""
    var detailTxt2 = ""
    var comID = ""
    var tableID = ""

    var isFilteringComm = false
    var filterArrayComm = [Commento]()
    var commentArr = [Commento]()

    let refreshControl = UIRefreshControl()
    let globalColor = UIColor(red: 77/255, green: 80/255, blue: 97/255, alpha: 1.0)

    // Controller Architetturali
    let dao = TestoDAO()
    let cancellazioneController = CancellazioneController()

    @IBOutlet var activityIndicator2: UIActivityIndicatorView!
    @IBOutlet weak var commentTableView: UITableView!

    // MARK: - UI Actions
    @IBAction func addComment2(_ sender: Any) {
        let lc3 = storyboard?.instantiateViewController(withIdentifier: "CommentEditingViewController") as! CommentEditingViewController
        lc3.editingTest = detailTxt2
        lc3.idtrad2 = comID
        self.navigationController?.pushViewController(lc3, animated: true)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        commentTableView.backgroundColor = globalColor

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 370, height: 260))
        let image = UIImage(named: "NoCommentsImage")
        imageView.image = image
        imageView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 3)

        self.commentTableView.backgroundView = UIView()
        self.commentTableView.backgroundView!.addSubview(imageView)
        self.commentTableView.backgroundView?.alpha = 0

        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.tableFooterView = UIView()

        refreshControl.tintColor = .gray

        // Ricarichiamo i dati all'avvio
        reloadComment()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCommentOfTraduction()
        checkForImage()
    }

    override func viewWillLayoutSubviews() {
        if #available(iOS 10.0, *) {
            commentTableView.refreshControl = refreshControl
            activityIndicator2.alpha = 1
            refreshControl.tintColor = .white
        } else {
            commentTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadComment), for: .valueChanged)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: "Updating", attributes: attributes)
    }

    // MARK: - Get/Delete Comment Functions
    @objc func reloadComment() {
        getCommentOfTraduction()
    }

    func getCommentOfTraduction() {
        activityIndicator2.startAnimating()

        // Uso il DAO per recuperare solo i commenti di questo testo
        dao.recuperaCommenti(per: comID) { [weak self] (commenti, error) in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.activityIndicator2.stopAnimating()

                if let error = error {
                    print("Errore recupero commenti: \(error.localizedDescription)")
                    return
                }

                if let commenti = commenti {
                    self?.commentArr = commenti
                    self?.commentTableView.reloadData()
                    self?.checkForImage()
                }
            }
        }
    }

    func checkForImage() {
        if self.commentArr.count > 0 {
            UIView.animate(withDuration: 0.5) {
                self.commentTableView.backgroundView?.alpha = 0
                self.commentTableView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 1) {
                self.commentTableView.backgroundView?.alpha = 1
                self.commentTableView.alpha = 1
            }
        }
    }

    // MARK: - TableView Setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFilteringComm ? filterArrayComm.count : commentArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell

        // Logica per mostrare l'immagine di sfondo se non ci sono commenti
        if self.commentArr.count == 0 {
            UIView.animate(withDuration: 0.5) {
                self.commentTableView.backgroundView?.alpha = 1
            }
        } else {
            self.commentTableView.backgroundView?.alpha = 0
        }

        let commentoSelezionato = isFilteringComm ? filterArrayComm[indexPath.row] : commentArr[indexPath.row]
        cell.commentTitle.text = commentoSelezionato.titolo

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc1 = storyboard?.instantiateViewController(withIdentifier: "CommentVisViewController") as! CommentVisViewController

        let commentoSelezionato = isFilteringComm ? filterArrayComm[indexPath.row] : commentArr[indexPath.row]

        vc1.selectedTxt = commentoSelezionato.testoSelezionato
        vc1.questionText = commentoSelezionato.titolo

        self.navigationController?.pushViewController(vc1, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !isFilteringComm
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let idCommento = commentArr[indexPath.row].id else { return }

            // Aggiornamento grafico immediato (Optimistic UI)
            commentArr.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
            checkForImage()

            // Cancellazione effettiva tramite il Controller dedicato
            cancellazioneController.cancellaCommentoPremuto(idCommento: idCommento) { success in
                if !success {
                    print("Errore durante l'eliminazione del commento sul cloud")
                }
            }
        }
    }
}