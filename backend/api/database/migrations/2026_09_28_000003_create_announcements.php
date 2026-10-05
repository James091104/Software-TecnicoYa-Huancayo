<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration {
 public function up(): void {
  Schema::create('announcements',function(Blueprint $t){
   $t->uuid('id')->primary();$t->string('title',120);$t->text('body');
   $t->string('audience',20);$t->string('status',20)->default('draft');
   $t->unsignedInteger('priority')->default(0);$t->longText('image')->nullable();
   $t->string('link_url',2048)->nullable();$t->string('link_label',40)->nullable();
   $t->foreignId('updated_by')->constrained('users');$t->timestamps();
   $t->index(['status','audience']);
  });
 }
 public function down(): void {Schema::dropIfExists('announcements');}
};
