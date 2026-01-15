import json
import datetime
from typing import List, Dict, Any

class VectorStoreClient:
    """
    A lightweight, local implementation of a Vector Store (Memory).
    Uses simplified exact matching or keyword matching instead of high-dimensional embeddings 
    to function without heavy ML dependencies like PyTorch/FAISS for this prototype.
    """
    def __init__(self, collection_name: str = "dispatch_history"):
        self.collection_name = collection_name
        self.memory_store: List[Dict[str, Any]] = []
        print(f"Initialized VectorStoreClient for collection: {self.collection_name}")

    def add(self, features: str, plan: Dict[str, Any], status: str):
        """
        Stores a decision event in the "Memory".
        """
        entry = {
            "timestamp": datetime.datetime.now().isoformat(),
            "features_vector_proxy": features, # Storing the string representation as our "vector"
            "plan": plan,
            "status": status,
            "success": status == "Complete" # Simplification
        }
        self.memory_store.append(entry)
        # In a real app, this would persist to disk/database
        
    def query(self, vector: str, filter: Dict[str, Any], top_k: int = 3) -> List[Dict[str, Any]]:
        """
        Retrieves relevant past experiences.
        """
        # Simulating semantic search by looking for substring matches in our feature string
        # This mocks the "nearest neighbor" search
        
        results = []
        for entry in self.memory_store:
            # Apply Filter (e.g., success=True)
            if filter.get("success") is not None and entry.get("success") != filter.get("success"):
                continue
                
            # Similarity score proxy (keyword overlap)
            # A real vector DB would do cosine similarity here
            score = self._calculate_similarity(vector, entry["features_vector_proxy"])
            
            if score > 0:
                results.append(entry)
                
        # Sort by relevance and take top K
        results.sort(key=lambda x: x.get("score", 0), reverse=True)
        return results[:top_k]

    def _calculate_similarity(self, input_features: str, stored_features: str) -> float:
        """
        Mock similarity function.
        """
        input_tokens = set(input_features.lower().split())
        stored_tokens = set(stored_features.lower().split())
        
        intersection = input_tokens.intersection(stored_tokens)
        return len(intersection) / len(input_tokens) if input_tokens else 0.0
