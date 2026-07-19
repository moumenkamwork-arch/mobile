@echo off
cd /d "E:\Personal Work Projects\promo_mobile"
"C:\flutter_sdk\flutter\bin\flutter.bat" run -d web-server --web-port 8766 --dart-define=PROMOO_BASE_URL=http://localhost:3000/api/v1
