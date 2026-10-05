<?php
namespace App\Services;
use App\Models\User;

final class Permissions {
 public const ROLES = [
  'client' => ['create','confirm','cancel','rate','profile'],
  'technician' => ['availability','accept','decline','start','complete','profile','technician-profile'],
  'admin' => ['verify','accounts','profile','announcement-save'],
 ];
 public static function forRole(string $role): array {return self::ROLES[$role] ?? [];}
 public static function authorize(User $user, string $action): void {
  abort_unless($user->is_active && in_array($action,self::forRole($user->role),true),403,'No tienes permiso para realizar esta acción.');
 }
}
