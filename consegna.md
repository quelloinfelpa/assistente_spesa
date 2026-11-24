# Progetto finele 
## Assistente agentico con recupero documentale

### 1. Obiettivo del progetto
È richiesta la generalizzazione, in gruppo, di un prototipo di assistente agentico relativo a una delle tre tracce descritte nel presente documento. Il sistema comprende un agente basato su un modello linguistico eseguito localmente, un insieme di strumenti esposti tramite protocollo MCP, un modulo di recupero documentale (RAG) e una interfaccia web di utilizzo.

Il progetto ha carattere di prototipo: non è richiesta una applicazione completa nè pronta per l'esercizio. È richiesto un sistema circoscritto e funzionante, avviabile con un unico comando, di cui ciascun componente del gruppo sia in grado di illustrare sia la parte di propria competenza sia quelle sviluppate dagli altri membri.

#### 1.1 Requisiti comuni
1. Modello linguistico locale. L'agente utilizza un modello eseguito localmente ed esposto tramite endpoint compatibile con API OpenAI tramite LM Studio
2. Agente. Il ciclo di esecuzione alterna chiamate al modello ed esecuzione degli strumenti, con condizioen di arresto e numero massimo di iterazioni definito esplicitamente.
3. Strumenti MCP. Gli strumenti minimi previsti dalla traccia sono esposti da almeno un server MCP. Per ciascuno strumento sono definiti nome, descrizione, parametri tipizzati, formato del risultato e condizioni di errore
4. Recupero documentale. La ricerca dei documenti è implementata come strumento a disposizioen dell'agente. I documenti sono suddivisi in frammenti (chunk) corredati di metadati, indicizzati in un database vettoriale e interrogabili con filtri sui metadati.
5. Citazione delle fonti. Ogni informazione tratta dai documenti è accompagnata dall'indicazione della fonte (documento e sezione). Le fonti citate devono essere presenti nei risultati restituiti dallo strumento di ricerca.
6. Controlli. L'agente dichiara l'assenza di evidenze anzichè produrre informazioni non supportate e gestitsce in modo esplicito gli errori e risultati vupti degli strumenti. I calcoli e i confronti indicati come deterministici sono eseguiti dal codice e non dal modello
7. Interfaccia web. L'interfaccia è conforme alle specifiche della sezione 5, comuni a tutte le tracce.
8. Riproducibilità. L'intero sistema (interfaccia, agente, server MCP, database vettoriale, database delle conversazioni) si avvia con il comando docker compose up. il file README descrive prerequisiti, configurazione, procedura di ingestion dei documenti e avvio.

Esclusi dal perimetro del progetto: autenticazione, gestione utenti e profili, autorizzazsioni, pubblicazione su infrastrutture pubbliche.

#### 1.2 Traccia scelta
Ambito: Spesa e alimentazione
Corpus e documentazione: Linee guida CREA 2018
Dati e servizi: Open Food Facts (catalogo prodotti)

#### 1.3 Organizzazione del gruppo

|Ruolo|Responsabilità|Nome|
|---|---|----|
|Agente e strumenti|grafo dell'agente, istruzioni, server MCP, strumenti su dati e servizi esterni|Emanuele Oi|
|Documenti e retrieval|acquisizione, pulizia, chunking, metadati, embedding, indicizzazione, strumenti di ricerca|Michele Molent|
|Applicazione|interfaccia web, database della conversazione, integrazione con l'agente, Docker Compose|Carlo Giacomini|

interfacce tra componenti, il formato dei risultati della ricerca e il formato dei messaggi scambiati tra interfaccia e agente, sono definite all'avvio del lavoro e documentate nel README

#### 1.4 Presentazione
Progetto presentato alla lavagna. Ciascun componente illustra la parte di cui è il responsabile, le scelte progettuali adottate e i limiti noti, e ne dimostra il funzionamento all'interno del sistema integrato. Ogni componente deve essere in grado di rispondere a domande su qualunque parte del sistema.

### 2 Obiettivo dell'sistema
#### 2.1 Obiettivo dell'agente
L' assistente supporta la scelta consapevole di prodotti alimentari confezionati. Le funzioni richieste sono:
1. confrontare valori nutrizionali e Nutri-Score dei prodotti
2. verificare la presenza degli allergeni dichiarati dall'utente nel corso della conversazione
3. rispondere a quesiti di educazione alimentare citando le linee guida ufficiali.

esempio richiesta: Sono allergico alla frutta a guscio: quale di questi due biscotti posso acquistare? con quale frequenza è opportuno consumare dolci?

#### 2.2 Corpus documentale
1. Linee guida per una sana alimentazione, revisione 2018, pubblicata dal CREA, documento pubblico e gratuito crea.gov.it - Linee guida 2018, copia disponibile anche su EpiCentro ISS.
2. Capitoli selezionati dal Dossier scientifico che accompagna le linee guifa, disponibile sul sito del CREA, elencati nel README.
3. Metadati minimi per frammento: direttiva(capitolo), sezione, pagina. La ricerca deve consentire filtro per direttiva.

#### 2.3 Dati strutturati
1. Open Food Facts, database aperto di prodotti alimentari (licenza ODbl): Documentazione API, esportazioni dei dati.
2. la consultazione non richiede chiave di accesso ma richeide uno User-Agent personalizzato. I limiti sono di 15 richieste al minuto per prodotti q 10 per le ricerche, per indirizzo IP; l'intera aula condivide il medesimo indirizzo (da tenere in considerazione se altri hanno lo stesso progetto ed espongono immediatamente prima di noi)
3. Il gruppo predispone pertanto un catalogo locale di almeno 50 prodotti appartenenti a 3-4 categorie (es. biscotti, cereali, yogurt, bevande), acquisiti una sola volta tramite script che rispetta i limiti e memorizzati in un database. Gli strumenti interrogano il catalogo locale.

