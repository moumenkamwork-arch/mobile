@echo off
cd /d "E:\Personal Work Projects\promo_mobile"
"C:\flutter_sdk\flutter\bin\flutter.bat" run -d web-server --web-port 8765 --dart-define=PROMOO_USE_MOCKS=true
