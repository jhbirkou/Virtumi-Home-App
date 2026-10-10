#!/usr/bin/env bash
# Installiert Virtumi Home auf einem verbundenen iPhone (nur macOS).
# Auf dem Mac ausführen: ./scripts/install_iphone.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Dieses Skript muss auf macOS ausgeführt werden." >&2
  exit 1
fi

if [[ -z "${SUPABASE_URL:-}" || -z "${SUPABASE_ANON_KEY:-}" ]]; then
  echo "Bitte vor dem Start setzen:" >&2
  echo "  export SUPABASE_URL=https://YOUR_PROJECT.supabase.co" >&2
  echo "  export SUPABASE_ANON_KEY=YOUR_ANON_KEY" >&2
  exit 1
fi

echo "==> flutter pub get"
flutter pub get

echo "==> CocoaPods (ios/)"
(cd ios && pod install)

DEVICE_ID="${IOS_DEVICE_ID:-}"
if [[ -z "$DEVICE_ID" ]]; then
  echo "==> Verbundene iOS-Geräte:"
  flutter devices
  DEVICE_ID="$(flutter devices --machine | python3 -c "
import json, sys
devices = json.load(sys.stdin)
ios = [d for d in devices if d.get('platform') == 'ios' and d.get('emulator') is False]
if not ios:
    sys.exit(1)
print(ios[0]['id'])
" 2>/dev/null || true)"
fi

if [[ -z "$DEVICE_ID" ]]; then
  echo "Kein physisches iPhone gefunden. Optional: export IOS_DEVICE_ID=<id>" >&2
  echo "Alternativ: open ios/Runner.xcworkspace und in Xcode deployen." >&2
  open ios/Runner.xcworkspace
  exit 0
fi

echo "==> flutter run auf Gerät $DEVICE_ID"
flutter run -d "$DEVICE_ID" \
  --dart-define=SUPABASE_URL="$SUPABASE_URL" \
  --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY"
