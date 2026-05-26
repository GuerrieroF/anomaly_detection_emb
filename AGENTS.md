# AGENTS.md

Contesto per Codex quando lavora su questo repository.

## Progetto

Questo repository contiene la parte embedded/server di un sistema per rilevare anomalie stradali. Il server Qt comunica con una board ST via UART, interpreta frame binari e pubblica dati e parametri verso un client tramite D-Bus.

## Regole architetturali

- Tenere separati transport, protocollo, codec, logica applicativa e D-Bus.
- `server/uart` deve occuparsi di byte, frame e payload binari.
- `server/telemetry` deve contenere conversioni fisiche, stato telemetrico e futura logica applicativa sui sensori.
- `server/parameters` deve possedere modello, validazione e persistenza dei parametri.
- `server/dbus` deve essere solo un layer di esposizione verso client.
- Evitare che classi D-Bus scrivano direttamente file o contengano logica applicativa.
- Evitare che il client acceda direttamente al file dei parametri.

## Parametri

- I default stanno in `server/parameters/ParameterLut.cpp`.
- Le modifiche runtime devono passare da `ParameterManager::setParameterValue`.
- La validazione deve restare in `Parameter`/`ParameterManager`.
- La persistenza usa `QCborMap`.
- Il file persistente puo' essere sovrascritto con `ANOMALY_PARAMETER_FILE`.
- Se un valore persistito non e' valido, deve essere ignorato senza rompere l'avvio.

## D-Bus

- Il servizio parametri espone `com.bikeDashboard.ParameterManager` su `/ParameterManager`.
- Ogni parametro puo' essere esposto come `/Parameter/<id>`.
- I valori dei parametri devono viaggiare come `QVariant`/D-Bus variant quando possibile.
- `SetValue` deve restituire esito booleano, cosi' il client sa se la validazione e' fallita.

## UART

- Il protocollo UART e' documentato in `server/uart/UART_PROTOCOL.md`.
- Il parser frame non deve conoscere il significato applicativo dei payload.
- Per nuovi messaggi aggiungere un `TYPE` e un codec dedicato.
- Non mettere conversioni fisiche o anomaly detection dentro il parser UART.
- Non rimettere conversioni IMU dentro `DBusServer`; usare `TelemetryService`.

## Stile

- C++17 e Qt 6.
- Preferire modifiche piccole e coerenti con lo stile esistente.
- Non modificare file generati a meno che non sia necessario mantenerli sincronizzati con XML D-Bus.
- Quando si cambia un'interfaccia D-Bus, aggiornare anche `dbusinterfaces/*.xml`.

## Verifica

Prima di consegnare modifiche:

- eseguire una build CMake se l'ambiente Qt e' disponibile;
- controllare che `server/CMakeLists.txt` includa eventuali nuovi file;
- verificare che le firme D-Bus in XML, adaptor e classi wrapper siano coerenti.
