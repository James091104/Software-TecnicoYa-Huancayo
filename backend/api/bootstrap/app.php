<?php
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;
return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(api: __DIR__.'/../routes/api.php', commands: __DIR__.'/../routes/console.php', health: '/health')
    ->withMiddleware(function (Middleware $middleware) { $middleware->alias(['token'=>\App\Http\Middleware\ApiToken::class]); })
    ->withExceptions(function (Exceptions $exceptions) { $exceptions->shouldRenderJsonWhen(fn(Request $r, Throwable $e)=>true); })->create();
