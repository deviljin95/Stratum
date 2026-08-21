<p align="center">
 <img width="150" height="150" alt="Icon" src="https://github.com/user-attachments/assets/8fa0a1b9-2fba-4f12-82d1-0063541de084" />
 <h1>Stratum - App iOS per l'Apprendimento Collaborativo</h1>
</p>

Progetto di Tesi di Laurea Triennale in Informatica, sviluppato a seguito dell'esperienza presso la Apple Developer Academy.

## 📖 Panoramica del Progetto
Stratum è un'applicazione iOS nata per supportare e potenziare le attività di studio cooperativo, offrendo agli studenti uno strumento digitale per la condivisione e la risoluzione di dubbi accademici da remoto. 

Spesso, lo studio collaborativo a distanza avviene tramite le classiche app di messaggistica, dove però la concentrazione viene facilmente spezzata da notifiche e messaggi fuori contesto. Come si nota nello spot qui sotto, basta una semplice distrazione in un gruppo chat per perdere il filo del discorso tra argomenti che non c'entrano nulla con lo studio. 

Stratum nasce proprio per risolvere questa dispersione: fornire uno spazio dedicato esclusivamente all'apprendimento, dove il focus rimane al 100% sul documento e non c'è il rumore di fondo delle app tradizionali.

https://github.com/user-attachments/assets/bc20bb1c-7712-4190-9fc2-154a99d43e41

## ✨ Funzionalità Core

* **Inserimento Rapido Manuale:** Possibilità di inserire nuovi documenti digitando o incollando il testo direttamente nell'applicazione, arricchendoli con Titolo e #TAG per una facile catalogazione.


https://github.com/user-attachments/assets/635a7a55-8dd0-4e42-a8db-0f7d301a0506


* **Acquisizione Intelligente (OCR):** Digitalizzazione immediata di testi cartacei tramite fotocamera. Il testo estratto è immediatamente modificabile e indicizzabile.

<img width="300" height="600" alt="6 2ScansioneFotocamera" src="https://github.com/user-attachments/assets/9523e851-3b46-4fcf-a65e-26076b676378" />

* **Commenti Semantici e Interazione:** Selezione di specifiche porzioni di testo per allegarvi note, dubbi o spiegazioni puntuali.

<table align="center">
  <tr>
    <td>
      <video src="https://github.com/user-attachments/assets/049b1338-a711-44c1-9c0c-e47af18ed819" width="350" controls></video>
    </td>
    <td>
      <video src="https://github.com/user-attachments/assets/341b5ee6-fa61-4287-b844-eb49522be07d" width="350" controls></video>
    </td>
  </tr>
</table>



* **Condivisione Gerarchica in Cloud:** I testi e i relativi commenti possono essere condivisi in modo sicuro tramite link d'invito, permettendo la sincronizzazione dei dati in tempo reale tra tutti i partecipanti.


https://github.com/user-attachments/assets/d77721bf-7e5a-4025-94c7-17296580c277


## 🛠 Architettura e Tecnologie
Il software è stato progettato seguendo rigorosamente i principi dell'Ingegneria del Software per garantire manutenibilità e scalabilità.

* **Linguaggio:** Swift.
* **Framework di Sistema:** UIKit (Interfaccia nativa), Vision e VisionKit (Computer Vision e OCR), MessageUI (Segnalazione bug).
* **Persistenza e Rete:** CloudKit (Backend as a Service) senza necessità di registrazione esterna da parte dell'utente.
* **Design Pattern:** Implementazione del pattern Model-View-Controller (MVC) nella sua variante specifica per iOS, affiancato dal pattern Data Access Object (DAO) per isolare la logica di interazione con il database cloud.

## 📊 Validazione e Beta Testing
L'applicazione è stata sottoposta a test unitari (Black Box e White Box) e distribuita in Beta tramite Apple TestFlight a un campione di 108 studenti universitari. 
La telemetria ha confermato l'elevata stabilità del software con il 98.2% di sessioni prive di crash, mentre i sondaggi UX hanno registrato un altissimo grado di soddisfazione, specialmente per l'affidabilità dello scanner OCR.

## 📚 Documentazione Completa
Per un'analisi approfondita dell'intero ciclo di vita del software, inclusi i diagrammi UML, la specifica dei requisiti (casi d'uso e tabelle di Cockburn) e il piano di testing completo, è possibile consultare la documentazione accademica integrale:

📄 **[Scarica / Leggi la Tesi Completa (PDF)](Documentazione_Stratum.pdf)**
---

## 👨‍💻 Autore
**Giovanni Luca Di Maio** 
- **LinkedIn:** [linkedin.com/in/giovanni-luca-di-maio](https://linkedin.com/in/giovanni-luca-di-maio-bb84431b0)
- **Email:** gianlucadm55@gmail.com
