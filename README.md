# Grafana + Prometheus

### **Step 1: Install Prometheus**

![image.png](C:\Users\Kumar\Downloads\7bfc5d6b-f2f9-4c1c-84f6-77130ca5e8f0_Export-d9cbf959-c643-49f3-be93-91ecb79101b1\image.png)

1. **Download Prometheus:**
    - Visit the Prometheus download page.
    - Download the **Windows ZIP** file for the latest version (e.g., `prometheus-2.53.3.windows-amd64`).
2. **Extract Prometheus:**
    - Extract the ZIP file to a folder. For example:
        
        `C:\Users\Kumar\OneDrive\Desktop\projects\grafana_promethus\prometheus-2.53.3.windows-amd64`
        
    - Open PowerShell and navigate to the folder:
        
        `cd "C:\Users\Kumar\OneDrive\Desktop\projects\grafana_promethus\prometheus-2.53.3.windows-amd64"`
        
3. **Verify Installation:**
    - Run the following command to check Prometheus is installed correctly:
        
        `.\prometheus.exe --version`
        

### **Step 2: Configure Prometheus**

![image.png](image%201.png)

1. **Modify the** `prometheus.yml` **File:**
    - Open the `prometheus.yml` configuration file:
        
        `code "C:\Users\Kumar\OneDrive\Desktop\projects\grafana_promethus\prometheus-2.53.3.windows-amd64\prometheus.yml"`
        
    - Add a job for Windows Exporter under `scrape_configs`:
        
        `scrape_configs:
          - job_name: 'windows_exporter'
            scrape_interval: 5s
            static_configs:
              - targets: ['localhost:9182']`
        
    - **Start Prometheus:**
        - Run Prometheus using:
            
            `.\prometheus.exe --config.file=prometheus.yml`
            
    - **Access Prometheus:**
        - Open your browser and go to:
            
            `http://localhost:9090`
            

### **Step 3: Install Windows Exporter**

![image.png](image%202.png)

1. **Download the MSI Installer:**
    - Visit the Windows Exporter GitHub page.
    - Download the latest `.msi` installer.
2. **Run the Installer:**
    - Double-click the MSI file and follow these steps:
        - Choose the default installation path (e.g., `C:\WindowsExporter`).
        - Enable the **Firewall Exception** during setup.
        - Leave the **list of collectors** as `[defaults]`.
3. **Start Windows Exporter:**
    - Navigate to the installation folder and run:
        
        `.\windows_exporter.exe`
        
4. **Verify Windows Exporter:**
    - Open your browser and check:
        
        `http://localhost:9182/metrics`
        

![image.png](image%203.png)

### **Step 4: Install Grafana**

1. **Download Grafana:**
    - Visit the Grafana download page.
    - Download the Windows installer for the latest version (e.g., `grafana-11.5.2`).
2. **Run the Installer:**
    - Install Grafana using the default path:
        
        `C:\Program Files\GrafanaLabs\grafana`
        
3. **Start the Grafana Server:**
    - Navigate to the Grafana installation folder and run:
        
        `cd "C:\Program Files\GrafanaLabs\grafana"
        .\bin\grafana-server.exe`
        
4. **Access Grafana:**
    - Open your browser and go to:
        
        `http://localhost:3000`
        
    - Log in with the default credentials:
        - **Username:** `admin`
        - **Password:** `admin`
    - Change the password when prompted( i set my own password : sammyouel)
- 

![image.png](image%204.png)

### **Step 5: Integrate Prometheus with Grafana**

1. **Add Prometheus as a Data Source:**
    - In Grafana, go to **Connections → Data Sources → Add Data Source**.
    - Choose **Prometheus** from the list.
    - Configure it with:
        - **URL:** `http://localhost:9090`
        - **Access:** `Server (default)`
    - Click **Save & Test**.
2. **Verify the Connection:**
    - If successful, you’ll see the message: *"Data source is working."*
3. **Start Visualizing:**
    - Begin building your dashboard using metrics from Prometheus (e.g., CPU usage, memory usage).

Enter the PromQL Query:
`windows_cpu_time_total` :

![image.png](image%205.png)

Enter the PromQL Query:

`go_memstats_alloc_bytes`:

![image.png](image%206.png)

### **Scripting: Automate Startup Using PowerShell**

Create a single PowerShell script to start Prometheus, Grafana, and Windows Exporter together.

1. **Create the Script File:**
    - Open a new file in VS Code and name it `start_monitoring.ps1`.
