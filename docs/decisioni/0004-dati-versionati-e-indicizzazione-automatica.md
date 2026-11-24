# 0004. Dati versionati e indicizzazione automatica

- **Stato:** accettata (2026-11-24, PR #1)
- **Data:** 2026-11-24
- **Proponente:** Michele Molent
- **Componenti coinvolti:** mcp_prodotti, mcp_linee_guida, web (Docker Compose)

## Contesto

`docker compose up` deve avviare il sistema su una macchina priva di configurazioni. Su una macchina pulita il database vettoriale è vuoto e il catalogo prodotti non esiste. Open Food Facts limita le richieste (15/min prodotti, 10/min ricerche) per indirizzo IP, e l'intera aula condivide lo stesso IP.

## Alternative considerate

- **Scaricare tutto all'avvio** (PDF e prodotti). Avvio lento, dipendente dalla rete e dai limiti di Open Food Facts: rischio concreto di fallire durante la verifica o la presentazione.
- **Dati di partenza versionati nel repository, indicizzazione automatica al primo avvio.** Nessuna chiamata esterna all'avvio; il primo avvio impiega il tempo dell'indicizzazione.
- **Dati versionati, indicizzazione solo manuale.** Avvio rapido, ma `docker compose up` da solo non produce un sistema funzionante.

## Decisione

- I PDF del corpus CREA (pubblici e gratuiti) sono salvati in `mcp_linee_guida/data/`.
- Il catalogo prodotti è generato una sola volta dallo script in `mcp_prodotti/scripts/` e il risultato è salvato in `mcp_prodotti/data/`. Gli strumenti leggono solo il catalogo locale.
- All'avvio, se la collezione Qdrant è vuota, `mcp_linee_guida` esegue l'indicizzazione. Il README riporta anche il comando per rieseguirla a mano.

## Conseguenze

- Il sistema non dipende dalla rete per funzionare (a parte LM Studio sull'host).
- Il primo avvio è più lento; Docker Compose deve tenerne conto nell'ordine di avvio e nei controlli di salute dei servizi.
- Il modello di embedding deve essere disponibile nel container senza download all'avvio (scelta di dettaglio lasciata a `mcp_linee_guida`).
- Va verificata la licenza ODbL del catalogo (attribuzione nel README).
