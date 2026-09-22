<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration {
 public function up(): void {
  Schema::create('users',function(Blueprint $t){$t->id();$t->string('name');$t->string('email')->unique();$t->string('password');$t->string('role');$t->timestamps();});
  Schema::create('api_tokens',function(Blueprint $t){$t->id();$t->foreignId('user_id')->constrained()->cascadeOnDelete();$t->string('token_hash',64)->unique();$t->timestamp('expires_at');});
  Schema::create('technicians',function(Blueprint $t){$t->uuid('id')->primary();$t->foreignId('user_id')->unique()->constrained();$t->string('zone');$t->json('zones');$t->json('specialties');$t->decimal('fee',10,2);$t->decimal('rating',9,6)->default(0);$t->unsignedInteger('reviews')->default(0);$t->unsignedInteger('years')->default(0);$t->boolean('verified')->default(false);$t->boolean('available')->default(false);});
  Schema::create('requests',function(Blueprint $t){$t->uuid('id')->primary();$t->foreignId('client_id')->constrained('users');$t->string('specialty');$t->string('zone');$t->string('address');$t->text('description');$t->string('status')->index();$t->uuid('technician_id')->nullable();$t->foreign('technician_id')->references('id')->on('technicians');$t->decimal('agreed_fee',10,2)->nullable();$t->unsignedTinyInteger('rating')->nullable();$t->bigInteger('created_ms');$t->bigInteger('pending_until');$t->bigInteger('completed_at')->nullable();$t->bigInteger('rating_until')->nullable();$t->json('events');});
  Schema::create('offers',function(Blueprint $t){$t->id();$t->uuid('request_id');$t->foreign('request_id')->references('id')->on('requests')->cascadeOnDelete();$t->uuid('technician_id');$t->foreign('technician_id')->references('id')->on('technicians');$t->string('status');$t->bigInteger('sent_at');$t->bigInteger('expires_at')->index();$t->decimal('score',9,6);$t->unique(['request_id','technician_id']);});
 }
 public function down(): void {foreach(['offers','requests','technicians','api_tokens','users'] as $table)Schema::dropIfExists($table);}
};
