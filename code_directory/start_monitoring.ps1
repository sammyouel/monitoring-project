# Start Prometheus
Start-Process -FilePath "C:\Users\Kumar\OneDrive\Desktop\projects\grafana_promethus\prometheus-2.53.3.windows-amd64\prometheus.exe" -WindowStyle Minimized

# Start Grafana
Start-Process -FilePath "C:\Program Files\GrafanaLabs\grafana\bin\grafana-server.exe" -WindowStyle Minimized

# Start Windows Exporter
Start-Process -FilePath "C:\Program Files\windows_exporter\windows_exporter.exe" -WindowStyle Minimized

Write-Output "All monitoring tools started successfully."