#### 2.4 Strumenti minimi
|Strumento|Parametri|Risultato|Errori da gesire|
|---|---|---|---|
|cerca_linee_guida|query (testo); direttiva(facoltativo, filtro);k|elenco di passaggi con testo, direttiva, sezione, pagina e punteggio|nessun risultato pertinente|
|cerca_prodotto|nome o codice_a_barre; categoria (facoltativo)|prodotti corrispondenti con codice a barre, nome, marca, Nutri-Score e valori per 100g (energia, grassi, zuccheri, sale, proteine)|nessun prodototo; corrispondenze eccessive (richiesta di precisazione)|
|verifica_allergeni|codice_a_barre, allergeni (elenco dichiarato dall'utente)|esito per ciascun allergene(presente/tracce/assente/non verificabile), con indicazione del campo del prodotto da cui deriva|prodotto inesistente; dati sugli allergeni mancanti|

lo strumento verifica_allergeni è deterministico: opera sui campi relativi ad allergeni e tracce del prodotto, senza intervento del modello. In assenza di dati l'esito è "non verificabile" e in nessun caso "assente".
Estensione facoltativa: strumento confronta_prodotti (elenco di codici a barre), che restituisce una tabella dei valori per 100g calcolata dal codice.

#### 2.5 Controlli specifici
1. l'assistente non fornisce indicazioni medice, diete per patologie o diagnosi; in tali casi rinvia al medico
2. Valori nutrizionali e allergeni sono riportati solo se presenti nei risultati degli strumenti
3. Poichè i dati di Open Food Facts sono inseriti da volontari, l'assistente raccomanda la verifica dell'etichetta del prodotto

### 3 Interfaccia web
Costituita da una pagina web suddivisa in due aree: a sinistra l'elenco delle conversazioni, a destra la conversazione selezionata. Non sono previsti autenticazione nè gestione di utenti o profili. Scelta tecnologica da decidere.

#### 3.1 Requisiti minimi
1. Nuova conversazione. Un pulsante avvia una conversazioen vuota.
2. Elenco delle conversazioni. Le conversazioni sono elencate dalla più recente, ciscuna con un titolo (esempio l'inizio del primo messaggio). La selezione di una conversazione ne visualizza l'intero contenuto; la conversazione aperta è evidenziata.
3. Messaggi dell'utente. I messaggi dell'utente sono distinguibili da quelli dell'agente per allineamento e colore e sono presenti in ordine cronologico
4. Risposte dell'agente. Le risposte sono visualizzate con formattazione markdown (elenchi, grassetto, tabelle). Durante l'elaborazione è visibile un indicatore di attesa e non è possibile inviare ulteriori messaggi.
5. Fonti. Le fonti utilizzate sono riportate sotto la risposta che le cita: documento, sezione e, ove disponibile, collegamento.
6. Strumenti utilizzati (facoltativo). Un pannello espandibile riporta gli strumenti invocati con argomenti, esito e durata.
7. Inserimento del messaggio. Un campo di testo con pulsante e invio; il tasto invio inoltra il messaggio.

#### 3.2 Persistenza e comportamento
1. Conversazioni e messaggi sono memorizzati in un database e restano disponibili dopo il riavvio dei container (volumi Docker)
2. Alla ripresa di una conversazione, l'agente riceve la cronologia della sola conversazione selezionata
3. In caso di mancata risposta del modello o di un servizio, l'interfaccia visualizza un messaaggio di errore nella conversazione e rimane utilizzabile

#### 3.3 Estensioni
1. Visualizzazione progressiva della risposta (streaming)
2. Ridenominazione ed eliminazione delle conversazioni

### 4 Consegna e verifica
#### 4.1 Materiale da consegnare
entro il 16 dicembre 2026 tramite repository git contente:
1. codice di tutti i componenti e file docker-compose.yml
2. script di ingestion dei documenti e script o file che generano dati strutturati.
3. README, con prerequisiti, configurazione (.env.example), comandi di ingestion e avvio, formato concordato tra i componenti
4. rapporto di valutazione sintetico, comprensivo della tabella dei casi di prova e dei limiti noti

#### 4.2 Casi di prova
Da registrare almeno un caso per ognuna delle seguenti tipologie con:
1. richiesta
2. strumenti invocati
3. risposta
4. esito

|Tipologia|Comportamento atteso|
|---|---|
|Quesito sui documenti|Risposta corretta con fonte presente nei risultati della ricerca|
|Quesito sui dati o sul servizio|scelta dello strumento corretto con argomenti corretti|
|Quesito combinato|utilizzo in sequenza di più strumenti e sintesi dei risultati nella risposta|
|Quesito privo di evidenze nei documenti|dichiarazione di assenza dell'informazione|
|Errore o risultato vuoto di uno strumento|segnalazione dell'errore, senza informazioni inventate|
|Richiesta ambigua|richiesta di chiarimento all'utente|
|Richiesta estranea all'ambito della traccia|mancata risposta nel merito, con motivazione|

Durante la presentazione si espongono in modo puntuali i limiti riscontrati nel sistma, con rierimento ai casi di prova, e le soluzioni adottate o tentate per superarli

#### 4.3 Verifica dell'interfaccia e dell'avvio
1. Il comando docker compose up avvia il sistema su una macchina priva di configurazioni preesistenti, seguendo le istutuzioni del README
2. Conversazioni distinte restano separate e sono nuovamente consultabili dopo il riavvio del container.
3. In assenza del modello l'interfaccia visualizza un messaggio di errore ma non si blocca