<?php
namespace App\Services;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class Marketplace {
 public function __construct(private Matching $matching){}
 public function milliseconds(): int {return (int)round(now()->getTimestampMs());}
 public function technicians(): array {
  return DB::table('technicians')->join('users','users.id','=','technicians.user_id')->select('technicians.*','users.name')->get()->map(fn($t)=>['id'=>$t->id,'name'=>$t->name,'zone'=>$t->zone,'zones'=>json_decode($t->zones,true),'specialties'=>json_decode($t->specialties,true),'fee'=>(float)$t->fee,'rating'=>(float)$t->rating,'reviews'=>(int)$t->reviews,'years'=>(int)$t->years,'verified'=>(bool)$t->verified,'available'=>(bool)$t->available])->all();
 }
 public function actor(User $user): array {return ['id'=>$user->role==='technician'?(string)DB::table('technicians')->where('user_id',$user->id)->value('id'):(string)$user->id,'name'=>$user->name,'role'=>$user->role];}
 private function event(object $r,string $text,int $now): void {$events=json_decode($r->events,true);$events[]=['at'=>$now,'text'=>$text];$r->events=json_encode($events,JSON_UNESCAPED_UNICODE);}
 private function save(object $r): void {DB::table('requests')->where('id',$r->id)->update((array)$r);}
 private function dispatch(object $r,int $now): void {
  $rules=Matching::rules();$offers=DB::table('offers')->where('request_id',$r->id);
  if($now>=$r->pending_until){(clone $offers)->where('status','pending')->update(['status'=>'expired']);$r->status='unassigned';$this->event($r,'Finalizó la ventana de disponibilidad de 24 horas.',$now);return;}
  $count=(clone $offers)->where('status','pending')->count();$excluded=(clone $offers)->pluck('technician_id')->all();
  $ranking=$this->matching->rank(['specialty'=>$r->specialty,'zone'=>$r->zone],$this->technicians(),$excluded);
  foreach(array_slice($ranking,0,max(0,$rules['maxSimultaneous']-$count)) as $t){DB::table('offers')->insert(['request_id'=>$r->id,'technician_id'=>$t['id'],'status'=>'pending','sent_at'=>$now,'expires_at'=>min($now+$rules['responseMinutes']*60000,$r->pending_until),'score'=>$t['score']]);$this->event($r,'Solicitud notificada a '.$t['name'].'.',$now);}
  $next=(clone $offers)->where('status','pending')->exists()?'searching':'pending_availability';
  if($r->status!==$next){$r->status=$next;$this->event($r,$next==='searching'?'Buscando respuesta de técnicos.':'Pendiente de disponibilidad en tu zona.',$now);}
 }
 public function tick(): void {
  $ids=DB::table('requests')->whereIn('status',['searching','pending_availability'])->pluck('id');
  foreach($ids as $id)DB::transaction(function()use($id){$r=DB::table('requests')->where('id',$id)->lockForUpdate()->first();if(!$r||!in_array($r->status,['searching','pending_availability']))return;$now=$this->milliseconds();
   foreach(DB::table('offers')->where('request_id',$id)->where('status','pending')->get() as $offer){$tech=DB::table('technicians')->where('id',$offer->technician_id)->first();if($now>=$offer->expires_at||!$tech?->available||!$tech?->verified){DB::table('offers')->where('id',$offer->id)->update(['status'=>'expired']);$this->event($r,'Oferta vencida o técnico no disponible; se busca otro candidato.',$now);}}
   $this->dispatch($r,$now);$this->save($r);
  },3);
 }
 public function state(User $user): array {
  $this->tick();$actor=$this->actor($user);$query=DB::table('requests')->orderByDesc('created_ms');
  if($user->role==='client')$query->where('client_id',$user->id);
  elseif($user->role==='technician')$query->where(function($q)use($actor){$q->where('technician_id',$actor['id'])->orWhereIn('id',DB::table('offers')->where('technician_id',$actor['id'])->select('request_id'));});
  $requests=$query->get()->map(function($r)use($actor){$offers=DB::table('offers')->where('request_id',$r->id)->get()->map(fn($o)=>['technicianId'=>$o->technician_id,'status'=>$o->status,'sentAt'=>(int)$o->sent_at,'expiresAt'=>(int)$o->expires_at,'score'=>(float)$o->score])->all();return ['id'=>$r->id,'clientId'=>(string)$r->client_id,'specialty'=>$r->specialty,'zone'=>$r->zone,'description'=>$r->description,'address'=>($actor['role']!=='technician'||$r->technician_id===$actor['id'])?$r->address:null,'status'=>$r->status,'technicianId'=>$r->technician_id,'agreedFee'=>$r->agreed_fee===null?null:(float)$r->agreed_fee,'createdAt'=>(int)$r->created_ms,'pendingUntil'=>(int)$r->pending_until,'completedAt'=>$r->completed_at===null?null:(int)$r->completed_at,'ratingUntil'=>$r->rating_until===null?null:(int)$r->rating_until,'rating'=>$r->rating===null?null:(int)$r->rating,'events'=>json_decode($r->events,true),'offers'=>$offers];})->all();
  return ['actor'=>$actor,'state'=>['requests'=>$requests,'technicians'=>$this->technicians()]];
 }
 public function action(User $user,string $action,array $data): void {
  $this->tick();$actor=$this->actor($user);$rules=Matching::rules();
  DB::transaction(function()use($user,$actor,$action,$data,$rules){$now=$this->milliseconds();
   if($action==='create'){
    abort_unless($user->role==='client',403);$id=(string)Str::uuid();$r=(object)['id'=>$id,'client_id'=>$user->id,'specialty'=>$data['specialty'],'zone'=>$data['zone'],'address'=>trim($data['address']),'description'=>trim($data['description']),'status'=>'pending_availability','technician_id'=>null,'agreed_fee'=>null,'rating'=>null,'created_ms'=>$now,'pending_until'=>$now+$rules['pendingHours']*3600000,'completed_at'=>null,'rating_until'=>null,'events'=>'[]'];$this->event($r,'Solicitud registrada.',$now);DB::table('requests')->insert((array)$r);$this->dispatch($r,$now);$this->save($r);return;
   }
   if($action==='availability'){
    abort_unless($user->role==='technician',403);$t=DB::table('technicians')->where('id',$actor['id'])->lockForUpdate()->first();abort_unless($t&&$t->verified,409,'Tu perfil aún no está verificado.');abort_if(DB::table('requests')->where('technician_id',$t->id)->whereIn('status',['proposed','confirmed','in_progress'])->exists(),409,'Tienes una atención activa.');DB::table('technicians')->where('id',$t->id)->update(['available'=>$data['available']]);return;
   }
   if($action==='verify'){
    abort_unless($user->role==='admin',403);$t=DB::table('technicians')->where('id',$data['technicianId'])->lockForUpdate()->first();abort_unless($t,404);DB::table('technicians')->where('id',$t->id)->update(['verified'=>$data['verified'],'available'=>$data['verified']?$t->available:false]);return;
   }
   $r=DB::table('requests')->where('id',$data['id'])->lockForUpdate()->first();abort_unless($r,404);$client=$user->role==='client'&&(int)$r->client_id===$user->id;
   if(in_array($action,['accept','decline'])){
    abort_unless($user->role==='technician',403);$offer=DB::table('offers')->where('request_id',$r->id)->where('technician_id',$actor['id'])->where('status','pending')->first();abort_unless($r->status==='searching'&&$offer&&$now<$offer->expires_at,409,'La oferta ya no está disponible.');$t=DB::table('technicians')->where('id',$actor['id'])->lockForUpdate()->first();abort_unless($t&&$t->available&&$t->verified,409,'No estás disponible o habilitado.');
    DB::table('offers')->where('id',$offer->id)->update(['status'=>$action==='accept'?'accepted':'declined']);
    if($action==='accept'){DB::table('offers')->where('request_id',$r->id)->where('status','pending')->update(['status'=>'cancelled']);$r->technician_id=$t->id;$r->agreed_fee=$t->fee;$r->status='proposed';DB::table('technicians')->where('id',$t->id)->update(['available'=>false]);$this->event($r,$user->name.' aceptó. Falta la confirmación del cliente.',$now);}
    else{$this->event($r,$user->name.' rechazó la solicitud.',$now);$this->dispatch($r,$now);}
   }elseif($action==='confirm'){
    abort_unless($client,403);abort_unless($r->status==='proposed',409);$r->status='confirmed';$this->event($r,'El cliente confirmó al técnico y la tarifa de visita.',$now);
   }elseif(in_array($action,['start','complete'])){
    abort_unless($user->role==='technician'&&$r->technician_id===$actor['id'],403);abort_unless($r->status===($action==='start'?'confirmed':'in_progress'),409);$r->status=$action==='start'?'in_progress':'completed';$this->event($r,$action==='start'?'El técnico inició el servicio.':'Servicio finalizado. Se abrió la ventana de calificación.',$now);if($action==='complete'){$r->completed_at=$now;$r->rating_until=$now+$rules['ratingHours']*3600000;DB::table('technicians')->where('id',$r->technician_id)->update(['available'=>true]);}
   }elseif($action==='rate'){
    abort_unless($client,403);abort_unless($r->status==='completed'&&$now<$r->rating_until,409,'La ventana de calificación está cerrada.');$t=DB::table('technicians')->where('id',$r->technician_id)->lockForUpdate()->first();$rating=($t->rating*$t->reviews+$data['rating'])/($t->reviews+1);DB::table('technicians')->where('id',$t->id)->update(['rating'=>$rating,'reviews'=>$t->reviews+1]);$r->rating=$data['rating'];$r->status='rated';$this->event($r,'Cliente calificó con '.$data['rating'].' estrellas.',$now);
   }elseif($action==='cancel'){
    abort_unless($client,403);abort_unless(in_array($r->status,['searching','pending_availability','proposed','confirmed']),409);DB::table('offers')->where('request_id',$r->id)->where('status','pending')->update(['status'=>'cancelled']);if($r->technician_id)DB::table('technicians')->where('id',$r->technician_id)->update(['available'=>true]);$r->status='cancelled';$this->event($r,'Solicitud cancelada por el cliente.',$now);
   }else abort(404);
   $this->save($r);
  },3);$this->tick();
 }
}
