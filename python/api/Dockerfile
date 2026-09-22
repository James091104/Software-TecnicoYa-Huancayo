FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
ARG PORT=8000
ENV PORT=${PORT}
EXPOSE ${PORT}
CMD ["sh", "-c", "uvicorn app:app --host 0.0.0.0 --port ${PORT}"]
