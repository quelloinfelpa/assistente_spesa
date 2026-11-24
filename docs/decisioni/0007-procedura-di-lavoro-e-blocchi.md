# 0007. Procedura di lavoro e blocchi automatici

- **Stato:** proposta
- **Data:** 2026-11-24
- **Proponente:** Michele Molent
- **Componenti coinvolti:** tutti

## Contesto

Le regole delle decisioni [0001](0001-registro-decisioni-e-approvazione.md) e [0006](0006-flusso-git-con-branch-chore.md) erano solo istruzioni in `CLAUDE.md`. Ognuno lavora con il proprio Claude Code, che può sbagliare o ricevere una richiesta che le scavalca, e su GitHub nulla impediva un merge senza approvazioni (è successo con la PR #1). Il rischio è intralciarsi a vicenda: modifiche in cartelle altrui, codice costruito su decisioni non ancora approvate, lavoro che entra in `main` o `dev` senza revisione.

## Alternative considerate

- **Solo istruzioni in `CLAUDE.md`.** Nessun costo, ma nessuna garanzia.
- **Istruzioni + protezione dei branch su GitHub.** Blocco reale, valido anche per chi lavora senza Claude; gratuito sui repository pubblici.
- **Istruzioni + protezione + hook di Claude Code.** Ferma l'errore sul computer di chi lavora, prima di arrivare a GitHub, con un messaggio che spiega cosa fare.

## Decisione

Tutte e tre, insieme:

1. **Procedura in `CLAUDE.md`** ("Procedura di lavoro"): prima di iniziare si parte da `dev` aggiornato, si controllano PR aperte e decisioni in proposta, si verifica che il lavoro stia nella propria cartella; prima di chiudere si verifica, si aggiornano documentazione e decisioni, si apre la PR. Non si scrive codice che dipende da una decisione non ancora accettata.
2. **Protezione su GitHub** di `main` e `dev`, valida anche per gli amministratori: PR obbligatoria, almeno un'approvazione, conversazioni risolte, approvazioni annullate da nuove modifiche, niente force push né cancellazione; su `dev` solo storia lineare (squash merge). Attiva dal 2026-11-24.
3. **Hook condiviso di Claude Code** (`.claude/settings.json` + `.claude/hooks/proteggi-branch.sh`): blocca commit, merge, push e rebase su `main` o `dev`, i push espliciti verso `main` o `dev` e l'unione di PR da riga di comando.
4. **Le PR le unisce una persona** da GitHub, dopo l'approvazione. Claude apre le PR ma non le unisce.

## Conseguenze

- GitHub richiede almeno un'approvazione per ogni PR; la regola delle tre approvazioni per decisioni e cartelle altrui (0001, 0006) resta una convenzione da rispettare.
- L'hook richiede `bash` (presente con Git su Windows, macOS e Linux). Lo script deve avere fine riga LF: va unita prima la PR del `.gitattributes`.
- L'hook riconosce i comandi dal testo: scatta anche se quelle parole compaiono in un messaggio o nel corpo di una PR. In quel caso si riformula il testo.
- Per disattivarlo in un caso eccezionale serve modificare `.claude/settings.json`, quindi una PR.
