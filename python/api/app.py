import json
from pathlib import Path
from fastapi import FastAPI
from pydantic import BaseModel, Field
from decimal import Decimal, ROUND_HALF_UP

RULES = json.loads(Path(__file__).with_name('rules.json').read_text())
app = FastAPI(title='TécnicoYa · Motor de matching')

class Technician(BaseModel):
    id: str
    name: str = ''
    zone: str
    zones: list[str] = Field(max_length=50)
    specialties: list[str] = Field(max_length=10)
    subcategories: list[str] = Field(default_factory=list, max_length=30)
    active: bool = True
    verified: bool
    available: bool
    fee: float = Field(ge=0, le=100000, allow_inf_nan=False)
    rating: float = Field(ge=0, le=5, allow_inf_nan=False)
    years: float = Field(ge=0, le=80, allow_inf_nan=False)

class MatchRequest(BaseModel):
    specialty: str
    subcategory: str | None = None
    zone: str
    technicians: list[Technician] = Field(max_length=5000)
    excluded: list[str] = Field(default_factory=list, max_length=5000)

def rank(request):
    if request.subcategory and not any(s["id"] == request.subcategory and s["specialty"] == request.specialty and s["active"] for s in RULES["subcategories"]):
        return []
    eligible = [t.model_dump() for t in request.technicians if t.verified and t.available and t.active and (not request.subcategory or request.subcategory in t.subcategories) and request.specialty in t.specialties and request.zone in t.zones and t.id not in request.excluded]
    if not eligible:
        return []
    minimum, maximum = min(t['fee'] for t in eligible), max(t['fee'] for t in eligible)
    for t in eligible:
        factors = {'proximity': 1 if t['zone'] == request.zone else RULES['secondaryZoneProximity'], 'price': 1 if maximum == minimum else (maximum-t['fee'])/(maximum-minimum), 'rating': t['rating']/5, 'experience': min(t['years']/RULES['maxExperienceYears'], 1)}
        score = sum(factors[key]*weight for key, weight in RULES['weights'].items())
        t['score'] = float(Decimal(str(score)).quantize(Decimal('0.000001'), rounding=ROUND_HALF_UP))
        t['factors'] = factors
    return sorted(eligible, key=lambda t: (-t['score'], -t['rating'], t['id']))

@app.get('/health')
def health():
    return {'status':'ok', 'rulesVersion':RULES['version']}

@app.post('/match')
def match(request: MatchRequest):
    return {'ranking':rank(request), 'rulesVersion':RULES['version']}
