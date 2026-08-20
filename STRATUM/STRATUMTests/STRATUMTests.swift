//
//  COPERATIOTests.swift
//  COPERATIOTests
//

import XCTest
// Assicurati che il nome "Stratum" coincida con il nome reale del tuo Target in Xcode.
// Se il target si chiama COPERATIO, lascia @testable import COPERATIO
@testable import Stratum

class COPERATIOTests: XCTestCase {

    var sut: SendMailViewController!
    var textViewTest: UITextView!

    override func setUpWithError() throws {
        // Viene chiamato prima di ogni test. Inizializziamo il ViewController e la TextView
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: "SendMailViewController") as? SendMailViewController
        sut.loadViewIfNeeded()

        textViewTest = UITextView()
    }

    override func tearDownWithError() throws {
        // Viene chiamato alla fine di ogni test. Svuotiamo la memoria
        sut = nil
        textViewTest = nil
    }

    // MARK: - Unit Tests (Capitolo 5.1.1 della Tesi)

    // Test 1: CE3 (Non Valida) - Inserimento oltre i 50 caratteri
    func testRangeFalse() throws {
        // Simuliamo un range maggiore di 50 (es. 51)
        let range = NSRange(location: 51, length: 0)
        let stringaLunga = "prova6prova6prova6prova6prova6prova6prova6prova6"

        // Chiamiamo il metodo del delegate (che nella tesi chiami checktextView)
        let value = sut.textView(textViewTest, shouldChangeTextIn: range, replacementText: stringaLunga)

        // Verifichiamo che restituisca FALSE
        XCTAssertFalse(value, "Expected false to be passed to the assert")
    }

    // Test 2: CE2 (Valida) - Inserimento sotto i 50 caratteri
    func testRangeTrue() throws {
        // Simuliamo un range valido (es. 5)
        let range = NSRange(location: 5, length: 0)

        // Chiamiamo il metodo
        let value = sut.textView(textViewTest, shouldChangeTextIn: range, replacementText: "prova")

        // Verifichiamo che restituisca TRUE
        XCTAssertTrue(value, "Expected true to be passed to the assert")
    }

    // Test 3: CE1 (Non Valida) - Inserimento di un "A capo" (\n)
    func testTextFalse() throws {
        // Simuliamo l'inserimento di un invio (ritorno a capo)
        let range = NSRange(location: 1, length: 0)

        // Chiamiamo il metodo
        let value = sut.textView(textViewTest, shouldChangeTextIn: range, replacementText: "\n")

        // Verifichiamo che restituisca FALSE
        XCTAssertFalse(value, "Expected false to be passed to the assert")
    }

}