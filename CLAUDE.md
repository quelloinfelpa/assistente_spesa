# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Progetto

Prototipo di assistente agentico per la scelta consapevole di prodotti alimentari confezionati (progetto finale di gruppo, consegna **16 dicembre 2026**). Specifica completa in `consegna.md`: in caso di dubbio sui requisiti, fa fede quel file.

Lingua del progetto: italiano (documentazione, messaggi all'utente, nomi degli strumenti MCP). I nomi degli strumenti sono fissati dalla traccia e non vanno cambiati: `cerca_linee_guida`, `cerca_prodotto`, `verifica_allergeni`, `confronta_prodotti` (facoltativo).

**Stato attuale:** il repository contiene specifica, registro delle decisioni e pianificazione; il codice non esiste ancora. Quando una scelta viene presa, aggiornare questo file (sezioni "Comandi" e "Architettura") invece di lasciarla implicita nel codice.

## Procedura di lavoro (ogni sessione)

**Prima di iniziare**

1. Partire da `dev` aggiornato (`git switch dev && git pull --ff-only`) e creare un branch secondo la sezione Git. Mai lavorare su `main` o `dev`.
2. Controllare le PR aperte (`gh pr list`) e le decisioni in stato `proposta`. Se il lavoro richiesto dipende da una PR non ancora unita o da una decisione non accettata, fermarsi e dirlo all'utente invece di procedere.
3. Verificare che il lavoro stia nella cartella di cui l'utente è responsabile (tabella in "Architettura prevista"). Se tocca la cartella di un altro, un formato di scambio o una decisione, dirlo **prima** di scrivere codice.

**Prima di chiudere**

1. Verificare che il lavoro funzioni (test o avvio del componente, quando esistono).
2. Aggiornare nello stesso branch README, decisioni e `docs/<componente>/` se il lavoro li riguarda, e la sezione "Comandi" di questo file se i comandi sono cambiati.
3. Commit secondo Conventional Commits, push del proprio branch, PR verso `dev` con gli altri membri come revisori. Riportare all'utente il link e cosa resta in attesa di approvazione.
4. Non unire le PR, nemmeno se approvate: lo fa una persona da GitHub.

**Blocchi automatici** (non aggirarli: se scattano, cambiare branch o chiedere all'utente)

- GitHub: `main` e `dev` sono protetti per tutti, amministratori compresi. Si entra solo con PR, almeno un'approvazione e conversazioni risolte; una nuova modifica annulla le approvazioni precedenti; niente force push né cancellazione; su `dev` solo storia lineare (squash merge).
- Claude Code: l'hook `.claude/hooks/proteggi-branch.sh` (in `.claude/settings.json`) blocca commit, merge, push e rebase su `main` o `dev`, i push espliciti verso `main` o `dev` e l'unione di PR da riga di comando. Scatta anche se quelle parole compaiono solo nel testo del comando (per esempio nel corpo di una PR): in quel caso riformulare il testo.

## Decisioni, documentazione e storico

- Prima di lavorare leggere le decisioni in `docs/decisioni/` (indice nel suo README) e il calendario in `docs/pianificazione.md`. Una decisione `accettata` vincola. Una `proposta` non vincola, ma non si scrive codice che ne dipende finché non è accettata.
- Se una modifica tocca un formato di scambio, il confine tra componenti, la struttura del repository o una scelta già registrata, **non procedere in silenzio**: proporre una nuova decisione con il modello di `docs/decisioni/README.md` e segnalarla all'utente. Le decisioni accettate non si riscrivono: si sostituiscono con una nuova, cambiando solo la riga di stato della vecchia.
- Le decisioni interne a un componente vanno in `docs/<componente>/` insieme a specifiche e piani di quel componente (non in `docs/superpowers/`).
- Codice, README e decisioni cambiano nello stesso commit/PR: se il codice cambia un formato, la stessa PR aggiorna README e decisione.
- Tutto entra tramite Pull Request rivista dagli altri membri (decisioni 0001, 0006 e 0007).

## Architettura prevista

Tutto il sistema deve partire con un solo `docker compose up` su una macchina pulita. Struttura e responsabilità complete nella decisione 0002; in sintesi una cartella per container, un responsabile per cartella:

| Cartella | Responsabile | Contenuto |
|---|---|---|
| `web/` + `docker-compose.yml` | Carlo Giacomini | interfaccia web, API, database delle conversazioni, integrazione con l'agente |
| `agente/` | Emanuele Oi | grafo dell'agente, prompt di sistema, client verso i server MCP |
| `mcp_prodotti/` | Emanuele Oi | server MCP con `cerca_prodotto`, `verifica_allergeni`, `confronta_prodotti`; script di acquisizione Open Food Facts |
| `mcp_linee_guida/` | Michele Molent | server MCP con `cerca_linee_guida`; corpus CREA, chunking, metadati, embedding, indicizzazione in Qdrant |

Non modificare una cartella di cui l'utente corrente non è responsabile se non lo chiede esplicitamente.

Flusso: interfaccia web → agente (ciclo modello/strumenti con numero massimo di iterazioni esplicito) → due server MCP (decisione 0003) → Qdrant (linee guida) e catalogo prodotti locale. Il modello gira in **LM Studio sull'host**, non in un container, ed è raggiunto tramite endpoint compatibile OpenAI: dai container serve un indirizzo che punti all'host (es. `host.docker.internal`), configurato via `.env`.

### Interfacce tra componenti

Vanno concordate all'inizio e documentate nel README (requisito della consegna). Finché non sono nel README, non inventarne il formato nel codice: chiedere o proporre una bozza da approvare. Sono tre:

1. formato dei risultati di ricerca (`cerca_linee_guida`): per ogni passaggio almeno testo, direttiva, sezione, pagina, punteggio;
2. formato dei prodotti (`cerca_prodotto`): codice a barre, nome, marca, Nutri-Score, valori per 100 g (energia, grassi, zuccheri, sale, proteine);
3. formato dei messaggi tra interfaccia e agente, comprese fonti citate ed eventuale traccia degli strumenti (argomenti, esito, durata).

Chi modifica uno di questi formati aggiorna README e consumatori nello stesso commit.

## Vincoli non negoziabili

Sono requisiti valutati: non vanno aggirati per comodità.

- **Citazioni.** Ogni informazione tratta dai documenti riporta documento e sezione, e la fonte deve comparire tra i risultati effettivamente restituiti da `cerca_linee_guida`. Mai citare fonti non recuperate.
- **Deterministico nel codice.** `verifica_allergeni`, i confronti tra prodotti e ogni calcolo sui valori nutrizionali sono eseguiti dal codice, non dal modello.
- **Allergeni.** Esiti possibili: presente / tracce / assente / non verificabile, con il campo del prodotto da cui deriva l'esito. Se i dati mancano l'esito è "non verificabile", **mai** "assente".
- **Assenza di evidenze.** Risultati vuoti ed errori degli strumenti vengono dichiarati esplicitamente; l'agente non riempie i vuoti con conoscenza propria. Valori nutrizionali e allergeni si riportano solo se presenti nei risultati.
- **Perimetro.** Nessuna indicazione medica, dieta per patologie o diagnosi: rinvio al medico. Si raccomanda sempre di verificare l'etichetta (i dati Open Food Facts sono inseriti da volontari).
- **Fuori perimetro:** autenticazione, utenti, profili, deploy pubblico. Non aggiungerli.

## Dati

**Corpus (RAG):** Linee guida per una sana alimentazione CREA 2018 più capitoli selezionati del Dossier scientifico (elenco nel README). Metadati minimi per frammento: `direttiva` (capitolo), `sezione`, `pagina`. La ricerca deve supportare il filtro per direttiva.

**Open Food Facts:** gli strumenti interrogano solo il **catalogo locale** (≥ 50 prodotti, 3-4 categorie), mai l'API dal vivo. Il catalogo è generato una sola volta da uno script di acquisizione che:
- usa uno User-Agent personalizzato (obbligatorio);
- rispetta 15 richieste/min per i prodotti e 10/min per le ricerche;
- tiene conto che l'intera aula condivide lo stesso IP: non lanciarlo in loop o durante le prove degli altri gruppi.

Non rieseguire lo script di acquisizione o di ingestion senza motivo: i risultati vanno versionati o resi riproducibili come indicato nel README.

## Valutazione

La consegna richiede un rapporto con una tabella di casi di prova (richiesta, strumenti invocati, risposta, esito) per ciascuna tipologia: quesito sui documenti, sui dati, combinato, privo di evidenze, errore/risultato vuoto di uno strumento, richiesta ambigua, richiesta fuori ambito. Quando si corregge un comportamento dell'agente, verificare che il caso di prova corrispondente resti valido.

Ogni membro deve saper spiegare anche le parti degli altri: le scelte progettuali non ovvie (modello di embedding, dimensione dei chunk, limite di iterazioni, ecc.) vanno motivate brevemente nel README o in un commento, non solo nel messaggio di commit.

## Comandi

Da definire. Inserire qui avvio (`docker compose up`), ingestion dei documenti, generazione del catalogo prodotti ed esecuzione dei test appena esistono.

## Git

Flusso completo nella decisione 0006 (che sostituisce la 0005). In breve:

- Mai commit diretti su `main` o `dev`. Si lavora su `feature/<componente>-<descrizione>`, `fix/…`, `docs/…` o `chore/…` (manutenzione del repository) nati da `dev`, con PR verso `dev` (squash merge). `hotfix/…` nasce da `main` e torna in `main` e poi in `dev`.
- Componenti nei nomi dei branch e negli ambiti dei commit: `web`, `agente`, `mcp-prodotti`, `mcp-linee-guida`, `compose` (più `decisioni`, `valutazione` per i commit).
- Conventional Commits in italiano: `<tipo>(<ambito>): <descrizione>`, tipi `feat`, `fix`, `docs`, `refactor`, `test`, `build`, `chore`. Un cambio di formato di scambio usa `!` e `BREAKING CHANGE:` con riferimento alla decisione.
- Il titolo della PR verso `dev` segue lo stesso formato, perché diventa il messaggio dello squash merge.
