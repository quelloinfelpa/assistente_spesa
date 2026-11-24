# Pianificazione

Approvata il 24/11/2026 insieme alle decisioni 0001-0005 (PR #1). Consegna: **mercoledì 16 dicembre 2026**. Le date sono indicative: si correggono qui, con una PR.

## Principio

Prima si monta un sistema completo ma finto, poi si sostituiscono i pezzi finti con quelli veri. Ogni componente rispetta da subito i formati concordati restituendo dati fissi, così l'integrazione non si scopre a fine lavoro.

## Traguardi

| Entro | Traguardo | Chi |
|---|---|---|
| ven 27/11 | Decisioni 0001-0005 approvate; collaboratori aggiunti al repository | tutti |
| ven 27/11 | Formati di scambio scritti nel README e approvati | Michele (ricerca), Emanuele (prodotti), Carlo + Emanuele (messaggi) |
| lun 30/11 | Scheletro funzionante: `docker compose up` avvia tutti i container; i server MCP restituiscono dati fissi conformi ai formati; l'interfaccia invia un messaggio e mostra la risposta | tutti, integrazione Carlo |
| lun 30/11 | Catalogo prodotti acquisito e salvato (≥ 50 prodotti, 3-4 categorie) | Emanuele |
| ven 4/12 | Componenti reali: ricerca sulle linee guida con filtro per direttiva; strumenti prodotti e allergeni; ciclo dell'agente con limite di iterazioni; persistenza delle conversazioni | ciascuno |
| lun 7/12 | Sistema integrato con componenti reali; prima esecuzione di tutti i casi di prova | tutti |
| ven 11/12 | Correzioni dai casi di prova; rapporto di valutazione in bozza; prova di avvio su macchina pulita | tutti, rapporto Michele |
| lun 14/12 | README completo; rapporto definitivo; limiti noti documentati | tutti |
| 15/12 | Riserva per imprevisti; prova della presentazione | tutti |
| mer 16/12 | Consegna | |

Ai traguardi del 30/11 (scheletro), 7/12 (sistema integrato) e 16/12 (consegna) si porta `dev` in `main` con un tag (`v0.1`, `v0.2`, `v1.0`), vedi decisione 0005.

## Piani dei singoli componenti

Ognuno, dopo l'approvazione, scompone il proprio lavoro in `docs/<componente>/` (specifica e piano) rispettando i traguardi sopra:

- `docs/web/`: Carlo
- `docs/agente/` e `docs/mcp_prodotti/`: Emanuele
- `docs/mcp_linee_guida/`: Michele

Se un piano non riesce a rispettare un traguardo, si aggiorna questo file con una PR invece di slittare in silenzio.
