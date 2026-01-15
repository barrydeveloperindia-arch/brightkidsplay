import time
from src.shop_floor.digital_twin.service import DigitalTwinService

def test_module_b():
    print("=== Testing Module B: Shop Floor Execution ===")
    
    twin_service = DigitalTwinService()
    
    # Register Mock Machines
    twin_service.register_machine("CNC-001", "opc.tcp://192.168.1.10:4840")
    twin_service.register_machine("3D-Printer-02", "opc.tcp://192.168.1.11:4840")
    
    print("Monitoring shop floor for 6 seconds...")
    for i in range(3):
        time.sleep(2)
        snapshot = twin_service.get_shop_floor_status()
        print(f"\n--- Snapshot T+{i*2}s ---")
        for machine in snapshot:
            print(f"Machine {machine['machine_id']}: {machine['status']} | Temp: {machine['temperature']}C")
            
    print("\n=== Module B Test Complete ===")
    
    # Cleanup (Mock disconnect logic implicitly handled by program exit, but good practice)
    for client in twin_service.machines.values():
        client.disconnect()

if __name__ == "__main__":
    test_module_b()
