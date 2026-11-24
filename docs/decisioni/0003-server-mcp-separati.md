# 0003. Due server MCP separati

- **Stato:** accettata (2026-11-24, PR #1)
- **Data:** 2026-11-24
- **Proponente:** Michele Molent
- **Componenti coinvolti:** agente, mcp_prodotti, mcp_linee_guida, web (Docker Compose)

## Contesto

La consegna chiede che gli strumenti siano esposti da "almeno un server MCP". Lo strumento `cerca_linee_guida` è di Michele (documenti e retrieval), gli strumenti sui prodotti sono di Emanuele. Va deciso dove vive `cerca_linee_guida`.

## Alternative considerate

- **Un solo server MCP (di Emanuele), con il retrieval come libreria importata.** Un container in meno, ma il codice di Michele gira dentro quello di Emanuele: per provare lo strumento serve il suo server, e il confine di responsabilità si confonde.
- **Due server MCP: `mcp_linee_guida` (Michele) e `mcp_prodotti` (Emanuele).** Ognuno possiede uno strumento da cima a fondo, lo prova e lo dimostra da solo, anche prima che l'agente esista. Costa un container in più e richiede che l'agente si colleghi a due server, cosa supportata dalle librerie client MCP.
- **Retrieval come servizio HTTP interrogato da uno strumento MCP di Emanuele.** Aggiunge un passaggio senza vantaggi rispetto alla precedente e lascia il contratto a metà tra due persone.

## Decisione

Due server MCP in due container: `mcp_linee_guida` espone `cerca_linee_guida`; `mcp_prodotti` espone `cerca_prodotto`, `verifica_allergeni` ed eventualmente `confronta_prodotti`. L'agente si collega a entrambi, con indirizzi configurati via `.env`.

## Conseguenze

- Il trasporto MCP (per esempio HTTP in streaming) deve essere lo stesso per entrambi i server e va indicato nel README.
- Docker Compose include un servizio in più.
- Ogni server si può provare in isolamento con un client MCP generico.
