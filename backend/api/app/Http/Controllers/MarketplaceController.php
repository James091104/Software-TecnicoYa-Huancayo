<?php
namespace App\Http\Controllers;
use App\Services\Marketplace;
use App\Services\Matching;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
class MarketplaceController extends Controller {
 public function state(Request $request,Marketplace $market){return response()->json($market->state($request->user()));}
 public function action(Request $request,string $action,Marketplace $market){
  $rules=Matching::rules();
  $validation=match($action){
   'create'=>['specialty'=>['required',Rule::in($rules['specialties'])],'zone'=>['required',Rule::in($rules['zones'])],'address'=>'required|string|min:5|max:200','description'=>'required|string|min:10|max:2000'],
   'availability'=>['available'=>'required|boolean'],
   'verify'=>['technicianId'=>'required|uuid','verified'=>'required|boolean'],
   'rate'=>['id'=>'required|uuid','rating'=>'required|integer|min:1|max:5'],
   'accept','decline','confirm','start','complete','cancel'=>['id'=>'required|uuid'],
   default=>abort(404)
  };
  $data=$request->validate($validation);$market->action($request->user(),$action,$data);return response()->json(['ok'=>true]);
 }
}