2. **Add the Following Script:**
    
    ```
    # Start Prometheus
    Start-Process -FilePath "C:\Prometheus\prometheus.exe" -WindowStyle Minimized
    
    # Start Grafana
    Start-Process -FilePath "C:\Program Files\GrafanaLabs\grafana\bin\grafana-server.exe" -WindowStyle Minimized
    
    # Start Windows Exporter
    Start-Process -FilePath "C:\WindowsExporter\windows_exporter.exe" -WindowStyle Minimized
    
    Write-Output "All monitoring tools started successfully."
    
    ```
    
3. **Run the Script:**
    
    ![image.png](image%207.png)
    
    - Execute the script in PowerShell:
        
        `.\start_monitoring.ps1`
        
4. **Add the Script to Startup:**
    - Place the script in the **Startup folder** to run it automatically on system boot:
        
        `$startupPath = [Environment]::GetFolderPath("Startup")
        Copy-Item -Path "C:\YourPath\start_monitoring.ps1" -Destination`
        

```
$startupPath = [Environment]::GetFolderPath("Startup")
$startupPath

```

![image.png](image%208.png)

Next :

```
$startupPath = [Environment]::GetFolderPath("Startup")
Copy-Item -Path "C:\Users\Kumar\OneDrive\Desktop\projects\grafana_promethus\prometheus-2.53.3.windows-amd64\start_monitoring.ps1" -Destination $startupPath

```

- Paste the above script into your PowerShell console or script editor.
- Execute it by pressing Enter.
- Confirm the file was copied successfully by checking the **Startup folder**:
    
    powershell
    
    `Test-Path "$startupPath\start_monitoring.ps1"`
    
    If it returns `True`, the script was successfully added to the Startup folder.
    

## Alerting: Configure Alerts in Prometheus

Adding alerts for high CPU usage or low memory situations is essential for proactive monitoring.

1. **Edit** `prometheus.yml` **to Define Alerts:**
    - Open the `prometheus.yml` file in your Prometheus directory:
        
        `code "C:\Users\Kumar\OneDrive\Desktop\projects\grafana_promethus\prometheus-2.53.3.windows-amd64\prometheus.yml"`
        
        - 
    - Add an `alerting` rule configuration:
        
        
        ```
        rule_files:
          - "C:/Users/Kumar/OneDrive/Desktop/projects/grafana_promethus/prometheus-2.53.3.windows-amd64/alert.rules.yml"
        
        ```
        
2. **Create an** `alert.rules.yml` **File:**
    - In the same directory, create the `alert.rules.yml` file:
        
        `code "C:\Users\Kumar\OneDrive\Desktop\projects\grafana_promethus\prometheus-2.53.3.windows-amd64\alert.rules.yml"`
        
    - Add the following example alert rules to the yaml file:
        
        ---
        
        groups:
        
        - name: System Alerts
        rules:
            - alert: HighCPUUsage
            expr: sum(rate(windows_cpu_time_total[1m])) > 0.75
            for: 2m
            labels:
            severity: critical
            annotations:
            summary: High CPU usage detected
            description: CPU usage has exceeded 75% for more than 2 minutes. Investigate
            immediately.
            - alert: LowMemoryAvailable
            expr: windows_memory_available_bytes / windows_memory_total_bytes < 0.20
            for: 2m
            labels:
            severity: warning
            annotations:
            summary: Low Memory Warning
            description: Available memory is less than 20% of the total memory for over 2
            minutes.

**Restart Prometheus to Apply Changes**

1. Save both `prometheus.yml` and `alert.rules.yml`.
2. Restart Prometheus to load the new configurations:
    
    powershell
    
    `cd "C:\Users\Kumar\OneDrive\Desktop\projects\grafana_promethus\prometheus-2.53.3.windows-amd64"
    .\prometheus.exe --config.file=prometheus.yml`
    
3. **Verify Alerts in Prometheus:**
    - Go to `http://localhost:9090/alerts` to view active alerts.

### **Step-by-Step: Set Up a GitHub Actions Workflow**

1. **Ensure Your Project Is on GitHub:**
    - If it’s not already, push your project to a GitHub repository:
        
        bash
        
        `git init
        git add .
        git commit -m "Initial commit"
        git branch -M main
        git remote add origin <your-repo-URL>
        git push -u origin main`
        
2. **Create a Workflow File:**
    - Navigate to your repository on GitHub.
    - Go to the **Actions** tab → **New Workflow** → **Set up a workflow yourself**.
    - Create a file named `.github/workflows/ci-cd-pipeline.yml`.
