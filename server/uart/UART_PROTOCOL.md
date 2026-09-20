# UART Protocol (Generic v1)

Questo protocollo e` implementato lato server in:
- `server/uart/uart_protocol.cpp`

## Frame

Ogni frame ha questo formato binario (little-endian):

1. `SOF0` (1 byte) = `0xAA`
2. `SOF1` (1 byte) = `0x55`
3. `TYPE` (1 byte)
4. `LEN` (1 byte) = dimensione payload in byte
5. `PAYLOAD` (`LEN` byte)
6. `CRC16` (2 byte, little-endian)

Il CRC16 e` calcolato su: `TYPE + LEN + PAYLOAD` (senza SOF), polinomio `0x1021`, init `0xFFFF`.

## Comando di avvio GPS inviato alla scheda

I comandi verso il firmware usano un header diverso dai frame dati ricevuti:
`SOF0 | SOF1 | VERSION | TYPE | LENGTH | MODE | CRC16`.
Il CRC16-CCITT (init `0xFFFF`) copre `VERSION + TYPE + LENGTH + MODE`.

All'apertura riuscita della porta UART il server invia una volta il comando
di avvio GPS: `AA 55 01 02 01 01 04 BF`.
`TYPE=0x02` identifica il GPS e `MODE=0x01` richiede l'avvio.
L'accodamento dei byte alla porta viene registrato come `TX in coda`;
non costituisce conferma dell'esecuzione da parte del firmware.

## TYPE message

Il protocollo e` generico: `TYPE` identifica il payload applicativo.

Tipi attualmente usati:
- `0x01` = IMU sample
- `0x02` = GPS sample

Tipi futuri (esempi):
- `0x02` = temperatura board
- `0x03` = stato batteria
- `0x10` = eventi anomaly

## Payload TYPE `0x01` (IMU, LEN = 12)

Ordine campi (`int16_t`, little-endian):

1. `accel_x`
2. `accel_y`
3. `accel_z`
4. `gyro_x`
5. `gyro_y`
6. `gyro_z`

## Payload TYPE `0x02` (GPS, LEN = 31)

Tutti i campi multibyte sono little-endian. Gli offset sono relativi al payload:

| Offset | Byte | Campo | Unita' |
| --- | ---: | --- | --- |
| 0 | 4 | `timestamp_ms` (`uint32`) | tick STM32, ms |
| 4 | 4 | `utc_time_ms` (`uint32`) | ms da mezzanotte |
| 8 | 4 | `utc_date_ddmmyy` (`uint32`) | DDMMYY |
| 12 | 4 | `latitude_deg_e7` (`int32`) | gradi x 10^7 |
| 16 | 4 | `longitude_deg_e7` (`int32`) | gradi x 10^7 |
| 20 | 4 | `altitude_mm` (`int32`) | millimetri |
| 24 | 2 | `speed_cms` (`uint16`) | cm/s |
| 26 | 2 | `heading_cdeg` (`uint16`) | centesimi di grado |
| 28 | 1 | `satellites` (`uint8`) | numero |
| 29 | 1 | `fix_type` (`uint8`) | tipo fix |
| 30 | 1 | `valid` (`uint8`) | 0 o 1 |

Il frame completo e' lungo 37 byte, compresi header e CRC16.

## Configurazione runtime server

- `ANOMALY_UART_PORT` (default: `/dev/ttyACM0`)
- `ANOMALY_UART_BAUD` (default: `115200`)

Esempio:

```bash
ANOMALY_UART_PORT=/dev/ttyACM0 ANOMALY_UART_BAUD=921600 ./server/appserver
```

## Nota evoluzione protocollo

Per aggiungere nuovi dati non serve modificare il parser del frame.
Serve solo:
1. definire un nuovo `TYPE`
2. definire il formato payload di quel `TYPE`
3. aggiungere il relativo decoder nel layer applicativo
