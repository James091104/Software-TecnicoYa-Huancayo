/** Bounded decoded-image cache. Scroll jumps request the target before preloading neighbours. */
export default class FrameCache {
  constructor({count, variant, onLoad, max=20}) {
    this.count=count;this.variant=variant;this.onLoad=onLoad;this.max=max;
    this.images=new Map();this.pending=new Map();this.failed=new Set();
    this.queue=[];this.target=0;this.active=true;this.disposed=false;
  }
  url(index){return `/media/scroll-sequence/${this.variant}/frame-${String(index).padStart(4,'0')}.webp`}
  get(index){const image=this.images.get(index);if(image){this.images.delete(index);this.images.set(index,image)}return image}
  request(index, direction=1){
    this.target=index;
    const offsets=[0,direction,-direction,...Array.from({length:9},(_,i)=>(i+2)*direction),-2*direction];
    this.queue=offsets.map(offset=>index+offset).filter(i=>i>=0&&i<this.count);
    this.pump();
  }
  setActive(active){this.active=active;if(active)this.pump()}
  pump(){
    if(this.disposed||!this.active)return;
    while(this.pending.size<3&&this.queue.length){
      const index=this.queue.shift();
      if(this.images.has(index)||this.pending.has(index)||this.failed.has(index))continue;
      const image=new Image();image.decoding='async';this.pending.set(index,image);
      image.onload=()=>{
        this.pending.delete(index);
        if(this.disposed)return;
        this.images.set(index,image);
        while(this.images.size>this.max){const oldest=this.images.keys().next().value;this.images.delete(oldest)}
        this.onLoad(index);this.pump();
      };
      image.onerror=()=>{this.pending.delete(index);this.failed.add(index);this.pump()};
      image.src=this.url(index);
    }
  }
  dispose(){this.disposed=true;this.queue=[];for(const image of this.pending.values()){image.onload=null;image.onerror=null;image.src=''}this.pending.clear();this.images.clear()}
}
