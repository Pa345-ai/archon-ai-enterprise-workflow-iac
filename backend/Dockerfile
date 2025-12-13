FROM python:3.15-rc-alpine3.22
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
EXPOSE 8000

# --- START OF ENTERPRISE SECURITY FIX ---

# 1. Create a shell script (/app/entrypoint.sh) to assemble the full DB URL.
# This prevents the full connection string from being visible in config files 
# or passed around outside of the secure Fargate runtime.
RUN echo '#!/bin/sh' > /app/entrypoint.sh
# Assemble the full secure URL from the individual, Fargate-injected variables
RUN echo 'export DATABASE_URL="postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:5432/${DB_NAME}"' >> /app/entrypoint.sh
# Execute the main application command using the constructed URL
RUN echo 'exec uvicorn app.main:app --host 0.0.0.0 --port 8000' >> /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# 2. Set the ENTRYPOINT to execute the secure script
ENTRYPOINT ["/app/entrypoint.sh"]

# --- END OF ENTERPRISE SECURITY FIX ---

# The original CMD line is now obsolete and should be removed or commented out:
# CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