3. **Add the Following Workflow:**
    
    yaml
    
    `name: CI/CD Pipeline for Monitoring Project
    
    on:
      push:
        branches:
          - main
    
    jobs:
      build:
        runs-on: windows-latest
    
        steps:
        - name: Checkout Code
          uses: actions/checkout@v3
    
        - name: Validate Prometheus Config
          run: |
            prometheus.exe --config.file=prometheus.yml --dry-run
    
        - name: Validate Alert Rules
          run: |
            prometheus.exe --config.file=prometheus.yml --rules.alerts.alertmanager.rules
    
      test:
        runs-on: windows-latest
        needs: build
    
        steps:
        - name: Checkout Code
          uses: actions/checkout@v3
    
        - name: Test Prometheus Connection
          run: |
            curl http://localhost:9090/api/v1/alerts
    
      deploy:
        runs-on: windows-latest
        needs: test
    
        steps:
        - name: Deploy Updates
          run: |
            # Any deployment-specific commands go here, e.g., restart services`
    
4. **Save and Push the Workflow:**
    - Commit the `.github/workflows/ci-cd-pipeline.yml` file.
    - Push it to the `main` branch.
5. **Run the Workflow:**
    - Every time you push changes to the repository, GitHub Actions will automatically trigger the pipeline.

## Modified the code and these were the changes :

### **. Reorganized Project Structure**

- Created a dedicated directory named `code_directory` within the main project folder:
    
    `C:\Users\Kumar\OneDrive\Desktop\projects\grafana_promethus\prometheus-2.53.3.windows-amd64\code_directory`
    
- Moved all custom scripts and files (e.g., `start_monitoring.ps1`) into the `code_directory` for better organization.

### **2. Updated** `start_monitoring.ps1` **Script**

- Adjusted paths in `start_monitoring.ps1` to ensure compatibility with the new project structure:
    
    powershell
    
    `# Example:
    Start-Process -FilePath "C:\Users\Kumar\OneDrive\Desktop\projects\grafana_promethus\prometheus-2.53.3.windows-amd64\prometheus.exe" -WindowStyle Minimized`
    
- Verified that all services (Prometheus, Grafana, and Windows Exporter) start successfully from the script.

### **3. Managed Git Configuration and Repository**

- Configured Git with your username and email:
    
    bash
    
    `git config --global user.name "sammyouel"
    git config --global user.email "samuel.kumar.ctrldev@gmail.com"`
    
- Added a `.gitignore` file to exclude unnecessary files and folders:
    
    plaintext
    
    `prometheus.exe
    promtool.exe
    alertmanager.exe
    data/
    logs/
    console_libraries/
    consoles/
    *.zip
    *.tar.gz
    .vscode/
    !prometheus.yml
    !alert.rules.yml
    !LICENSE
    !NOTICE
    !README.md`
    

### **4. Resolved Merge Conflicts**

- Encountered and resolved merge conflicts in `README.md`. Combined or prioritized content as needed:
    
    plaintext
    
    `# monitoring-project
    our grafana-promethus integrated code base`
    
- Marked the conflict as resolved:
    
    bash
    
    `git add README.md
    git commit -m "Resolved merge conflict in README.md"`
    

### **5. Created a New Repository**

- Set up a new GitHub repository to host the reorganized project:
    - Repository Name: `monitoring-project`.
    - Added the new repository as the remote:
        
        bash
        
        `git remote add origin https://github.com/sammyouel/monitoring-project.git`
        

### **6. Pushed the Project to GitHub**

- Initialized Git in the main project directory and pushed the changes:
    
    bash
    
    `git init
    git add .
    git commit -m "Initial commit for reorganized project"
    git branch -M main
    git push -u origin main`
    

### **7. Tested the Setup Locally**

- Ran the `start_monitoring.ps1` script:
    
    powershell
    
    `pwsh -File "C:\Users\Kumar\OneDrive\Desktop\projects\grafana_promethus\prometheus-2.53.3.windows-amd64\code_directory\start_monitoring.ps1"`
    
- Confirmed the following:
    - Prometheus was accessible at `http://localhost:9090`.
    - Grafana was accessible at `http://localhost:3000`.
    - Windows Exporter metrics were available at `http://localhost:9182/metrics`.

### **8. Shared and Deployed the Project**

- **Shared Repository**:
    - Shared the GitHub repository link with collaborators.
    - Included `LICENSE`, `README.md`, `NOTICE`, and other critical files for better project clarity.
- **Deployed Dashboards**:
    - Set up Prometheus and Grafana on a local/remote server.
    - Shared dashboard access via:
        - `http://<server-IP>:9090` for Prometheus.
        - `http://<server-IP>:3000` for Grafana.
    - Optionally secured access using SSL and user authentication.
