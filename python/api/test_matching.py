import json
from pathlib import Path
from fastapi.testclient import TestClient
from app import app, MatchRequest, rank

def test_shared_fixture():
    f=json.loads(Path(__file__).with_name('matching-fixture.json').read_text())
    result=rank(MatchRequest(**f['request'],technicians=f['technicians']))
    assert [t['id'] for t in result] == f['expectedIds']
    assert [t['score'] for t in result] == f['expectedScores']

def test_filters_empty_and_validation():
    client=TestClient(app)
    assert client.post('/match',json={'specialty':'computo','zone':'Huancayo','technicians':[]}).json()['ranking']==[]
    assert client.post('/match',json={}).status_code==422
    assert client.get('/health').json()['status']=='ok'

def test_rating_breaks_score_ties():
    base={'zone':'Huancayo','zones':['Huancayo'],'specialties':['computo'],'fee':40,'years':10,'verified':True,'available':True}
    result=rank(MatchRequest(specialty='computo',zone='Huancayo',technicians=[{**base,'id':'a','rating':4},{**base,'id':'b','rating':5,'years':6}]))
    assert result[0]['score']==result[1]['score']
    assert result[0]['id']=='b'
