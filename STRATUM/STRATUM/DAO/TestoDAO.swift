import Foundation
import CloudKit

public class TestoDAO {

    let privateDatabase = CKContainer.default().privateCloudDatabase

    // MARK: - Funzioni per il Testo
    func salva(testo: Testo, completion: @escaping (Bool, Error?) -> Void) {
        let record = CKRecord(recordType: "Traduction")
        record.setValue(testo.titolo, forKey: "title")
        record.setValue(testo.tag, forKey: "tag")
        record.setValue(testo.areaTesto, forKey: "text")
        record.setValue(testo.dataInserimento, forKey: "creationDate")

        privateDatabase.save(record) { (savedRecord, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        }
    }

    func cancella(idTesto: CKRecord.ID, completion: @escaping (Bool) -> Void) {
        privateDatabase.delete(withRecordID: idTesto) { (deletedID, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Errore cancellazione testo: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }

    // MARK: - Funzioni per i Commenti (CommentoDAO integrato)
    func salvaCommento(commento: Commento, completion: @escaping (Bool, Error?) -> Void) {
        let record = CKRecord(recordType: "Comment")
        record.setValue(commento.titolo, forKey: "comment")
        record.setValue(commento.testoSelezionato, forKey: "text")
        record.setValue(commento.idTesto, forKey: "idtrad")

        privateDatabase.save(record) { (savedRecord, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        }
    }

    // MARK: - Recupero Dati
    func recuperaTutti(completion: @escaping ([Testo]?, Error?) -> Void) {
        let query = CKQuery(recordType: "Traduction", predicate: NSPredicate(value: true))
        // Ordiniamo per data di creazione, dal più recente
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            var testiScaricati = [Testo]()

            // Usiamo il casting sicuro (as? String) invece del force unwrap (as! String)
            // per evitare crash istantanei se un campo è vuoto sul database.
            records?.forEach { record in
                let t = Testo(
                    id: record.recordID,
                    titolo: record.value(forKey: "title") as? String ?? "Senza Titolo",
                    tag: record.value(forKey: "tag") as? String ?? "",
                    areaTesto: record.value(forKey: "text") as? String ?? ""
                // creationDate è gestito in automatico da CloudKit
                )
                testiScaricati.append(t)
            }

            completion(testiScaricati, nil)
        }
    }

    func cancellaCommento(idCommento: CKRecord.ID, completion: @escaping (Bool) -> Void) {
        privateDatabase.delete(withRecordID: idCommento) { (deletedID, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Errore cancellazione commento: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }

    // MARK: - Recupero Commenti
    func recuperaCommenti(per idTesto: String, completion: @escaping ([Commento]?, Error?) -> Void) {
        // Query per cercare solo i commenti associati a questo specifico testo
        let predicate = NSPredicate(format: "idtrad == %@", idTesto)
        let query = CKQuery(recordType: "Comment", predicate: predicate)

        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            var commentiScaricati = [Commento]()
            records?.forEach { record in
                let c = Commento(
                    id: record.recordID,
                    idTesto: record.value(forKey: "idtrad") as? String ?? "",
                    titolo: record.value(forKey: "comment") as? String ?? "",
                    testoSelezionato: record.value(forKey: "text") as? String ?? ""
                )
                commentiScaricati.append(c)
            }

            completion(commentiScaricati, nil)
        }
    }
}