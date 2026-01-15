import torch
import torch.nn as nn
from typing import List

class TransactionCategorizer(nn.Module):
    """
    LSTM Model to categorize transactions based on description and amount.
    Scaffold Implementation.
    """

    def __init__(self, vocab_size: int, embedding_dim: int, hidden_dim: int, output_dim: int):
        super(TransactionCategorizer, self).__init__()
        self.embedding = nn.Embedding(vocab_size, embedding_dim)
        self.lstm = nn.LSTM(embedding_dim, hidden_dim, batch_first=True)
        self.fc = nn.Linear(hidden_dim, output_dim)
        self.softmax = nn.LogSoftmax(dim=1)

    def forward(self, x):
        # x shape: [batch_size, seq_len]
        embedded = self.embedding(x)
        # embedded shape: [batch_size, seq_len, embedding_dim]
        
        lstm_out, _ = self.lstm(embedded)
        # lstm_out shape: [batch_size, seq_len, hidden_dim]
        
        # Take the output of the last time step
        final_hidden = lstm_out[:, -1, :] 
        
        out = self.fc(final_hidden)
        return self.softmax(out)

class CategorizationService:
    """
    Service wrapper for the LSTM model.
    Handles data preprocessing (tokenization) and inference.
    """
    
    def __init__(self):
        # Hyperparameters (Scaffold values)
        self.vocab_size = 5000
        self.embedding_dim = 64
        self.hidden_dim = 128
        self.output_dim = 10 # Number of categories (e.g., Food, Travel, Utilities)
        
        self.model = TransactionCategorizer(
            self.vocab_size, self.embedding_dim, self.hidden_dim, self.output_dim
        )
        # In real implementation: Load state_dict from saved model file
        
        # Categories mapping
        self.categories = [
            "Food & Dining", "Travel", "Utilities", "Shopping", 
            "Groceries", "Entertainment", "Health", "Investment", 
            "Transfer", "Other"
        ]

    def predict(self, description: str, amount: float) -> str:
        """
        Predicts the category for a single transaction.
        """
        # 1. Preprocess description -> token indices (Mock)
        # real impl would use a proper tokenizer tailored to financial data
        tokenized_input = torch.tensor([[1, 2, 3]]) # Mock tensor
        
        # 2. Inference
        self.model.eval()
        with torch.no_grad():
            output = self.model(tokenized_input)
            predicted_idx = torch.argmax(output, dim=1).item()
            
        return self.categories[predicted_idx % len(self.categories)]

    def train(self, training_data: List[dict]):
        """
        Retrains the model with user corrections.
        """
        pass
