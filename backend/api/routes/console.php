<?php
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;
use App\Models\User;
use App\Services\Marketplace;
Artisan::command('marketplace:tick',function(){app(Marketplace::class)->tick();$this->info('Plazos procesados.');})->purpose('Expire offers and reassign pending requests');
Schedule::command('marketplace:tick')->everySecond()->withoutOverlapping();
Artisan::command('marketplace:admin',function(){
 $email=strtolower($this->ask('Correo del nuevo administrador'));$name=$this->ask('Nombre');$password=$this->secret('Contraseña (mínimo 12 caracteres)');
 if(!filter_var($email,FILTER_VALIDATE_EMAIL)||!$name||strlen($password??'')<12||User::where('email',$email)->exists()){$this->error('Datos inválidos o correo ya registrado.');return 1;}
 User::create(['name'=>$name,'email'=>$email,'password'=>$password,'role'=>'admin']);$this->info('Administrador creado.');
})->purpose('Create an administrator interactively; no default credentials');
