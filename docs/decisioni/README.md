# Registro delle decisioni

Qui finiscono le decisioni che riguardano più di un componente o che vanno spiegate alla presentazione: struttura, confini tra componenti, formati di scambio, scelte tecniche non ovvie. Il processo è descritto in [0001](0001-registro-decisioni-e-approvazione.md).

## Indice

| N. | Decisione | Stato |
|---|---|---|
| 0001 | [Registro delle decisioni e approvazione tramite Pull Request](0001-registro-decisioni-e-approvazione.md) | accettata |
| 0002 | [Struttura del repository e responsabilità](0002-struttura-repository-e-responsabilita.md) | accettata |
| 0003 | [Due server MCP separati](0003-server-mcp-separati.md) | accettata |
| 0004 | [Dati versionati e indicizzazione automatica](0004-dati-versionati-e-indicizzazione-automatica.md) | accettata |
| 0005 | [Flusso Git e Conventional Commits](0005-flusso-git-e-conventional-commits.md) | sostituita da 0006 |
| 0006 | [Flusso Git e Conventional Commits (con branch `chore/`)](0006-flusso-git-con-branch-chore.md) | proposta |
| 0007 | [Procedura di lavoro e blocchi automatici](0007-procedura-di-lavoro-e-blocchi.md) | proposta |

## Modello

Copiare in un nuovo file `NNNN-titolo-breve.md` (numero successivo all'ultimo).

```markdown
# NNNN. Titolo

- **Stato:** proposta | accettata | sostituita da NNNN
- **Data:** AAAA-MM-GG
- **Proponente:** nome
- **Componenti coinvolti:** web | agente | mcp_prodotti | mcp_linee_guida | tutti

## Contesto
Quale problema o vincolo rende necessaria la decisione (con riferimento a consegna.md se pertinente).

## Alternative considerate
Le opzioni valutate, ciascuna con vantaggi e svantaggi.

## Decisione
Cosa si fa.

## Conseguenze
Cosa cambia per ciascun componente, cosa diventa più facile o più difficile, limiti noti.
```
