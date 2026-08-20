import Foundation

public class InserimentoController {

    let dao = TestoDAO()

    func salvaPremuto(titolo: String, tag: String, testo: String, data: Date, completion: @escaping (Bool, String?) -> Void) {

        // 2.1.1: <<CREATE>> Testo
        let nuovoTesto = Testo(titolo: titolo, tag: tag, areaTesto: testo, dataInserimento: data)

        // Salvataggio tramite DAO
        dao.salva(testo: nuovoTesto) { success, error in
            if success {
                completion(true, nil)
            } else {
                completion(false, error?.localizedDescription)
            }
        }
    }

    func salvaPremuto(testoSottolineato: String, testoCommento: String, idTestoPadre: String, data: Date, completion: @escaping (Bool, String?) -> Void) {

        // 3.1.1: <<CREATE>> Commento
        let nuovoCommento = Commento(idTesto: idTestoPadre, titolo: testoCommento, testoSelezionato: testoSottolineato, dataInserimento: data)

        // Salvataggio tramite DAO
        dao.salvaCommento(commento: nuovoCommento) { success, error in
            if success {
                completion(true, nil)
            } else {
                completion(false, error?.localizedDescription)
            }
        }
    }
}