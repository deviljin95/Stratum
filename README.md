# Stratum - App iOS per l'Apprendimento Collaborativo
<p align="center">
 <img width="250" height="250" alt="Icon" src="https://github.com/user-attachments/assets/8fa0a1b9-2fba-4f12-82d1-0063541de084" />
</p>


Progetto di Tesi di Laurea Triennale in Informatica, sviluppato a seguito dell'esperienza presso la Apple Developer Academy.

## 📖 Panoramica del Progetto
Stratum è un'applicazione iOS nata per supportare e potenziare le attività di studio cooperativo, offrendo agli studenti uno strumento digitale per la condivisione e la risoluzione di dubbi accademici da remoto. 
Rispondendo alle esigenze del Blended Learning post-pandemico, l'app funge da ponte tra il supporto fisico e quello digitale, permettendo di digitalizzare istantaneamente il materiale cartaceo e trasformarlo in un'area di lavoro interattiva.


https://github.com/user-attachments/assets/bc20bb1c-7712-4190-9fc2-154a99d43e41


## ✨ Funzionalità Core

* **Acquisizione Intelligente (OCR):** Digitalizzazione immediata di testi cartacei tramite fotocamera. Il testo estratto è immediatamente modificabile e indicizzabile.
  * *<img width="300" height="600" alt="6 2ScansioneFotocamera" src="https://github.com/user-attachments/assets/9523e851-3b46-4fcf-a65e-26076b676378" />
* **Commenti Semantici e Interazione:** Selezione di specifiche porzioni di testo per allegarvi note, dubbi o spiegazioni puntuali.
  * *<img width="300" height="500" alt="10Commento1" src="https://github.com/user-attachments/assets/1cbfb1d2-0640-432a-b5fa-58d7e937927b" />*
  * *<img width="300" height="500" alt="12TestoConCommento" src="https://github.com/user-attachments/assets/f755bb75-7fe2-4147-8abf-e128ed598c53" />*
* **Condivisione Gerarchica in Cloud:** I testi e i relativi commenti possono essere condivisi in modo sicuro tramite link d'invito, permettendo la sincronizzazione dei dati in tempo reale tra tutti i partecipanti.


https://github.com/user-attachments/assets/a93fcc04-c3c9-4255-bf3d-acb959cd53da


## 🛠 Architettura e Tecnologie
Il software è stato progettato seguendo rigorosamente i principi dell'Ingegneria del Software per garantire manutenibilità e scalabilità.

* **Linguaggio:** Swift.
* **Framework di Sistema:** UIKit (Interfaccia nativa), Vision e VisionKit (Computer Vision e OCR), MessageUI (Segnalazione bug).
* **Persistenza e Rete:** CloudKit (Backend as a Service) senza necessità di registrazione esterna da parte dell'utente.
* **Design Pattern:** Implementazione del pattern Model-View-Controller (MVC) nella sua variante specifica per iOS, affiancato dal pattern Data Access Object (DAO) per isolare la logica di interazione con il database cloud.

## 📊 Validazione e Beta Testing
L'applicazione è stata sottoposta a test unitari (Black Box e White Box) e distribuita in Beta tramite Apple TestFlight a un campione di 108 studenti universitari. 
La telemetria ha confermato l'elevata stabilità del software con il 98.2% di sessioni prive di crash, mentre i sondaggi UX hanno registrato un altissimo grado di soddisfazione, specialmente per l'affidabilità dello scanner OCR.
