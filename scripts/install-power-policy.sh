#!/bin/sh
set -eu
if [ "$(id -u)" -ne 0 ] || [ "$#" -ne 1 ]; then
    echo "Uso: sudo sh scripts/install-power-policy.sh UTENTE_DEL_CLIENT" >&2
    exit 1
fi
id "$1" >/dev/null
policy_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
if [ ! -f "$policy_dir/polkit/49-anomaly-power.rules" ]; then
    echo "Policy mancante: copiare sul target tutta la cartella scripts." >&2
    exit 1
fi
if ! systemctl cat polkit.service >/dev/null 2>&1; then
    echo "Servizio Polkit assente. Su Debian installarlo e attivarlo:" >&2
    echo "  sudo apt-get update" >&2
    echo "  sudo apt-get install polkitd" >&2
    echo "  sudo systemctl start polkit" >&2
    echo "Poi rieseguire questo script." >&2
    exit 1
fi
install -d -o root -g root -m 0755 /etc/polkit-1/rules.d
getent group anomaly-power >/dev/null || groupadd --system anomaly-power
usermod -a -G anomaly-power "$1"
install -o root -g root -m 0644 "$policy_dir/polkit/49-anomaly-power.rules" \
    /etc/polkit-1/rules.d/49-anomaly-power.rules
echo "Permesso di spegnimento installato per $1. Riavviare la sessione dell'utente prima del test."
