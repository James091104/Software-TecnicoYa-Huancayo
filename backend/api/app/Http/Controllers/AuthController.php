<?php
namespace App\Http\Controllers;
use App\Models\User;
use App\Services\Marketplace;
use App\Services\Matching;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;
class AuthController extends Controller {
 private function session(User $user,Marketplace $market){$token=bin2hex(random_bytes(32));DB::table('api_tokens')->insert(['user_id'=>$user->id,'token_hash'=>hash('sha256',$token),'expires_at'=>now()->addDay()]);return response()->json(['token'=>$token,'actor'=>$market->actor($user)]);}
 public function register(Request $request,Marketplace $market){$rules=Matching::rules();$data=$request->validate(['name'=>'required|string|min:2|max:100','email'=>'required|email|max:254|unique:users,email','password'=>'required|string|min:8|max:128','role'=>['required',Rule::in(['client','technician'])],'zone'=>['required_if:role,technician',Rule::in($rules['zones'])],'zones'=>'required_if:role,technician|array|min:1|max:5','zones.*'=>Rule::in($rules['zones']),'specialties'=>'required_if:role,technician|array|min:1|max:3','specialties.*'=>Rule::in($rules['specialties']),'fee'=>'required_if:role,technician|numeric|min:0|max:100000','years'=>'required_if:role,technician|integer|min:0|max:80']);
  $user=DB::transaction(function()use($data){$user=User::create(['name'=>$data['name'],'email'=>strtolower($data['email']),'password'=>$data['password'],'role'=>$data['role']]);if($user->role==='technician')DB::table('technicians')->insert(['id'=>(string)Str::uuid(),'user_id'=>$user->id,'zone'=>$data['zone'],'zones'=>json_encode(array_values(array_unique([$data['zone'],...$data['zones']]))),'specialties'=>json_encode(array_values(array_unique($data['specialties']))),'fee'=>$data['fee'],'years'=>$data['years'],'rating'=>0,'reviews'=>0,'verified'=>false,'available'=>false]);return $user;});return response()->json(['message'=>'Cuenta creada correctamente. Inicia sesión para continuar.'],201);
 }
 public function login(Request $request,Marketplace $market){$data=$request->validate(['email'=>'required|email','password'=>'required|string']);$user=User::where('email',strtolower($data['email']))->first();abort_unless($user&&Hash::check($data['password'],$user->password),401,'Correo o contraseña incorrectos.');abort_unless($user->is_active && isset(\App\Services\Permissions::ROLES[$user->role]),403,'Tu cuenta no está habilitada. Contacta con administración.');return $this->session($user,$market);}
 public function logout(Request $request){DB::table('api_tokens')->where('token_hash',hash('sha256',$request->bearerToken()))->delete();return response()->json(['ok'=>true]);}
}
