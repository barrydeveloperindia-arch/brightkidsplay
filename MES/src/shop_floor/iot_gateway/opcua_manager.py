import asyncio
import random
from typing import Callable, Any

# Try import, fall back to mock if not installed (robustness)
try:
    from asyncua import Client, Node
    HAS_REAL_OPCUA = True
except ImportError:
    HAS_REAL_OPCUA = False

class OpcUaManager:
    """
    Unified Interface for Simple Mocks AND Real Hardware.
    """
    def __init__(self, use_real_hardware: bool = False):
        self.use_real_hardware = use_real_hardware and HAS_REAL_OPCUA
        self.clients = {} # machine_id -> Client

    async def connect_machine(self, machine_id: str, endpoint_url: str):
        if self.use_real_hardware:
            try:
                client = Client(url=endpoint_url)
                await client.connect()
                self.clients[machine_id] = client
                print(f"[OPC-UA] Connected to REAL hardware: {machine_id}")
            except Exception as e:
                print(f"[OPC-UA] Failed to connect {machine_id}: {e}")
        else:
            print(f"[OPC-UA] Connected to MOCK hardware: {machine_id}")

    async def read_node(self, machine_id: str, node_id: str) -> Any:
        if self.use_real_hardware and machine_id in self.clients:
            try:
                client = self.clients[machine_id]
                node = client.get_node(node_id)
                return await node.read_value()
            except Exception as e:
                print(f"[OPC-UA] Read Error {machine_id}: {e}")
                return None
        else:
            # Simulation Logic
            if "temp" in node_id.lower():
                return 20.0 + random.random() * 5
            return "RUNNING"

    async def disconnect_all(self):
        if self.use_real_hardware:
            for mid, client in self.clients.items():
                try:
                    await client.disconnect()
                except:
                    pass
