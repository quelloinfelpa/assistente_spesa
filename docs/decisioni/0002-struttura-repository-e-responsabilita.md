# 0002. Struttura del repository e responsabilità

- **Stato:** accettata (2026-11-24, PR #1)
- **Data:** 2026-11-24
- **Proponente:** Michele Molent
- **Componenti coinvolti:** tutti

## Contesto

`consegna.md` assegna tre ruoli (agente e strumenti, documenti e retrieval, applicazione) ma lascia senza responsabile alcuni compiti richiesti dalla consegna: script di acquisizione da Open Food Facts, README, `.env.example`, casi di prova e rapporto di valutazione. Serve anche una struttura di cartelle in cui ognuno possa lavorare senza intralciare gli altri.

## Alternative considerate

- **Una cartella per container, un responsabile per cartella.** Confini netti, ognuno costruisce e prova il proprio container in autonomia. Richiede formati di scambio chiari fin dall'inizio (che la consegna chiede comunque).
- **Una cartella per livello (`frontend/`, `backend/`, `data/`).** Mescola il lavoro di persone diverse nelle stesse cartelle e rende meno chiaro chi risponde di cosa.
- **Pacchetto Python unico con sottomoduli.** Semplice da importare ma incompatibile con la scelta di container separati (vedi [0003](0003-server-mcp-separati.md)).

## Decisione

Una cartella di primo livello per ogni container sviluppato da noi:

```
assistente_spesa/
├─ docker-compose.yml        Carlo
├─ .env.example              Carlo (ognuno aggiunge le proprie variabili)
├─ README.md                 avvio, indicizzazione, formati concordati
├─ consegna.md               specifica (non si modifica)
├─ CLAUDE.md                 istruzioni condivise per Claude Code
├─ docs/
│  ├─ decisioni/             registro delle decisioni condivise
│  ├─ pianificazione.md      calendario e traguardi
│  ├─ valutazione/           rapporto e tabella dei casi di prova
│  └─ <componente>/          specifiche e piani di ciascun componente
├─ web/                      Carlo
├─ agente/                   Emanuele
├─ mcp_prodotti/             Emanuele
│  ├─ scripts/               acquisizione una tantum da Open Food Facts
│  └─ data/                  catalogo prodotti versionato
└─ mcp_linee_guida/          Michele
   ├─ ingestion/             PDF → chunk → embedding → Qdrant
   └─ data/                  PDF del corpus CREA
```

Qdrant e il database delle conversazioni usano immagini ufficiali e non hanno una cartella.

Responsabilità:

| Compito | Responsabile |
|---|---|
| `web/`: interfaccia, API, database conversazioni | Carlo |
| `docker-compose.yml`, `.env.example`, sezione avvio del README | Carlo |
| `agente/`: grafo, prompt di sistema, collegamento ai server MCP | Emanuele |
| `mcp_prodotti/`: `cerca_prodotto`, `verifica_allergeni`, `confronta_prodotti`, script di acquisizione | Emanuele |
| `mcp_linee_guida/`: corpus, ingestion, `cerca_linee_guida` | Michele |
| Formato risultati di ricerca (README) | Michele propone |
| Formato prodotti e allergeni (README) | Emanuele propone |
| Formato messaggi interfaccia ↔ agente (README) | Carlo ed Emanuele propongono |
| Casi di prova del proprio componente | ciascuno |
| Casi di prova di comportamento dell'agente (combinato, ambiguo, fuori ambito) | Emanuele |
| Raccolta della tabella dei casi di prova e rapporto di valutazione | Michele |

Restano al responsabile di ciascun componente le scelte interne: per esempio, se `web/` contiene uno o due container, quale database usare per le conversazioni, quale framework per l'agente, il formato del catalogo.

## Conseguenze

- Ognuno può sviluppare e provare il proprio container prima che gli altri siano pronti, a patto di rispettare i formati concordati.
- Ogni compito richiesto dalla consegna ha un responsabile.
- Modifiche in una cartella altrui si fanno tramite PR e con l'accordo del responsabile.
