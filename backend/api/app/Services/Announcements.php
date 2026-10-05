<?php
namespace App\Services;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;
final class Announcements {
 public static function validation(): array {
  return [
   'id'=>'nullable|uuid', 'title'=>'required|string|min:3|max:120',
   'body'=>'required|string|max:600','audience'=>['required',Rule::in(['client','technician','both'])],
   'status'=>['required',Rule::in(['draft','published','archived'])],
   'priority'=>'required|integer|min:0|max:100',
   'linkLabel'=>'nullable|required_with:linkUrl|string|max:40',
   'linkUrl'=>['nullable','required_with:linkLabel','url:http,https','max:2048'],
   'image'=>['nullable','string','max:2800000',function($attribute,$value,$fail){
    if(!preg_match('/^data:image\/(png|jpeg|webp);base64,([A-Za-z0-9+\/=]+)$/',$value,$m)){$fail('Selecciona una imagen PNG, JPG o WebP.');return;}
    $bytes=base64_decode($m[2],true);$info=$bytes!==false?@getimagesizefromstring($bytes):false;
    if(!$info||strlen($bytes)>2*1024*1024||($info['mime']??'')!=='image/'.$m[1]){$fail('La imagen debe ser válida y de máximo 2 MB.');return;}
    if($info[0]!==1600||$info[1]!==420)$fail('La imagen debe medir exactamente 1600 × 420 px.');
   }],
  ];
 }
 public static function visible(User $user): array {
  $q=DB::table('announcements');
  if($user->role!=='admin')$q->where('status','published')->whereIn('audience',[$user->role,'both']);
  return $q->orderByDesc('priority')->orderByDesc('created_at')->orderBy('id')->get()->map(fn($a)=>[
   'id'=>$a->id,'title'=>$a->title,'body'=>$a->body,'audience'=>$a->audience,'status'=>$a->status,
   'priority'=>(int)$a->priority,'image'=>$a->image,'linkUrl'=>$a->link_url,'linkLabel'=>$a->link_label,
   'updatedAt'=>$a->updated_at,
  ])->all();
 }
 public static function save(User $user,array $data): void {
  Permissions::authorize($user,'announcement-save');
  $values=['title'=>$data['title'],'body'=>$data['body'],'audience'=>$data['audience'],'status'=>$data['status'],
   'priority'=>$data['priority'],'image'=>$data['image']??null,'link_url'=>$data['linkUrl']??null,'link_label'=>$data['linkLabel']??null,
   'updated_by'=>$user->id,'updated_at'=>now()];
  if(!empty($data['id'])){abort_unless(DB::table('announcements')->where('id',$data['id'])->exists(),404,'Anuncio no encontrado.');DB::table('announcements')->where('id',$data['id'])->update($values);}
  else DB::table('announcements')->insert(['id'=>(string)Str::uuid(),'created_at'=>now(),...$values]);
 }
}
