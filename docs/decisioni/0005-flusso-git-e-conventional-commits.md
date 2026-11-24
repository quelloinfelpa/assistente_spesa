# 0005. Flusso Git e Conventional Commits

- **Stato:** proposta
- **Data:** 2026-11-24
- **Proponente:** Michele Molent
- **Componenti coinvolti:** tutti

## Contesto

Tre persone lavorano in parallelo su cartelle diverse con integrazioni periodiche (vedi [pianificazione](../pianificazione.md)). Serve che `main` resti sempre in uno stato avviabile e consegnabile, che l'integrazione avvenga in un posto preciso e che lo storico dei commit sia leggibile anche per il rapporto e la presentazione.

## Alternative considerate

- **Solo `main` con branch brevi.** Semplice, ma ogni merge finisce subito nella versione consegnabile: durante l'integrazione `main` può restare rotto.
- **`main` + `dev` + branch di lavoro + hotfix.** Un passaggio in più, ma `main` contiene solo versioni verificate e `dev` assorbe i problemi di integrazione.
- **Git flow completo con branch `release/`.** Eccessivo per un prototipo di tre settimane.

## Decisione

### Branch

| Branch | Nasce da | Entra in | Uso |
|---|---|---|---|
| `main` | | | solo versioni stabili e avviabili; nessun commit diretto |
| `dev` | `main` | `main` | integrazione di tutto il lavoro; nessun commit diretto |
| `feature/<componente>-<descrizione>` | `dev` | `dev` | nuove funzionalità |
| `fix/<componente>-<descrizione>` | `dev` | `dev` | correzioni durante lo sviluppo |
| `docs/<descrizione>` | `dev` | `dev` | documentazione e decisioni |
| `hotfix/<descrizione>` | `main` | `main`, poi `main` → `dev` | correzioni urgenti su una versione già in `main` |

`<componente>` è uno tra `web`, `agente`, `mcp-prodotti`, `mcp-linee-guida`, `compose`. Esempio: `feature/mcp-linee-guida-chunking`.

### Integrazione

- Ogni branch entra con una Pull Request. In `dev` serve l'approvazione di almeno un altro membro; quella di tutti e tre se la PR tocca una cartella altrui, un formato di scambio o una decisione (vedi [0001](0001-registro-decisioni-e-approvazione.md)).
- Le PR verso `dev` si uniscono con **squash merge**: un commit per PR, con il titolo della PR come messaggio (quindi il titolo segue il formato sotto).
- `dev` → `main` con **merge commit** ai traguardi della pianificazione (scheletro, sistema integrato, consegna), dopo aver verificato che `docker compose up` parta. Ogni passaggio in `main` riceve un tag (`v0.1`, `v0.2`, …, `v1.0` alla consegna).
- Eccezione iniziale: la PR che introduce questa proposta va direttamente in `main`, perché `dev` non esiste ancora. Dopo il merge si crea `dev` da `main`.

### Messaggi di commit

[Conventional Commits](https://www.conventionalcommits.org/it/v1.0.0/), in italiano:

```
<tipo>(<ambito>): <descrizione al presente, minuscola, senza punto finale>
```

- **Tipi:** `feat`, `fix`, `docs`, `refactor`, `test`, `build` (Docker, dipendenze), `chore`.
- **Ambiti:** `web`, `agente`, `mcp-prodotti`, `mcp-linee-guida`, `compose`, `decisioni`, `valutazione`.
- **Cambio di formato di scambio:** `!` dopo l'ambito e riga `BREAKING CHANGE:` nel corpo, con riferimento alla decisione. Esempio: `feat(mcp-linee-guida)!: aggiunge campo url ai risultati di ricerca`.

## Conseguenze

- `main` è sempre la versione da mostrare o consegnare; `dev` può essere temporaneamente instabile.
- Lo storico di `dev` ha un commit per PR, leggibile per tipo e componente.
- Dopo il merge di questa proposta: creare `dev` e impostarlo come branch di destinazione predefinito per le PR (facoltativo, dalle impostazioni GitHub).
