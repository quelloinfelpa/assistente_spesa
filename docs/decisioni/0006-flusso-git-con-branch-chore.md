# 0006. Flusso Git e Conventional Commits (con branch `chore/`)

- **Stato:** proposta
- **Data:** 2026-11-24
- **Proponente:** Michele Molent
- **Componenti coinvolti:** tutti
- **Sostituisce:** [0005](0005-flusso-git-e-conventional-commits.md)

## Contesto

La [0005](0005-flusso-git-e-conventional-commits.md) prevede il tipo di commit `chore` ma nessun prefisso di branch per i lavori di manutenzione (configurazione del repository, `.gitattributes`, `.gitignore`, pulizie). Il primo caso, la PR #3, è finito su un branch `fix/` pur non correggendo un difetto. Questa decisione riprende integralmente la 0005 aggiungendo il prefisso `chore/`, così la regola valida sta in un solo file.

## Alternative considerate

- **Usare `fix/` per la manutenzione.** Nessuna modifica, ma il nome del branch non corrisponde al tipo di commit e confonde lo storico.
- **Aggiungere `chore/`.** Un prefisso in più, coerente con il tipo di commit già previsto.
- **Solo `main` con branch brevi / `main` + `dev` / git flow completo con `release/`.** Già valutate nella 0005; resta valida la scelta `main` + `dev` + branch di lavoro + hotfix.

## Decisione

### Branch

| Branch | Nasce da | Entra in | Uso |
|---|---|---|---|
| `main` | | | solo versioni stabili e avviabili; nessun commit diretto |
| `dev` | `main` | `main` | integrazione di tutto il lavoro; nessun commit diretto |
| `feature/<componente>-<descrizione>` | `dev` | `dev` | nuove funzionalità |
| `fix/<componente>-<descrizione>` | `dev` | `dev` | correzioni durante lo sviluppo |
| `docs/<descrizione>` | `dev` | `dev` | documentazione e decisioni |
| `chore/<descrizione>` | `dev` | `dev` | manutenzione del repository senza effetti sul comportamento (configurazione git, file di servizio, pulizie) |
| `hotfix/<descrizione>` | `main` | `main`, poi `main` → `dev` | correzioni urgenti su una versione già in `main` |

`<componente>` è uno tra `web`, `agente`, `mcp-prodotti`, `mcp-linee-guida`, `compose`. Esempio: `feature/mcp-linee-guida-chunking`.

### Integrazione

- Ogni branch entra con una Pull Request. In `dev` serve l'approvazione di almeno un altro membro; quella di tutti e tre se la PR tocca una cartella altrui, un formato di scambio o una decisione (vedi [0001](0001-registro-decisioni-e-approvazione.md)).
- Le PR verso `dev` si uniscono con **squash merge**: un commit per PR, con il titolo della PR come messaggio (quindi il titolo segue il formato sotto).
- `dev` → `main` con **merge commit** ai traguardi della pianificazione (scheletro, sistema integrato, consegna), dopo aver verificato che `docker compose up` parta. Ogni passaggio in `main` riceve un tag (`v0.1`, `v0.2`, …, `v1.0` alla consegna).

### Messaggi di commit

[Conventional Commits](https://www.conventionalcommits.org/it/v1.0.0/), in italiano:

```
<tipo>(<ambito>): <descrizione al presente, minuscola, senza punto finale>
```

- **Tipi:** `feat`, `fix`, `docs`, `refactor`, `test`, `build` (Docker, dipendenze), `chore`.
- **Ambiti:** `web`, `agente`, `mcp-prodotti`, `mcp-linee-guida`, `compose`, `decisioni`, `valutazione`. L'ambito è facoltativo per le modifiche che riguardano tutto il repository.
- **Cambio di formato di scambio:** `!` dopo l'ambito e riga `BREAKING CHANGE:` nel corpo, con riferimento alla decisione. Esempio: `feat(mcp-linee-guida)!: aggiunge campo url ai risultati di ricerca`.

## Conseguenze

- Il prefisso del branch corrisponde al tipo di commit anche per la manutenzione.
- La PR #3 (`fix/fine-riga-gitattributes`) resta com'è: è precedente a questa decisione.
- `main` è sempre la versione da mostrare o consegnare; `dev` può essere temporaneamente instabile.
