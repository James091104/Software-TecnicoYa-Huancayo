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
 private function tech(string $name='Técnico'): User {$u=User::create(['name'=>$name,'email'=>Str::uuid().'@example.test','password'=>'Password123!','role'=>'technician']);DB::table('technicians')->insert(['id'=>(string)Str::uuid(),'user_id'=>$u->id,'zone'=>'Huancayo','zones'=>'["Huancayo"]','specialties'=>'["computo"]','subcategories'=>'["computo-hardware"]','fee'=>40,'rating'=>4.5,'reviews'=>2,'years'=>5,'verified'=>true,'available'=>true]);return $u;}
 private function requestData(): array {return ['specialty'=>'computo','subcategory'=>'computo-hardware','zone'=>'Huancayo','address'=>'Calle de prueba 123','description'=>'Mi computadora no enciende.'];}
 public function test_api_registration_verification_and_revocable_sessions(): void {
  $this->getJson('/api/state')->assertUnauthorized();
  $client=$this->postJson('/api/register',['name'=>'Cliente HTTP','email'=>'client-http@example.test','password'=>'Password123!','role'=>'client'])->assertCreated()->assertJsonMissingPath('token');
  $this->assertDatabaseCount('api_tokens',0);
  $client=$this->postJson('/api/login',['email'=>'client-http@example.test','password'=>'Password123!'])->assertOk()->json();
  $tech=$this->postJson('/api/register',['name'=>'Técnico HTTP','email'=>'tech-http@example.test','password'=>'Password123!','role'=>'technician','zone'=>'Huancayo','zones'=>['Huancayo'],'specialties'=>['computo'],'fee'=>45,'years'=>5])->assertCreated()->assertJsonMissingPath('token');
  $tech=$this->postJson('/api/login',['email'=>'tech-http@example.test','password'=>'Password123!'])->assertOk()->json();
  $this->withToken($tech['token'])->postJson('/api/actions/availability',['available'=>true])->assertStatus(409);
  $admin=User::create(['name'=>'Admin HTTP','email'=>'admin-http@example.test','password'=>'Password123!','role'=>'admin']);
  $token=$this->postJson('/api/login',['email'=>$admin->email,'password'=>'Password123!'])->assertOk()->json('token');
  $this->withToken($client['token'])->postJson('/api/actions/verify',['technicianId'=>$tech['actor']['id'],'verified'=>true])->assertForbidden();
  $this->withToken($token)->postJson('/api/actions/verify',['technicianId'=>$tech['actor']['id'],'verified'=>true])->assertOk();
  $this->withToken($tech['token'])->postJson('/api/actions/technician-profile',['zone'=>'Huancayo','zones'=>['Huancayo'],'fee'=>45,'subcategories'=>['computo-hardware']])->assertOk();
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

 private function loginToken(User $user): string {return $this->postJson('/api/login',['email'=>$user->email,'password'=>'Password123!'])->assertOk()->json('token');}
 public function test_technician_updates_only_own_terms_and_cannot_self_verify(): void {
  $tech=$this->tech();$other=$this->tech();DB::table('technicians')->where('user_id',$tech->id)->update(['verified'=>false,'available'=>false]);
  $token=$this->loginToken($tech);
  $this->withToken($token)->postJson('/api/actions/technician-profile',['zone'=>'El Tambo','zones'=>['Huancayo'],'fee'=>65,'userId'=>$other->id,'verified'=>true,'rating'=>5])->assertOk();
  $this->assertDatabaseHas('technicians',['user_id'=>$tech->id,'zone'=>'El Tambo','fee'=>65,'verified'=>false,'available'=>false,'rating'=>4.5]);
  $this->assertDatabaseHas('technicians',['user_id'=>$other->id,'zone'=>'Huancayo','fee'=>40]);
  $zones=json_decode(DB::table('technicians')->where('user_id',$tech->id)->value('zones'),true);$this->assertSame(['El Tambo','Huancayo'],$zones);
  $this->withToken($token)->postJson('/api/actions/technician-profile',['zone'=>'Fuera de cobertura','zones'=>[],'fee'=>-1])->assertUnprocessable();
 }
 public function test_pending_offers_and_assigned_work_lock_service_terms(): void {
  $client=$this->client();$tech=$this->tech();$market=app(Marketplace::class);$market->action($client,'create',$this->requestData());$id=DB::table('requests')->value('id');$token=$this->loginToken($tech);
  $data=['zone'=>'Huancayo','zones'=>['Huancayo'],'fee'=>90];
  $this->withToken($token)->postJson('/api/actions/technician-profile',$data)->assertStatus(409);
  $market->action($tech,'accept',['id'=>$id]);
  $this->withToken($token)->postJson('/api/actions/technician-profile',$data)->assertStatus(409);
  $this->assertDatabaseHas('requests',['id'=>$id,'agreed_fee'=>40]);
  $market->action($client,'cancel',['id'=>$id]);
  $this->withToken($token)->postJson('/api/actions/technician-profile',$data)->assertOk();
 }
 private function admin(): User {return User::create(['name'=>'Admin','email'=>Str::uuid().'@example.test','password'=>'Password123!','role'=>'admin']);}
 public function test_permission_matrix_denies_every_other_role_action(): void {
  $this->withoutMiddleware(\Illuminate\Routing\Middleware\ThrottleRequests::class);
  $roles=['client'=>$this->client(),'technician'=>$this->tech(),'admin'=>$this->admin()];
  $all=array_unique(array_merge(...array_values(\App\Services\Permissions::ROLES)));
  foreach($roles as $role=>$user){$token=$this->loginToken($user);foreach($all as $action){if(!in_array($action,\App\Services\Permissions::forRole($role)))$this->withToken($token)->postJson('/api/actions/'.$action,[])->assertForbidden();}}
 }
 public function test_suspension_revokes_sessions_and_reactivation_requires_new_login(): void {
  $client=$this->client();$clientToken=$this->loginToken($client);$admin=$this->admin();$adminToken=$this->loginToken($admin);
  $this->withToken($adminToken)->postJson('/api/actions/accounts',['userId'=>$client->id,'active'=>false])->assertOk();
  $this->assertDatabaseMissing('api_tokens',['user_id'=>$client->id]);
  $this->withToken($clientToken)->getJson('/api/state')->assertUnauthorized();
  $this->postJson('/api/login',['email'=>$client->email,'password'=>'Password123!'])->assertForbidden();
  $this->withToken($adminToken)->postJson('/api/actions/accounts',['userId'=>$client->id,'active'=>true])->assertOk();
  $this->withToken($clientToken)->getJson('/api/state')->assertUnauthorized();
  $this->loginToken($client);
  $this->assertDatabaseHas('access_events',['actor_id'=>$admin->id,'user_id'=>$client->id,'action'=>'suspend']);
  $this->assertDatabaseHas('access_events',['actor_id'=>$admin->id,'user_id'=>$client->id,'action'=>'activate']);
 }
 public function test_admin_accounts_are_protected_and_accounts_are_private(): void {
  $admin=$this->admin();$token=$this->loginToken($admin);
  $this->withToken($token)->postJson('/api/actions/accounts',['userId'=>$admin->id,'active'=>false])->assertStatus(409);
  $this->withToken($token)->getJson('/api/state')->assertJsonCount(1,'state.users');
  $client=$this->client();$token=$this->loginToken($client);
  $this->withToken($token)->getJson('/api/state')->assertJsonCount(0,'state.users')->assertJsonCount(0,'state.accessEvents');
 }
 public function test_profile_cannot_escalate_role_or_edit_another_account(): void {
  $client=$this->client();$other=$this->client();$token=$this->loginToken($client);
  $this->withToken($token)->postJson('/api/actions/profile',['name'=>'Nuevo nombre','role'=>'admin','userId'=>$other->id])->assertOk();
  $this->assertDatabaseHas('users',['id'=>$client->id,'name'=>'Nuevo nombre','role'=>'client']);
  $this->assertDatabaseHas('users',['id'=>$other->id,'name'=>'Cliente']);
  $this->withToken($token)->postJson('/api/actions/profile',['name'=>' '])->assertUnprocessable();
 }
 public function test_address_is_hidden_until_confirmation_and_other_technicians_cannot_start(): void {
  $client=$this->client();$tech=$this->tech();$other=$this->tech();$market=app(Marketplace::class);
  $market->action($client,'create',$this->requestData());$id=DB::table('requests')->value('id');$token=$this->loginToken($tech);
  $this->withToken($token)->getJson('/api/state')->assertJsonPath('state.requests.0.address',null);
  $market->action($tech,'accept',['id'=>$id]);
  $this->withToken($token)->getJson('/api/state')->assertJsonPath('state.requests.0.address',null);
  $market->action($client,'confirm',['id'=>$id]);
  $this->withToken($token)->getJson('/api/state')->assertJsonPath('state.requests.0.address',$this->requestData()['address']);
  $otherToken=$this->loginToken($other);
  $this->withToken($otherToken)->postJson('/api/actions/start',['id'=>$id])->assertForbidden();
  $this->withToken($otherToken)->getJson('/api/state')->assertJsonPath('state.requests.0.address',null);
 }
 public function test_active_work_prevents_suspension(): void {
  $client=$this->client();app(Marketplace::class)->action($client,'create',$this->requestData());
  $token=$this->loginToken($this->admin());
  $this->withToken($token)->postJson('/api/actions/accounts',['userId'=>$client->id,'active'=>false])->assertStatus(409);
  $this->assertDatabaseHas('users',['id'=>$client->id,'is_active'=>true]);
 }

 public function test_subcategory_validation_persistence_and_matching(): void {
  $client=$this->client();$tech=$this->tech();$other=$this->tech();
  DB::table('technicians')->where('user_id',$other->id)->update(['subcategories'=>'["computo-redes"]']);
  $token=$this->loginToken($client);
  $this->withToken($token)->postJson('/api/actions/create',[...$this->requestData(),'subcategory'=>'electricidad-tableros'])->assertUnprocessable();
  $this->withToken($token)->postJson('/api/actions/create',[...$this->requestData(),'subcategory'=>null])->assertUnprocessable();
  $this->withToken($token)->postJson('/api/actions/create',$this->requestData())->assertOk();
  $state=$this->withToken($token)->getJson('/api/state')->assertOk()->json('state');
  $this->assertSame('computo-hardware',$state['requests'][0]['subcategory']);
  $this->assertCount(1,$state['requests'][0]['offers']);
  $this->assertSame(DB::table('technicians')->where('user_id',$tech->id)->value('id'),$state['requests'][0]['offers'][0]['technicianId']);
  $otherToken=$this->loginToken($other);
  $this->withToken($otherToken)->postJson('/api/actions/technician-profile',['zone'=>'Huancayo','zones'=>['Huancayo'],'fee'=>45,'subcategories'=>['electricidad-tableros']])->assertUnprocessable();
  $this->withToken($otherToken)->postJson('/api/actions/technician-profile',['zone'=>'Huancayo','zones'=>['Huancayo'],'fee'=>45,'subcategories'=>['computo-hardware']])->assertOk();
  $this->assertSame(['computo-hardware'],json_decode(DB::table('technicians')->where('user_id',$other->id)->value('subcategories'),true));
 }
 public function test_matching_rejects_missing_skills_and_keeps_legacy_requests(): void {
  $fixture=json_decode(file_get_contents(base_path('tests/matching-fixture.json')),true);
  $base=[...$fixture['technicians'][0],'id'=>'ok','specialties'=>['computo'],'verified'=>true,'available'=>true,'subcategories'=>['computo-hardware']];
  $candidates=[$base,[...$base,'id'=>'legacy','subcategories'=>[]],[...$base,'id'=>'inactive','active'=>false]];
  $request=[...$fixture['request'],'subcategory'=>'computo-hardware'];
  $this->assertSame(['ok'],array_column(Matching::local($request,$candidates),'id'));
  $this->assertSame([],Matching::local([...$request,'subcategory'=>'electricidad-tableros'],$candidates));
  $this->assertSame([],Matching::local([...$request,'subcategory'=>'unknown'],$candidates));
  $this->assertCount(2,Matching::local($fixture['request'],$candidates));
 }
}
