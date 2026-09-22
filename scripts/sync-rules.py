"""One editable source, identical module-local copies for independent Docker builds."""
from pathlib import Path
import sys
root = Path(__file__).resolve().parents[1]
source = (root/'domain/rules.json').read_bytes()
targets = ['frontend/web/src/domain/rules.json', 'backend/api/resources/domain/rules.json', 'python/api/rules.json']
for name in targets:
    path = root/name
    if '--check' in sys.argv:
        if not path.exists() or path.read_bytes() != source:
            raise SystemExit(f'Rules out of sync: {name}')
    else:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(source)
print('Business rules synchronized across JS, PHP and Python.')
fixture = (root/'domain/matching-fixture.json').read_bytes()
for name in ['frontend/web/src/domain/matching-fixture.json', 'backend/api/tests/matching-fixture.json', 'python/api/matching-fixture.json']:
    path = root/name
    if '--check' in sys.argv:
        if not path.exists() or path.read_bytes() != fixture:
            raise SystemExit(f'Matching fixture out of sync: {name}')
    else:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(fixture)
print('Shared matching fixtures synchronized.')
