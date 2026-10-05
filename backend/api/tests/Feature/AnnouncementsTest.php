<?php
namespace Tests\Feature;
use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use App\Models\User;
class AnnouncementsTest extends TestCase {
 use RefreshDatabase;
 private function token(string $role): string {
  $u=User::create(['name'=>'Prueba '.$role,'email'=>Str::uuid().'@example.test','password'=>'Prueba123!','role'=>$role]);
  return $this->postJson('/api/login',['email'=>$u->email,'password'=>'Prueba123!'])->assertOk()->json('token');
 }
 private function data(array $changes=[]): array {return array_replace(['title'=>'Aviso para la comunidad','body'=>'Un mensaje informativo de prueba.','audience'=>'client','status'=>'draft','priority'=>5,'image'=>null,'linkUrl'=>null,'linkLabel'=>null],$changes);}
 public function test_only_admin_can_write_announcements(): void {
  $this->postJson('/api/actions/announcement-save',$this->data())->assertUnauthorized();
  foreach(['client','technician'] as $role){$this->withToken($this->token($role))->postJson('/api/actions/announcement-save',$this->data())->assertForbidden();}
  $this->assertDatabaseCount('announcements',0);
 }
 public function test_audiences_drafts_archives_and_priority_are_filtered_in_api(): void {
  $admin=$this->token('admin');
  foreach([['title'=>'Solo clientes','audience'=>'client','status'=>'published','priority'=>10],['title'=>'Solo técnicos','audience'=>'technician','status'=>'published'],['title'=>'Para todos','audience'=>'both','status'=>'published','priority'=>20],['title'=>'No publicado','audience'=>'both','status'=>'draft'],['title'=>'Ya archivado','audience'=>'both','status'=>'archived']] as $a){$this->withToken($admin)->postJson('/api/actions/announcement-save',$this->data($a))->assertOk();}
  $this->withToken($admin)->getJson('/api/state')->assertJsonCount(5,'state.announcements');
  $client=$this->token('client');$response=$this->withToken($client)->getJson('/api/state')->assertOk()->assertJsonCount(2,'state.announcements');
  $this->assertSame(['Para todos','Solo clientes'],array_column($response->json('state.announcements'),'title'));
  $tech=$this->token('technician');$response=$this->withToken($tech)->getJson('/api/state')->assertOk()->assertJsonCount(2,'state.announcements');
  $this->assertSame(['Para todos','Solo técnicos'],array_column($response->json('state.announcements'),'title'));
 }
 public function test_edit_moves_audience_and_archive_removes_publication(): void {
  $admin=$this->token('admin');$client=$this->token('client');
  $this->withToken($admin)->postJson('/api/actions/announcement-save',$this->data(['status'=>'published']))->assertOk();$id=DB::table('announcements')->value('id');
  $this->withToken($client)->getJson('/api/state')->assertJsonCount(1,'state.announcements');
  $this->withToken($admin)->postJson('/api/actions/announcement-save',$this->data(['id'=>$id,'status'=>'published','audience'=>'technician']))->assertOk();
  $this->withToken($client)->getJson('/api/state')->assertJsonCount(0,'state.announcements');
  $this->assertDatabaseCount('announcements',1);
  $this->withToken($admin)->postJson('/api/actions/announcement-save',$this->data(['id'=>$id,'status'=>'archived']))->assertOk();
  $this->withToken($client)->getJson('/api/state')->assertJsonCount(0,'state.announcements');
 }
 public function test_validation_rejects_scripts_invalid_audiences_and_fake_images(): void {
  $admin=$this->token('admin');
  foreach([['image'=>'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII='],['linkUrl'=>'javascript:alert(1)','linkLabel'=>'Abrir'],['audience'=>'admin'],['image'=>'data:image/png;base64,YWJj'],['image'=>'data:image/svg+xml;base64,YWJj'],['priority'=>101],['title'=>' '],['linkUrl'=>'https://example.com','linkLabel'=>null]] as $bad){$this->withToken($admin)->postJson('/api/actions/announcement-save',$this->data($bad))->assertUnprocessable();}
  $this->withToken($admin)->postJson('/api/actions/announcement-save',$this->data(['id'=>(string)Str::uuid()]))->assertNotFound();
  $this->assertDatabaseCount('announcements',0);
 }
 public function test_image_and_link_survive_save_and_read(): void {
  $admin=$this->token('admin');$png='data:image/png;base64,'.base64_encode(file_get_contents(base_path('tests/fixtures/banner-1600x420.png')));
  $this->withToken($admin)->postJson('/api/actions/announcement-save',$this->data(['image'=>$png,'linkUrl'=>'https://example.com/news','linkLabel'=>'Leer más']))->assertOk();
  $this->withToken($admin)->getJson('/api/state')->assertJsonPath('state.announcements.0.image',$png)->assertJsonPath('state.announcements.0.linkUrl','https://example.com/news');
 }
}
