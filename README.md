# anomaly_detection_emb

Parte embedded/server del progetto di rilevazione anomalie stradali.

Il sistema e' organizzato intorno a un server Qt che comunica con una board ST via UART, decodifica i dati provenienti dal protocollo binario e li espone al client tramite D-Bus. Il server mantiene anche un set di parametri configurabili dal client e persistiti localmente.

## Architettura

Schema logico consigliato:

```text
Board ST
  -> UART transport
  -> frame parser
  -> message codec
  -> application services
  -> D-Bus API
  -> client
```

Nel codice attuale:

- `server/uart/uart_receiver.*` gestisce `QSerialPort` e riceve byte dalla UART.
- `server/uart/uart_protocol.*` ricostruisce i frame, valida CRC e decodifica il payload IMU.
- `server/telemetry/TelemetryService.*` converte i raw IMU in grandezze fisiche e conserva l'ultimo stato applicativo.
- `server/connection/dbusserver.*` espone i dati IMU al client tramite D-Bus.
- `server/parameters/*` contiene modello, default, validazione e persistenza dei parametri.
- `server/dbus/*` espone i parametri tramite D-Bus.
- `client/*` contiene il client Qt/QML.

## Protocollo UART

Il protocollo UART e' documentato in `server/uart/UART_PROTOCOL.md`.

Formato frame:

```text
SOF0 | SOF1 | TYPE | LEN | PAYLOAD | CRC16
```

Il parser e' generico: per aggiungere un nuovo messaggio si definisce un nuovo `TYPE` e si aggiunge il relativo codec applicativo.

## Parametri

I parametri sono definiti da:

```text
id
type
value
defaultValue
min
max
unit
```

I default sono compilati nel codice in `ParameterLut`.

All'avvio il server:

1. carica i default;
2. cerca un file persistente `QCborMap`;
3. applica solo i valori persistiti validi;
4. ignora valori sconosciuti o non validi.

Quando il client modifica un parametro, il valore passa da `ParameterManager`, viene validato e poi salvato su file.

Il path del file puo' essere configurato con:

```bash
ANOMALY_PARAMETER_FILE=/path/to/parameters.cbor
```

Se la variabile non e' impostata, viene usata la directory di configurazione dell'applicazione.

## D-Bus Parametri

Il servizio parametri registra:

```text
service: com.myapp.Parameters
object:  /ParameterManager
iface:   com.bikeDashboard.ParameterManager
```

Metodi principali:

```text
ListParameters() -> as
GetParameter(id) -> object path
GetParameterInfo(id) -> a{sv}
```

Ogni parametro e' esposto come oggetto D-Bus:

```text
/Parameter/<id>
```

Interfaccia:

```text
com.bikeDashboard.Parameter
```

Espone:

```text
Id
Type
Value
DefaultValue
Min
Max
Unit
GetValue()
SetValue(value) -> bool
Reset() -> bool
ValueChanged(value)
```

## Configurazione UART

Variabili runtime:

```bash
ANOMALY_UART_PORT=/dev/ttyACM0
ANOMALY_UART_BAUD=115200
```

Esempio:

```bash
ANOMALY_UART_PORT=/dev/ttyACM0 ANOMALY_UART_BAUD=921600 ./server/appserver
```

## Build

Il progetto usa CMake e Qt 6.

Esempio:

```bash
cmake -S . -B build
cmake --build build
```

Componenti Qt usati dal server:

```text
Core
DBus
SerialPort
LinguistTools
```
