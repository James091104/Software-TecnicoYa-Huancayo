<?php
namespace App\Services;
use Illuminate\Support\Facades\Http;
class Matching {
 public static function rules(): array {return json_decode(file_get_contents(resource_path('domain/rules.json')),true,512,JSON_THROW_ON_ERROR);}
 public static function validSubcategory(string $specialty,string $id): bool {foreach(self::rules()['subcategories'] as $s)if($s['active']&&$s['specialty']===$specialty&&$s['id']===$id)return true;return false;}
 public static function local(array $request,array $technicians,array $excluded=[]): array {
  $rules=self::rules();
  if(!empty($request['subcategory'])&&!self::validSubcategory($request['specialty'],$request['subcategory']))return [];
  $eligible=array_values(array_filter($technicians,fn($t)=>$t['verified']&&$t['available']&&($t['active']??true)&&(empty($request['subcategory'])||in_array($request['subcategory'],$t['subcategories']??[],true))&&in_array($request['specialty'],$t['specialties'],true)&&in_array($request['zone'],$t['zones'],true)&&!in_array($t['id'],$excluded,true)));
  if(!$eligible)return [];
  $min=min(array_column($eligible,'fee'));$max=max(array_column($eligible,'fee'));
  foreach($eligible as &$t){$f=['proximity'=>$t['zone']===$request['zone']?1:$rules['secondaryZoneProximity'],'price'=>$max===$min?1:($max-$t['fee'])/($max-$min),'rating'=>$t['rating']/5,'experience'=>min($t['years']/$rules['maxExperienceYears'],1)];$score=0;foreach($rules['weights'] as $key=>$weight)$score+=$f[$key]*$weight;$t['score']=round($score,6);$t['factors']=$f;}unset($t);
  usort($eligible,fn($a,$b)=>($b['score']<=>$a['score'])?:($b['rating']<=>$a['rating'])?:strcmp($a['id'],$b['id']));return $eligible;
 }
 public function rank(array $request,array $technicians,array $excluded=[]): array {
  $fallback=self::local($request,$technicians,$excluded);
  try{$data=Http::timeout(2)->connectTimeout(1)->post(config('marketplace.python_url').'/match',[...$request,'technicians'=>$technicians,'excluded'=>$excluded])->throw()->json();
   // Reject inconsistent/malformed service results; PHP remains the safe fallback.
   $remote=$data['ranking']??[];
   if(($data['rulesVersion']??null)!==self::rules()['version']||array_column($remote,'id')!==array_column($fallback,'id'))return $fallback;
   foreach($remote as $i=>$entry)if(!isset($entry['score'])||abs($entry['score']-$fallback[$i]['score'])>0.000001)return $fallback;
   return $remote;
  }catch(\Throwable $e){return $fallback;}
 }
}
