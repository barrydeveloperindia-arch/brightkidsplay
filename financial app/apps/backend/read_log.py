import os

log_path = r"c:\Users\abrbh\Documents\Antigravity\financial app\dashboard_population.log"

if os.path.exists(log_path):
    try:
        with open(log_path, 'r', encoding='utf-16') as f:
             lines = f.readlines()
             content = "".join(lines[-200:])
    except:
        with open(log_path, 'r', encoding='utf-8') as f:
             lines = f.readlines()
             content = "".join(lines[-200:])

    with open("captured_error.log", "w", encoding="utf-8") as f_out:
        f_out.write(content)
    print("Log captured to captured_error.log")
else:
    print("Log file not found.")
