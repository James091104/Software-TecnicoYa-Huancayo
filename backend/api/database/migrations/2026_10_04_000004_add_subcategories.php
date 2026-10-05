<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration {
 public function up(): void {
  Schema::table('technicians',function(Blueprint $t){$t->json('subcategories')->nullable();});
  Schema::table('requests',function(Blueprint $t){$t->string('subcategory')->nullable()->index();});
 }
 public function down(): void {
  Schema::table('requests',function(Blueprint $t){$t->dropColumn('subcategory');});
  Schema::table('technicians',function(Blueprint $t){$t->dropColumn('subcategories');});
 }
};
