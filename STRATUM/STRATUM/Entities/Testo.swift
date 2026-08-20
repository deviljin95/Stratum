import Foundation
import CloudKit

public class Testo {
    var id: CKRecord.ID?
    var titolo: String
    var tag: String
    var areaTesto: String
    var dataInserimento: Date

    // Inizializzatore basato sul diagramma delle classi
    init(id: CKRecord.ID? = nil, titolo: String, tag: String, areaTesto: String, dataInserimento: Date = Date()) {
        self.id = id
        self.titolo = titolo
        self.tag = tag
        self.areaTesto = areaTesto
        self.dataInserimento = dataInserimento
    }
}