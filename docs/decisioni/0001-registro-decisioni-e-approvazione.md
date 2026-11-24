# 0001. Registro delle decisioni e approvazione tramite Pull Request

- **Stato:** proposta
- **Data:** 2026-11-24
- **Proponente:** Michele Molent
- **Componenti coinvolti:** tutti

## Contesto

Lavoriamo in tre, ognuno con il proprio Claude Code locale. La consegna chiede che i formati di scambio tra componenti siano concordati all'inizio e documentati nel README, e alla presentazione ognuno deve saper spiegare anche le scelte degli altri. Serve un posto unico dove le decisioni vengono proposte, discusse, approvate e conservate con il loro storico, leggibile anche dai Claude locali.

## Alternative considerate

- **File di decisione nel repository, approvati con Pull Request.** Decisioni, documentazione e codice stanno insieme e cambiano negli stessi commit; lo storico è in git e nella discussione della PR; i Claude locali li leggono come qualsiasi file. Richiede di usare le PR.
- **GitHub Issues o Discussions.** Comode per discutere, ma restano fuori dai file: i Claude locali non le vedono senza interrogare GitHub e la documentazione si scollega dal codice.
- **Documento condiviso esterno (Google Doc o simili).** Commenti facili, ma storico separato dal repository e nessun legame con il codice.

## Decisione

1. Ogni decisione è un file `docs/decisioni/NNNN-titolo.md` secondo il modello in [README](README.md).
2. Una decisione entra con una Pull Request da un branch `docs/` verso `dev` (flusso in [0005](0005-flusso-git-e-conventional-commits.md)). Gli altri due membri la rivedono: commentano, chiedono modifiche o le fanno direttamente sul branch della PR. Quando tutti e tre hanno approvato (revisione "Approve" su GitHub, o commento esplicito di chi ha aperto la PR), lo stato diventa `accettata` e si fa il merge.
3. Una decisione accettata non si riscrive. Se cambia, si apre una nuova decisione che la sostituisce; nella vecchia si modifica solo la riga di stato (`sostituita da NNNN`).
4. Le decisioni che toccano un solo componente e non cambiano interfacce restano al responsabile del componente e vanno nella sua documentazione (`docs/<componente>/`), senza approvazione degli altri.
5. Quando una decisione cambia un formato di scambio, la stessa PR aggiorna il README e il codice che lo usa.

## Conseguenze

- Nessun costo: PR e revisioni sono gratuite, non si usano GitHub Actions né servizi esterni.
- Emanuele e Carlo vanno aggiunti come collaboratori del repository.
- L'approvazione è una convenzione, non un blocco tecnico. Facoltativamente si può attivare la protezione del branch `main` con revisione obbligatoria (gratuita sui repository pubblici).
- `CLAUDE.md` istruisce i Claude locali a leggere le decisioni accettate prima di lavorare e a proporne una nuova quando una modifica tocca interfacce o scelte condivise.
