import json
import boto3
import os
import logging
from datetime import datetime
from botocore.exceptions import ClientError

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize AWS clients
bedrock_runtime = boto3.client('bedrock-runtime', region_name=os.environ.get('AWS_REGION', 'us-east-1'))
s3_client = boto3.client('s3')

# Configuration
BEDROCK_MODEL_ID = os.environ.get('BEDROCK_MODEL_ID', 'anthropic.claude-3-sonnet-20240229-v1:0')
KNOWLEDGE_BASE_BUCKET = os.environ.get('KNOWLEDGE_BASE_BUCKET')
MAX_TOKENS = int(os.environ.get('MAX_TOKENS', '2048'))
TEMPERATURE = float(os.environ.get('TEMPERATURE', '0.7'))

def get_knowledge_context(query):
    """
    Retrieve relevant knowledge base documents from S3 based on query keywords.
    """
    try:
        if not KNOWLEDGE_BASE_BUCKET:
            logger.warning("No knowledge base bucket configured")
            return ""
        
        # Simple keyword matching to determine which documents to retrieve
        query_lower = query.lower()
        documents_to_fetch = []
        
        if any(keyword in query_lower for keyword in ['password', 'reset', 'login', 'credentials']):
            documents_to_fetch.append('password-reset.md')
        
        if any(keyword in query_lower for keyword in ['aws', 'ec2', 's3', 'lambda', 'error', 'troubleshoot']):
            documents_to_fetch.append('aws-troubleshooting.md')
        
        if any(keyword in query_lower for keyword in ['onboard', 'new', 'start', 'first day', 'setup']):
            documents_to_fetch.append('onboarding-faqs.md')
        
        # If no specific match, fetch all documents
        if not documents_to_fetch:
            documents_to_fetch = ['password-reset.md', 'aws-troubleshooting.md', 'onboarding-faqs.md']
        
        context = []
        for doc in documents_to_fetch:
            try:
                response = s3_client.get_object(Bucket=KNOWLEDGE_BASE_BUCKET, Key=doc)
                content = response['Body'].read().decode('utf-8')
                context.append(f"--- {doc} ---\n{content}\n")
                logger.info(f"Retrieved knowledge document: {doc}")
            except ClientError as e:
                if e.response['Error']['Code'] != 'NoSuchKey':
                    logger.error(f"Error retrieving {doc}: {str(e)}")
        
        return "\n".join(context)
    
    except Exception as e:
        logger.error(f"Error in get_knowledge_context: {str(e)}")
        return ""

def invoke_bedrock(prompt, system_prompt):
    """
    Invoke Amazon Bedrock with the given prompt using Claude 3 Sonnet.
    """
    try:
        # Prepare the request body for Claude 3
        request_body = {
            "anthropic_version": "bedrock-2023-05-31",
            "max_tokens": MAX_TOKENS,
            "temperature": TEMPERATURE,
            "system": system_prompt,
            "messages": [
                {
                    "role": "user",
                    "content": prompt
                }
            ]
        }
        
        logger.info(f"Invoking Bedrock model: {BEDROCK_MODEL_ID}")
        
        # Invoke the model
        response = bedrock_runtime.invoke_model(
            modelId=BEDROCK_MODEL_ID,
            body=json.dumps(request_body)
        )
        
        # Parse the response
        response_body = json.loads(response['body'].read())
        
        # Extract the text from Claude 3 response
        if 'content' in response_body and len(response_body['content']) > 0:
            return response_body['content'][0]['text']
        else:
            logger.error("Unexpected response format from Bedrock")
            return "I apologize, but I encountered an error processing your request."
    
    except ClientError as e:
        logger.error(f"Bedrock ClientError: {str(e)}")
        error_code = e.response['Error']['Code']
        
        if error_code == 'AccessDeniedException':
            return "Error: Access denied to Bedrock model. Please check IAM permissions."
        elif error_code == 'ResourceNotFoundException':
            return "Error: Bedrock model not found. Please verify model ID and region."
        else:
            return f"Error invoking Bedrock: {error_code}"
    
    except Exception as e:
        logger.error(f"Unexpected error invoking Bedrock: {str(e)}")
        return "I apologize, but I encountered an unexpected error."

def lambda_handler(event, context):
    """
    Main Lambda handler for the IT support chatbot.
    """
    try:
        logger.info(f"Received event: {json.dumps(event)}")
        
        # Parse the request body
        if 'body' in event:
            body = json.loads(event['body']) if isinstance(event['body'], str) else event['body']
        else:
            body = event
        
        # Extract the user query
        user_query = body.get('query', '').strip()
        
        if not user_query:
            return {
                'statusCode': 400,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Headers': 'Content-Type',
                    'Access-Control-Allow-Methods': 'POST, OPTIONS'
                },
                'body': json.dumps({
                    'error': 'No query provided',
                    'message': 'Please provide a query in the request body'
                })
            }
        
        # Get relevant knowledge base context
        knowledge_context = get_knowledge_context(user_query)
        
        # Construct the system prompt with context
        system_prompt = """You are an IT support assistant for our organization. Your role is to help employees with:
- Password reset procedures
- AWS troubleshooting and common issues
- Onboarding questions and new employee setup

Guidelines:
1. Be helpful, professional, and concise
2. Provide step-by-step instructions when applicable
3. Use the knowledge base information provided to give accurate answers
4. If you don't know something, admit it and suggest contacting IT support directly
5. Maintain a friendly but professional tone
6. Focus on security best practices

Use the following knowledge base information to answer questions:

{knowledge_context}

If the knowledge base doesn't contain relevant information, provide general IT support guidance based on best practices."""
        
        system_prompt = system_prompt.format(knowledge_context=knowledge_context if knowledge_context else "No specific knowledge base documents available.")
        
        # Invoke Bedrock
        ai_response = invoke_bedrock(user_query, system_prompt)
        
        # Log the interaction
        logger.info(f"Query: {user_query[:100]}... | Response length: {len(ai_response)}")
        
        # Return the response
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
            'body': json.dumps({
                'query': user_query,
                'response': ai_response,
                'timestamp': datetime.utcnow().isoformat(),
                'model': BEDROCK_MODEL_ID
            })
        }
    
    except json.JSONDecodeError as e:
        logger.error(f"JSON decode error: {str(e)}")
        return {
            'statusCode': 400,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': 'Invalid JSON in request body'
            })
        }
    
    except Exception as e:
        logger.error(f"Unexpected error in lambda_handler: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': 'Internal server error',
                'message': str(e)
            })
        }
