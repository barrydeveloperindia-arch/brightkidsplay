import json
import random
from typing import Dict, Any

class LocalLLMClient:
    """
    Simulates a client for a locally hosted Large Language Model (e.g., Llama-3-70B).
    In a real deployment, this would use HTTP requests to an inference server (e.g., vLLM or Ollama).
    """
    def __init__(self, model: str = "llama-3-70b-instruct", endpoint: str = "http://localhost:8000/v1"):
        self.model = model
        self.endpoint = endpoint
        print(f"Initialized LocalLLMClient for model: {self.model} at {self.endpoint}")

    def generate(self, system_prompt: str, user_context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Simulates generating a dispatch plan based on the prompt and order context.
        Returns a standardised JSON object.
        """
        # In a real system, we would construct the payload and POST to self.endpoint
        # payload = {
        #     "model": self.model,
        #     "messages": [
        #         {"role": "system", "content": system_prompt},
        #         {"role": "user", "content": json.dumps(user_context)}
        #     ]
        # }
        
        # Simulating the LLM's "thinking" and structured output
        # The prompt asks for standardized JSON.
        
        # Mocking intelligent decision making based on input features (simplistic)
        material = user_context.get("technical_requirements", {}).get("material", "Generic")
        
        assigned_machine = "CNC-001"
        if "Inconel" in material:
            assigned_machine = "CNC-HighPerf-05" # Harder material needs better machine
        elif "PLA" in material:
            assigned_machine = "3D-Printer-02"
            
        # Simulating nesting orientation (0, 90, 180, 270)
        orientation = random.choice([0, 90, 180, 270])
        
        response_plan = {
            "machine": assigned_machine,
            "orientation": orientation,
            "estimated_runtime": random.randint(3600, 10800), # 1-3 hours
            "notes": f"Selected {assigned_machine} based on material {material}. Optimized for tool wear."
        }
        
        return response_plan
