<?php
namespace App\Http\Controllers;
use App\Services\Marketplace;
use App\Services\Matching;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
class MarketplaceController extends Controller {
 public function state(Request $request,Marketplace $market){return response()->json($market->state($request->user()));}
 public function action(Request $request,string $action,Marketplace $market){
  \App\Services\Permissions::authorize($request->user(),$action);
  $rules=Matching::rules();
  $validation=match($action){
   'announcement-save'=>\App\Services\Announcements::validation(),
   'create'=>['subcategory'=>['required','string',function($attribute,$value,$fail)use($request){if(!Matching::validSubcategory((string)$request->input('specialty'),$value))$fail('Selecciona una subcategoría activa del rubro.');}],'specialty'=>['required',Rule::in($rules['specialties'])],'zone'=>['required',Rule::in($rules['zones'])],'address'=>'required|string|min:5|max:200','description'=>'required|string|min:10|max:2000'],
   'profile'=>['name'=>'required|string|min:2|max:100'],
   'technician-profile'=>['subcategories'=>'sometimes|array|max:30','subcategories.*'=>['required','string','distinct',function($attribute,$value,$fail)use($request){$specialties=json_decode(\Illuminate\Support\Facades\DB::table('technicians')->where('user_id',$request->user()->id)->value('specialties')??'[]',true);foreach($specialties as $specialty)if(Matching::validSubcategory($specialty,$value))return;$fail('La subcategoría no pertenece a tus especialidades.');}],'zone'=>['required',Rule::in($rules['zones'])],'zones'=>'required|array|min:1|max:5','zones.*'=>['required','distinct',Rule::in($rules['zones'])],'fee'=>'required|numeric|min:0|max:100000'],
   'accounts'=>['userId'=>'required|integer|exists:users,id','active'=>'required|boolean'],
   'availability'=>['available'=>'required|boolean'],
   'verify'=>['technicianId'=>'required|uuid','verified'=>'required|boolean'],
   'rate'=>['id'=>'required|uuid','rating'=>'required|integer|min:1|max:5'],
   'accept','decline','confirm','start','complete','cancel'=>['id'=>'required|uuid'],
   default=>abort(404)
  };
  $data=$request->validate($validation);$market->action($request->user(),$action,$data);return response()->json(['ok'=>true]);
 }
}
