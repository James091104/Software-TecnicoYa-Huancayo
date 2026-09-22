"""Rule-based intake guidance. No diagnosis, pricing or personal-data storage."""
from typing import Literal
from fastapi import FastAPI
from pydantic import BaseModel, Field

app = FastAPI(title="TecnicoYa · Orientación de atención")

class Intake(BaseModel):
    service: Literal["diagnostico", "mantenimiento", "software", "redes"]
    description: str = Field(min_length=10, max_length=2000)

def guidance(service: str, description: str) -> dict:
    text = description.casefold()
    if any(word in text for word in ("humo", "quemado", "hinchada", "líquido", "liquido", "mojado")):
        return {"priority": "review", "advice": "Evita volver a encender o cargar el equipo. Comenta este detalle al coordinar la revisión técnica."}
    advice = {
        "diagnostico": "Anota cuándo aparece el problema y cualquier mensaje de error. No necesitas abrir el equipo para solicitar atención.",
        "mantenimiento": "Ten a mano el modelo del equipo y la fecha aproximada de su último mantenimiento.",
        "software": "Anota el mensaje de error y el programa afectado. No compartas contraseñas ni claves de acceso en la solicitud.",
        "redes": "Indica si la conexión falla en uno o en varios dispositivos y si sucede con Wi-Fi, cable o ambos.",
    }
    return {"priority": "normal", "advice": advice[service]}

@app.get("/health")
def health():
    return {"status": "ok", "service": "tecnicoya-guidance"}

@app.post("/guidance")
def get_guidance(intake: Intake):
    return guidance(intake.service, intake.description)
