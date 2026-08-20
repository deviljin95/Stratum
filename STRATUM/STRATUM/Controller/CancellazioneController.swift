import Foundation
import CloudKit

public class CancellazioneController {

    let dao = TestoDAO()

    func cancellaPremuto(idTesto: CKRecord.ID, completion: @escaping (Bool) -> Void) {
        dao.cancella(idTesto: idTesto) { success in
            completion(success)
        }
    }

    func cancellaCommentoPremuto(idCommento: CKRecord.ID, completion: @escaping (Bool) -> Void) {
        dao.cancellaCommento(idCommento: idCommento) { success in
            completion(success)
        }
    }
}