<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration {
 public function up(): void {
  Schema::table('users',function(Blueprint $t){$t->boolean('is_active')->default(true);});
  Schema::create('access_events',function(Blueprint $t){$t->id();$t->foreignId('actor_id')->constrained('users');$t->foreignId('user_id')->constrained('users');$t->string('action');$t->timestamp('created_at');});
 }
 public function down(): void {Schema::dropIfExists('access_events');Schema::table('users',fn(Blueprint $t)=>$t->dropColumn('is_active'));}
}
;