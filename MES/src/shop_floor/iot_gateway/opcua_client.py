import time
import random
import threading
from typing import Callable, Dict

class OpcUaClient:
    """
    Simulates an OPC-UA client connecting to shop floor hardware (PLCs/CNCs).
    """
    def __init__(self, machine_id: str, endpoint_url: str):
        self.machine_id = machine_id
        self.endpoint_url = endpoint_url
        self.connected = False
        self.callbacks = []
        self._running = False

    def connect(self):
        """Simulate connection handshake."""
        print(f"[{self.machine_id}] Connecting to OPC-UA server at {self.endpoint_url}...")
        time.sleep(0.5)
        self.connected = True
        print(f"[{self.machine_id}] Connected.")
        self._start_subscription()

    def subscribe_telemetry(self, callback: Callable[[Dict], None]):
        """Register a callback for data change events."""
        self.callbacks.append(callback)

    def _start_subscription(self):
        """Internal thread to mock incoming data stream."""
        self._running = True
        thread = threading.Thread(target=self._simulate_data_stream)
        thread.daemon = True
        thread.start()

    def _simulate_data_stream(self):
        """Generates random machine telemetry."""
        while self._running:
            if self.connected:
                telemetry = {
                    "machine_id": self.machine_id,
                    "timestamp": time.time(),
                    "status": random.choice(["RUNNING", "IDLE", "RUNNING", "RUNNING", "ERROR"]),
                    "temperature": round(random.uniform(20.0, 85.0), 1),
                    "vibration": round(random.uniform(0.1, 2.5), 2),
                    "spindle_speed": random.randint(0, 12000)
                }
                
                # Notify listeners
                for cb in self.callbacks:
                    cb(telemetry)
            
            time.sleep(2) # Update every 2 seconds

    def disconnect(self):
        self._running = False
        self.connected = False
        print(f"[{self.machine_id}] Disconnected.")
