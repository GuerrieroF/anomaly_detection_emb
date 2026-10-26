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

## Libreria grafica

Il client usa il modulo QML `Dashboard.Ui`, organizzato per categorie di
componenti e personalizzabile tramite token globali e proprietà per istanza.
La libreria `epr_qt_widgets_large_lib` rimane solo come riferimento nei sorgenti.
Struttura, API, esempi e test sono descritti nella
[guida di dashboard_ui](client/dashboard_ui/README.md).

Il provider cartografico può essere configurato in `client/map.local.ini`
(escluso da Git), partendo da `client/map.example.ini`. Per Thunderforest
impostare `provider=thunderforest`, `apiKey` e `style`; il default senza chiave
è OpenStreetMap standard. CMake copia il file accanto al client. Il percorso
runtime può essere sovrascritto con `ANOMALY_MAP_CONFIG`.

La sidebar apre quattro pagine:

- **Veicolo**: tachimetro a sinistra e assetto a destra, con pitch sopra il roll.
- **Accelerazioni**: accelerazione Z a sinistra, laterale/longitudinale a destra.
- **Mappa**: mappa GPS a tutta pagina.
- **Impostazioni** (icona in basso): sezioni provvisorie IMU e GPS, senza controlli attivi.

Le prime due pagine dividono lo spazio in due colonne uguali. Le pagine restano
istanziate durante la navigazione per conservare storico dei grafici e zoom
mappa; l'acquisizione dei campioni prosegue anche nelle altre pagine.

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

## Mappa del client

La build predefinita usa la mappa Qt Location/OpenStreetMap esistente. Per scegliere
Google Maps durante la configurazione CMake:

```sh
cmake -S . -B build-google -DQt6_DIR=/percorso/Qt/lib/cmake/Qt6 -DANOMALY_MAP_BACKEND=google
cmake --build build-google
```

La variante Google richiede Qt 6 WebEngineQuick, accesso Internet e una chiave
Google Cloud con Maps JavaScript API abilitata e fatturazione configurata.
Copiare `client/map.example.ini` in `client/map.local.ini` e impostare:

```ini
[map]
provider=google
apiKey=LA_PROPRIA_CHIAVE
mapId=IL_PROPRIO_MAP_ID
```

Il Map ID serve per i marker avanzati; `DEMO_MAP_ID` è usato solo se
`mapId` manca. Il file locale è escluso da Git e viene copiato accanto
all'eseguibile da CMake; dopo averlo cambiato, riconfigurare CMake. È anche
possibile specificare il percorso con `ANOMALY_MAP_CONFIG`.

La pagina riceve dal client `hasPosition`, `latitude`, `longitude`,
`heading` e `anomalies`. Ogni anomalia è un oggetto
`{ latitude, longitude, label }`; `type` può sostituire `label`.
Le coordinate non valide vengono ignorate. Il GPS e la direzione arrivano già
dal client D-Bus. Il flusso delle anomalie non è ancora prodotto dal server:
il client espone la proprietà `anomalies` pronta per quel collegamento.

La pagina HTML è incorporata come risorsa Qt. Google avverte che le pagine
caricate con uno schema locale come `qrc:` possono omettere il referrer, e
quindi una chiave limitata per sito web può essere rifiutata. Per una
distribuzione con restrizioni sul referrer, occorre ospitare la pagina su
un'origine HTTPS autorizzata e configurare il client per caricarla.
Questa variante carica solo la risorsa locale. Evitare chiavi senza restrizioni
in produzione.

## Spegnimento del dispositivo

Il pulsante sotto le impostazioni apre una conferma e richiede lo spegnimento
tramite `org.freedesktop.login1.Manager.PowerOff` sul bus di sistema.
Su un dispositivo embedded senza agente di autenticazione, il client può ricevere
«permesso negato» se l'utente non è autorizzato da Polkit.

Sul dispositivo, dalla radice del repository, installare la policy specificando
l'utente Linux che esegue `appclient`:

```sh
sudo sh scripts/install-power-policy.sh NOME_UTENTE_CLIENT
```

Lo script crea il gruppo `anomaly-power`, aggiunge l'utente indicato e installa
`scripts/polkit/49-anomaly-power.rules`. Il permesso riguarda lo spegnimento,
anche in presenza di altre sessioni; non autorizza il superamento dei blocchi
(inhibitor) di spegnimento. Tutti i processi dell'utente nel gruppo ricevono questo
permesso. Riavviare la sessione dell'utente (o il dispositivo) per aggiornare i
gruppi del processo client. L'applicazione continua a essere eseguita senza root.

Verifica senza spegnere il dispositivo, dalla stessa sessione del client:

```sh
id -nG
busctl call org.freedesktop.login1 /org/freedesktop/login1 \
    org.freedesktop.login1.Manager CanPowerOff
```

Il gruppo deve includere `anomaly-power`; il risultato atteso di `CanPowerOff` è
`yes`. Se permane un rifiuto, controllare eventuali policy locali più restrittive
e i log di `polkit`/`systemd-logind` sul dispositivo.

### Copia degli script sul target

Dal PC, nella cartella principale del progetto, copiare l'intera cartella
`scripts` nella home dell'utente SSH del target:

```sh
scp -r scripts UTENTE_SSH@INDIRIZZO_TARGET:~/scripts
```

Sul target, installare la policy indicando l'utente che esegue `appclient`:

```sh
sudo sh ~/scripts/install-power-policy.sh NOME_UTENTE_CLIENT
```

Per individuare l'utente con il client aperto: `ps -C appclient -o user=`.
La policy viene installata in `/etc/polkit-1/rules.d/49-anomaly-power.rules`;
la cartella `~/scripts` conserva i file di installazione.

Su target Debian privi del servizio Polkit, installarlo prima della policy:

```sh
sudo apt-get update
sudo apt-get install polkitd
sudo systemctl start polkit
```
