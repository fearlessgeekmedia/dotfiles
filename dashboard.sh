#!/usr/bin/env bash

PORT=8080
OSNAME=$(uname)

generate_html() {
    # Gather system information
    HOSTNAME=$(hostname)
    UPTIME=$(uptime | sed 's/.*up \([^,]*\).*/\1/')
    LOAD=$(uptime | awk -F'load average:' '{print $2}')
    
    # Memory info (works on Linux and macOS)
    if [[ "$OSNAME" == "Linux" ]]; then
        MEM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
        MEM_USED=$(free -h | awk '/^Mem:/ {print $3}')
        MEM_FREE=$(free -h | awk '/^Mem:/ {print $4}')
        DISK_INFO=$(df -h / | awk 'NR==2 {print $3 " used of " $2 " (" $5 " full)"}')
    elif [[ "$OSNAME" == "Darwin" ]]; then
        MEM_TOTAL=$(sysctl -n hw.memsize | awk '{print $1/1024/1024/1024 "GB"}')
        MEM_USED=$(vm_stat | awk '/Pages active/ {print $3*4096/1024/1024/1024 "GB"}' | sed 's/\..*/GB/')
        MEM_FREE=$(vm_stat | awk '/Pages free/ {print $3*4096/1024/1024/1024 "GB"}' | sed 's/\..*/GB/')
        DISK_INFO=$(df -h / | awk 'NR==2 {print $3 " used of " $2 " (" $5 " full)"}')
    else
        MEM_TOTAL="N/A"
        MEM_USED="N/A"
        MEM_FREE="N/A"
        DISK_INFO="N/A"
    fi
    
    # CPU info
    if [[ "$OSNAME" == "Linux" ]]; then
        CPU_MODEL=$(lscpu | grep "Model name" | cut -d':' -f2 | xargs)
        CPU_CORES=$(nproc)
    elif [[ "$OSNAME" == "Darwin" ]]; then
        CPU_MODEL=$(sysctl -n machdep.cpu.brand_string)
        CPU_CORES=$(sysctl -n hw.ncpu)
    else
        CPU_MODEL="Unknown"
        CPU_CORES="Unknown"
    fi
    
    # Current time
    CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S")
    
    # Top processes by CPU
    if [[ "$OSNAME" == "Linux" ]]; then
        TOP_PROCS=$(ps aux --sort=-%cpu 2>/dev/null | tail -n +2 | head -5 | awk '{
            cmd=$11; 
            for(i=12;i<=NF;i++) cmd=cmd" "$i; 
            if(length(cmd)>60) cmd=substr(cmd,1,60)"...";
            printf "<tr><td>%s</td><td>%.1f%%</td><td>%.1f%%</td><td>%s</td></tr>\n", cmd, $3, $4, $2
        }')
    else
        TOP_PROCS=$(ps aux -r 2>/dev/null | tail -n +2 | head -5 | awk '{
            cmd=$11; 
            for(i=12;i<=NF;i++) cmd=cmd" "$i; 
            if(length(cmd)>60) cmd=substr(cmd,1,60)"...";
            printf "<tr><td>%s</td><td>%.1f%%</td><td>%.1f%%</td><td>%s</td></tr>\n", cmd, $3, $4, $2
        }')
    fi
    
    cat << EOF
HTTP/1.1 200 OK
Content-Type: text/html
Connection: close

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>System Dashboard - $HOSTNAME</title>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    body {
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        padding: 20px;
    }
    .container {
        max-width: 1200px;
        margin: 0 auto;
    }
    header {
        text-align: center;
        color: white;
        margin-bottom: 30px;
    }
    h1 {
        font-size: 2.5em;
        margin-bottom: 10px;
        text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
    }
    .subtitle {
        font-size: 1.1em;
        opacity: 0.9;
    }
    .dashboard {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 20px;
        margin-bottom: 20px;
    }
    .card {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 15px;
        padding: 25px;
        box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        backdrop-filter: blur(10px);
    }
    .card h2 {
        color: #667eea;
        margin-bottom: 15px;
        font-size: 1.3em;
        border-bottom: 2px solid #667eea;
        padding-bottom: 10px;
    }
    .stat {
        display: flex;
        justify-content: space-between;
        padding: 10px 0;
        border-bottom: 1px solid #eee;
    }
    .stat:last-child {
        border-bottom: none;
    }
    .stat-label {
        color: #666;
        font-weight: 500;
    }
    .stat-value {
        color: #333;
        font-weight: 600;
    }
    .refresh-btn {
        display: block;
        margin: 20px auto;
        padding: 12px 30px;
        background: white;
        color: #667eea;
        border: none;
        border-radius: 25px;
        font-size: 1em;
        font-weight: 600;
        cursor: pointer;
        box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        transition: transform 0.2s;
    }
    .refresh-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(0,0,0,0.3);
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
    }
    th {
        background: #667eea;
        color: white;
        padding: 10px;
        text-align: left;
        font-weight: 600;
    }
    td {
        padding: 8px 10px;
        border-bottom: 1px solid #eee;
    }
    tr:hover {
        background: #f5f5f5;
    }
    .time {
        text-align: center;
        color: white;
        font-size: 0.9em;
        margin-top: 20px;
        opacity: 0.8;
    }
