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

## TYPE message

Il protocollo e` generico: `TYPE` identifica il payload applicativo.

Tipi attualmente usati:
- `0x01` = IMU sample

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
