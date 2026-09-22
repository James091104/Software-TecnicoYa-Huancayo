from fastapi.testclient import TestClient
from app import app
client = TestClient(app)
def test_health():
    assert client.get('/health').json()['status'] == 'ok'
def test_services():
    for service in ('diagnostico', 'mantenimiento', 'software', 'redes'):
        response = client.post('/guidance', json={'service': service, 'description': 'Necesito revisar el equipo.'})
        assert response.status_code == 200
        assert response.json()['priority'] == 'normal'
        assert response.json()['advice']
def test_urgent():
    assert client.post('/guidance', json={'service': 'diagnostico', 'description': 'La batería está hinchada.'}).json()['priority'] == 'review'
def test_invalid():
    assert client.post('/guidance', json={'service': 'otro', 'description': 'abc'}).status_code == 422
