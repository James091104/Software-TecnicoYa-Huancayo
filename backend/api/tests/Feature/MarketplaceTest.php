<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use App\Models\User;
use App\Services\Marketplace;
use App\Services\Matching;
use Illuminate\Support\Str;
class MarketplaceTest extends TestCase {
 use RefreshDatabase;
 protected function setUp(): void {parent::setUp();Http::fake(fn()=>Http::response([],503));$this->travelTo(now()->startOfSecond());}
 private function client(): User {return User::create(['name'=>'Cliente','email'=>Str::uuid().'@example.test','password'=>'Password123!','role'=>'client']);}
 private function tech(string $name='Técnico'): User {$u=User::create(['name'=>$name,'email'=>Str::uuid().'@example.test','password'=>'Password123!','role'=>'technician']);DB::table('technicians')->insert(['id'=>(string)Str::uuid(),'user_id'=>$u->id,'zone'=>'Huancayo','zones'=>'["Huancayo"]','specialties'=>'["computo"]','fee'=>40,'rating'=>4.5,'reviews'=>2,'years'=>5,'verified'=>true,'available'=>true]);return $u;}
 private function requestData(): array {return ['specialty'=>'computo','zone'=>'Huancayo','address'=>'Calle de prueba 123','description'=>'Mi computadora no enciende.'];}
 public function test_api_registration_verification_and_revocable_sessions(): void {
  $this->getJson('/api/state')->assertUnauthorized();
  $client=$this->postJson('/api/register',['name'=>'Cliente HTTP','email'=>'client-http@example.test','password'=>'Password123!','role'=>'client'])->assertOk()->json();
  $tech=$this->postJson('/api/register',['name'=>'Técnico HTTP','email'=>'tech-http@example.test','password'=>'Password123!','role'=>'technician','zone'=>'Huancayo','zones'=>['Huancayo'],'specialties'=>['computo'],'fee'=>45,'years'=>5])->assertOk()->json();
  $this->withToken($tech['token'])->postJson('/api/actions/availability',['available'=>true])->assertStatus(409);
  $admin=User::create(['name'=>'Admin HTTP','email'=>'admin-http@example.test','password'=>'Password123!','role'=>'admin']);
  $token=$this->postJson('/api/login',['email'=>$admin->email,'password'=>'Password123!'])->assertOk()->json('token');
  $this->withToken($client['token'])->postJson('/api/actions/verify',['technicianId'=>$tech['actor']['id'],'verified'=>true])->assertForbidden();
  $this->withToken($token)->postJson('/api/actions/verify',['technicianId'=>$tech['actor']['id'],'verified'=>true])->assertOk();
  $this->withToken($tech['token'])->postJson('/api/actions/availability',['available'=>true])->assertOk();
  $this->withToken($client['token'])->postJson('/api/actions/create',$this->requestData())->assertOk();
  $state=$this->withToken($client['token'])->getJson('/api/state')->assertOk()->json('state');$id=$state['requests'][0]['id'];
  $this->withToken($tech['token'])->postJson('/api/actions/start',['id'=>$id])->assertForbidden();
  $this->withToken($tech['token'])->postJson('/api/actions/accept',['id'=>$id])->assertOk();
  $this->withToken($client['token'])->postJson('/api/actions/confirm',['id'=>$id])->assertOk();
  $this->withToken($tech['token'])->postJson('/api/actions/start',['id'=>$id])->assertOk();
  $this->withToken($tech['token'])->postJson('/api/actions/complete',['id'=>$id])->assertOk();
  $this->withToken($client['token'])->postJson('/api/actions/rate',['id'=>$id,'rating'=>4])->assertOk();
  $this->withToken($client['token'])->postJson('/api/actions/rate',['id'=>$id,'rating'=>5])->assertStatus(409);
  $this->withToken($client['token'])->postJson('/api/logout')->assertOk();
  $this->withToken($client['token'])->getJson('/api/state')->assertUnauthorized();
 }
 public function test_authenticated_lifecycle_and_rating(): void {
  $client=$this->client();$tech=$this->tech();$market=app(Marketplace::class);$market->action($client,'create',$this->requestData());$id=DB::table('requests')->value('id');
  $market->action($tech,'accept',['id'=>$id]);$this->assertDatabaseHas('requests',['id'=>$id,'status'=>'proposed']);
  $market->action($client,'confirm',['id'=>$id]);$market->action($tech,'start',['id'=>$id]);$market->action($tech,'complete',['id'=>$id]);$market->action($client,'rate',['id'=>$id,'rating'=>5]);
  $this->assertDatabaseHas('requests',['id'=>$id,'status'=>'rated','rating'=>5]);$this->assertDatabaseHas('technicians',['user_id'=>$tech->id,'reviews'=>3,'available'=>true]);
 }
 public function test_deadlines_and_three_simultaneous_offers(): void {
  $client=$this->client();for($i=0;$i<4;$i++)$this->tech('T'.$i);$market=app(Marketplace::class);$market->action($client,'create',$this->requestData());$this->assertSame(3,DB::table('offers')->where('status','pending')->count());
  $this->travel(10)->minutes();$market->tick();$this->assertSame(3,DB::table('offers')->where('status','expired')->count());$this->assertSame(1,DB::table('offers')->where('status','pending')->count());
  $this->travel(24)->hours();$market->tick();$this->assertDatabaseHas('requests',['status'=>'unassigned']);$this->assertSame(0,DB::table('offers')->where('status','pending')->count());
 }
 public function test_api_refuses_admin_signup_and_other_clients_actions(): void {
  $this->postJson('/api/register',['name'=>'Intruso','email'=>'bad@example.test','password'=>'Password123!','role'=>'admin'])->assertUnprocessable();
  $a=$this->client();$b=$this->client();app(Marketplace::class)->action($a,'create',$this->requestData());$id=DB::table('requests')->value('id');
  $token=$this->postJson('/api/login',['email'=>$b->email,'password'=>'Password123!'])->assertOk()->json('token');
  $this->withToken($token)->postJson('/api/actions/cancel',['id'=>$id])->assertForbidden();
  $this->withToken($token)->getJson('/api/state')->assertJsonCount(0,'state.requests');
 }
 public function test_expired_rating_is_rejected(): void {
  $client=$this->client();$tech=$this->tech();$m=app(Marketplace::class);$m->action($client,'create',$this->requestData());$id=DB::table('requests')->value('id');foreach([[$tech,'accept'],[$client,'confirm'],[$tech,'start'],[$tech,'complete']] as [$u,$a])$m->action($u,$a,['id'=>$id]);$this->travel(48)->hours();
  $token=$this->postJson('/api/login',['email'=>$client->email,'password'=>'Password123!'])->json('token');$this->withToken($token)->postJson('/api/actions/rate',['id'=>$id,'rating'=>5])->assertStatus(409);
 }
 public function test_php_fallback_matches_reference(): void {$fixture=json_decode(file_get_contents(base_path('tests/matching-fixture.json')),true);$result=Matching::local($fixture['request'],$fixture['technicians']);$this->assertSame($fixture['expectedIds'],array_column($result,'id'));$this->assertSame($fixture['expectedScores'],array_column($result,'score'));$this->assertSame($result,app(Matching::class)->rank($fixture['request'],$fixture['technicians']));}
}
