import os
from flask import Flask, render_template, request, jsonify
from openai import OpenAI
import numpy as np
from typing import List, Dict

app = Flask(__name__)

# Initialize OpenAI client
client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

# Dummy knowledge base with embeddings (pre-computed mock embeddings)
KNOWLEDGE_BASE = [
    {
        "text": "Python is a high-level, interpreted programming language known for its simplicity and readability. It was created by Guido van Rossum and first released in 1991.",
        "embedding": [0.1, 0.2, 0.3, 0.4, 0.5]
    },
    {
        "text": "Machine Learning is a subset of artificial intelligence that enables systems to learn and improve from experience without being explicitly programmed. It focuses on developing algorithms that can access data and use it to learn for themselves.",
        "embedding": [0.2, 0.3, 0.4, 0.5, 0.6]
    },
    {
        "text": "Azure Web App Service is a fully managed platform for building, deploying, and scaling web apps. It supports multiple programming languages including .NET, Java, Node.js, Python, and PHP.",
        "embedding": [0.3, 0.4, 0.5, 0.6, 0.7]
    },
    {
        "text": "RAG (Retrieval Augmented Generation) is an AI framework that combines information retrieval with text generation. It retrieves relevant information from a knowledge base and uses it to generate more accurate and contextual responses.",
        "embedding": [0.4, 0.5, 0.6, 0.7, 0.8]
    },
    {
        "text": "OpenAI is an AI research organization that develops artificial intelligence technologies. Their products include GPT models, DALL-E for image generation, and various APIs for developers.",
        "embedding": [0.5, 0.6, 0.7, 0.8, 0.9]
    }
]


def get_embedding(text: str) -> List[float]:
    """Get embedding for text using OpenAI API"""
    try:
        response = client.embeddings.create(
            model="text-embedding-3-small",
            input=text
        )
        return response.data[0].embedding
    except Exception as e:
        print(f"Error getting embedding: {e}")
        # Return a random embedding as fallback for demo
        return np.random.rand(1536).tolist()


def cosine_similarity(a: List[float], b: List[float]) -> float:
    """Calculate cosine similarity between two vectors"""
    a = np.array(a)
    b = np.array(b)
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))


def retrieve_relevant_context(query: str, top_k: int = 2) -> List[str]:
    """Retrieve most relevant documents from knowledge base"""
    query_embedding = get_embedding(query)
    
    # Calculate similarities
    similarities = []
    for doc in KNOWLEDGE_BASE:
        sim = cosine_similarity(query_embedding, doc['embedding'])
        similarities.append((doc['text'], sim))
    
    # Sort by similarity and get top_k
    similarities.sort(key=lambda x: x[1], reverse=True)
    return [text for text, _ in similarities[:top_k]]


def generate_response(query: str, context: List[str]) -> str:
    """Generate response using OpenAI with retrieved context"""
    context_text = "\n\n".join(context)
    
    prompt = f"""Based on the following context, answer the user's question. If the context doesn't contain relevant information, say so politely.

Context:
{context_text}

Question: {query}

Answer:"""
    
    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are a helpful assistant that answers questions based on the provided context. Be concise and accurate."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.7,
            max_tokens=500
        )
        return response.choices[0].message.content
    except Exception as e:
        return f"Error generating response: {str(e)}"


@app.route('/')
def home():
    """Render the main page"""
    return render_template('index.html')


@app.route('/api/chat', methods=['POST'])
def chat():
    """Handle chat requests"""
    data = request.json
    query = data.get('query', '')
    
    if not query:
        return jsonify({'error': 'No query provided'}), 400
    
    # Retrieve relevant context
    context = retrieve_relevant_context(query)
    
    # Generate response
    response = generate_response(query, context)
    
    return jsonify({
        'response': response,
        'context': context
    })


@app.route('/api/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({'status': 'healthy'})


if __name__ == '__main__':
    # For local development
    app.run(debug=True, host='0.0.0.0', port=8000)
