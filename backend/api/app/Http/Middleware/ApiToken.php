<?php
namespace App\Http\Middleware;
use App\Models\User;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
class ApiToken {
 public function handle(Request $request, Closure $next) {
  $token=$request->bearerToken();
  abort_unless($token,401,'Inicia sesión para continuar.');
  $record=DB::table('api_tokens')->where('token_hash',hash('sha256',$token))->where('expires_at','>',now())->first();
  abort_unless($record,401,'Tu sesión venció. Inicia sesión nuevamente.');
  $user=User::find($record->user_id);abort_unless($user && $user->is_active && isset(\App\Services\Permissions::ROLES[$user->role]),401,'Tu cuenta no está habilitada. Contacta con administración.');
  $request->setUserResolver(fn()=>$user);
  return $next($request);
 }
}
