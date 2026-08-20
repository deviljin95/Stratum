import Foundation
import CloudKit

public class Commento {
    var id: CKRecord.ID?
    var idTesto: String // Riferimento al testo padre (idtrad)
    var titolo: String
    var testoSelezionato: String // La parte di testo evidenziata
    var dataInserimento: Date

    init(id: CKRecord.ID? = nil, idTesto: String, titolo: String, testoSelezionato: String, dataInserimento: Date = Date()) {
        self.id = id
        self.idTesto = idTesto
        self.titolo = titolo
        self.testoSelezionato = testoSelezionato
        self.dataInserimento = dataInserimento
    }
}