</style>
<script>
    // Auto-refresh every 5 seconds
    setTimeout(() => location.reload(), 5000);
</script>
</head>
<body>
<div class="container">
    <header>
        <h1>🖥️ System Dashboard</h1>
        <div class="subtitle">$HOSTNAME running $OSNAME</div>
    </header>
    
    <div class="dashboard">
        <div class="card">
            <h2>System Info</h2>
            <div class="stat">
                <span class="stat-label">Hostname</span>
                <span class="stat-value">$HOSTNAME</span>
            </div>
            <div class="stat">
                <span class="stat-label">OS</span>
                <span class="stat-value">$OSNAME</span>
            </div>
            <div class="stat">
                <span class="stat-label">Uptime</span>
                <span class="stat-value">$UPTIME</span>
            </div>
            <div class="stat">
                <span class="stat-label">Load Average</span>
                <span class="stat-value">$LOAD</span>
            </div>
        </div>
        
        <div class="card">
            <h2>CPU</h2>
            <div class="stat">
                <span class="stat-label">Model</span>
                <span class="stat-value">$CPU_MODEL</span>
            </div>
            <div class="stat">
                <span class="stat-label">Cores</span>
                <span class="stat-value">$CPU_CORES</span>
            </div>
        </div>
        
        <div class="card">
            <h2>Memory</h2>
            <div class="stat">
                <span class="stat-label">Total</span>
                <span class="stat-value">$MEM_TOTAL</span>
            </div>
            <div class="stat">
                <span class="stat-label">Used</span>
                <span class="stat-value">$MEM_USED</span>
            </div>
            <div class="stat">
                <span class="stat-label">Free</span>
                <span class="stat-value">$MEM_FREE</span>
            </div>
        </div>
        
        <div class="card">
            <h2>Disk Usage</h2>
            <div class="stat">
                <span class="stat-label">Root Partition</span>
                <span class="stat-value">$DISK_INFO</span>
            </div>
        </div>
    </div>
    
    <div class="card">
        <h2>Top Processes by CPU</h2>
        <table>
            <thead>
                <tr>
                    <th>Process</th>
                    <th>CPU %</th>
                    <th>MEM %</th>
                    <th>PID</th>
                </tr>
            </thead>
            <tbody>
                $TOP_PROCS
            </tbody>
        </table>
    </div>
    
    <button class="refresh-btn" onclick="location.reload()">🔄 Refresh Now</button>
    
    <div class="time">Last updated: $CURRENT_TIME</div>
</div>
</body>
</html>
EOF
}

# Handle the "serve" command for socat
if [[ "$1" == "serve" ]]; then
    generate_html
    exit 0
fi

# Serve the dashboard
echo "🚀 System Dashboard starting on http://localhost:$PORT"
echo "Press Ctrl+C to stop"

# Get full paths
BASH_BIN="$(readlink -f /proc/$$/exe)"
SCRIPT_PATH="$(readlink -f "$0")"

echo "DEBUG: BASH_BIN=$BASH_BIN"
echo "DEBUG: SCRIPT_PATH=$SCRIPT_PATH"
echo "DEBUG: Will execute: $BASH_BIN $SCRIPT_PATH serve"
socat TCP-LISTEN:$PORT,fork,reuseaddr SYSTEM:"$BASH_BIN $SCRIPT_PATH serve"
