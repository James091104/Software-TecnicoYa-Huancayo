"""Extract local WebP frames for scroll-driven playback. Never modifies the source video.

Usage: python scripts/build-scroll-sequence.py "Video de Scrolling.mp4"
Requires imageio-ffmpeg; optionally installed in the project-local .media-tools directory.
"""
import argparse
import json
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / '.media-tools'))
import imageio_ffmpeg

parser = argparse.ArgumentParser()
parser.add_argument('source', type=Path)
args = parser.parse_args()
source = args.source.resolve(strict=True)
reader = imageio_ffmpeg.read_frames(str(source))
metadata = next(reader)
reader.close()
fps = metadata['fps']
size = metadata['size']
duration = metadata['duration']
cues = [('computo', '00:02:08'), ('refrigeracion', '00:05:06'), ('electricidad', '00:07:07')]

def cue_seconds(timecode):
    minutes, seconds, frame = map(int, timecode.split(':'))
    if frame >= round(fps):
        raise ValueError(f'Invalid frame in {timecode} for {fps} fps')
    return minutes * 60 + seconds + frame / fps

if duration <= cue_seconds(cues[-1][1]):
    raise ValueError('Video ends before the last requested scene.')
out = ROOT / 'frontend/web/public/media/scroll-sequence'
out.mkdir(parents=True, exist_ok=True)
ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
variants = {}
for name, max_width, quality in [('desktop', 1440, 92), ('mobile', 1280, 88)]:
    folder = out / name
    folder.mkdir(exist_ok=True)
    width = min(max_width, size[0])
    width -= width % 2
    subprocess.run([ffmpeg, '-hide_banner', '-loglevel', 'error', '-y', '-i', str(source),
        '-an', '-vf', f'fps={fps},scale={width}:-2:flags=lanczos', '-c:v', 'libwebp', '-quality', str(quality),
        '-compression_level', '4', '-start_number', '0', str(folder/'frame-%04d.webp')], check=True)
    frames = sorted(folder.glob('frame-*.webp'))
    variants[name] = {'width': width, 'count': len(frames), 'bytes': sum(p.stat().st_size for p in frames)}
count = variants['desktop']['count']
if count != variants['mobile']['count']:
    raise ValueError('Frame counts differ between variants')
manifest = {
    'source': source.name, 'fps': fps, 'duration': duration, 'frameCount': count,
    'aspectRatio': size[0]/size[1], 'variants': variants,
    'scenes': [{'id': key, 'timecode': timecode, 'time': cue_seconds(timecode),
                'frame': round(cue_seconds(timecode)*fps)} for key, timecode in cues],
}
target = ROOT/'frontend/web/src/scroll/sequence.json'
target.parent.mkdir(parents=True, exist_ok=True)
target.write_text(json.dumps(manifest, indent=2, ensure_ascii=False)+'\n', encoding='utf-8')
print(json.dumps(manifest, indent=2, ensure_ascii=False))
