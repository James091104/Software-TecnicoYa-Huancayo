<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\MarketplaceController;
Route::get('/health',fn()=>['status'=>'ok','service'=>'tecnicoya-laravel']);
Route::middleware('throttle:10,1')->group(function(){Route::post('/login',[AuthController::class,'login']);Route::post('/register',[AuthController::class,'register']);});
Route::middleware(['token','throttle:120,1'])->group(function(){Route::post('/logout',[AuthController::class,'logout']);Route::get('/state',[MarketplaceController::class,'state']);Route::post('/actions/{action}',[MarketplaceController::class,'action']);});
