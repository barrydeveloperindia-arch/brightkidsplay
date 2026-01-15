from decimal import Decimal

class CostingEngine:
    """
    Calculates final job cost based on actual execution metrics.
    """
    def __init__(self):
        # Base rates per hour for different machines
        self.machine_rates = {
            "CNC-001": Decimal("150.00"),
            "CNC-HighPerf-05": Decimal("250.00"),
            "3D-Printer-02": Decimal("45.00")
        }
        
        # Material costs per unit (suppose kg for mock)
        self.material_rates = {
            "PLA": Decimal("25.00"),
            "Inconel": Decimal("800.00"),
            "Steel": Decimal("50.00")
        }
    
    def calculate_job_cost(self, machine_id: str, material: str, runtime_minutes: int, material_usage: float) -> dict:
        """
        Returns detailed cost breakdown.
        """
        hourly_rate = self.machine_rates.get(machine_id, Decimal("100.00"))
        runtime_hours = Decimal(runtime_minutes) / Decimal(60)
        
        runtime_cost = round(hourly_rate * runtime_hours, 2)
        
        mat_rate = self.material_rates.get(material, Decimal("10.00"))
        material_cost = round(mat_rate * Decimal(material_usage), 2)
        
        overhead = round((runtime_cost + material_cost) * Decimal("0.15"), 2) # 15% overhead
        
        total = runtime_cost + material_cost + overhead
        
        return {
            "runtime_cost": float(runtime_cost),
            "material_cost": float(material_cost),
            "overhead": float(overhead),
            "total_excl_tax": float(total),
            "currency": "USD"
        }
