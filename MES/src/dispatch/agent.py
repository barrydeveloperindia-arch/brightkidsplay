from typing import Dict, Any, Tuple
from .llm_client import LocalLLMClient
from .vector_store import VectorStoreClient
from .interference_engine import GeometricKernel
import uuid

class DispatchAgent:
    def __init__(self):
        self.llm = LocalLLMClient()
        self.memory_db = VectorStoreClient()
        self.interference_engine = GeometricKernel()

    def dispatch_order(self, new_order: Dict[str, Any]) -> str:
        """
        Main entry point for "Memory-Augmented" dispatching.
        new_order expects dict with keys: 'order_id', 'cad_file_path', 'technical_requirements'
        """
        # 1. Feature Extraction
        # Convert mechanical reqs into a vectorizable string format
        order_features = self.extract_features(new_order.get("cad_file_path", ""), new_order.get("technical_requirements", {}))
        
        # 2. Memory Retrieval (The "Anti-Hallucination" Step)
        # Find past jobs with similar geometries and materials that succeeded
        successful_precedents = self.memory_db.query(
            vector=order_features, 
            filter={"success": True}, 
            top_k=3
        )
        
        # 3. Prompt Construction
        # Inject precedents into the context to ground the LLM
        system_prompt = self.build_prompt(
            role="Senior Manufacturing Engineer",
            context=f"Here are successful past strategies for similar parts: {successful_precedents}",
            task="Assign best machine and orientation."
        )
        
        # 4. AI Strategy Generation
        candidate_plan = self.llm.generate(system_prompt, new_order)
        
        # 5. Deterministic Validation (Interference Check)
        # Never trust the LLM fully for geometry; verify with math.
        is_safe, collision_data = self.interference_engine.simulate_nesting(
            machine=candidate_plan.get("machine"),
            part_geometry=new_order.get("cad_file_path"),
            orientation=candidate_plan.get("orientation")
        )
        
        if is_safe:
            # 6. Commit to Digital Thread (Mock)
            job_id = str(uuid.uuid4())
            print(f"[Dispatch] Order {new_order.get('order_id')} assigned to {candidate_plan.get('machine')}. Job ID: {job_id}")
            
            # Store this decision logic in short-term memory
            self.memory_db.add(features=order_features, plan=candidate_plan, status="Tentative")
            return job_id
        else:
            # Recursion with negative feedback would happen here
            print(f"[Dispatch] Plan Failed Validation: {collision_data}")
            return self.handle_conflict(new_order, candidate_plan, collision_data)

    def extract_features(self, cad_path: str, specs: Dict[str, Any]) -> str:
        """Simple functional feature extractor."""
        material = specs.get("material", "Unknown")
        # In reality, this would read geometric properties from the component
        return f"Material:{material} Source:{cad_path}"

    def build_prompt(self, role: str, context: str, task: str) -> str:
        return f"Role: {role}\nContext: {context}\nTask: {task}"

    def handle_conflict(self, order, failed_plan, collision_data):
        """Re-prompts LLM with specific collision error data."""
        # For prototype, just return Error
        return "DISPATCH_FAILED_COLLISION"
