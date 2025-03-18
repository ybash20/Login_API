<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Auth\TokenController;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::group(['middleware'=>'auth:sanctum'],function(){

    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    Route::get('/user/posts', function (Request $request) {
        return $request->user()->posts;
    });

    Route::delete('/auth/token', [TokenController::class, 'destroy']);
}); 



Route::post('/auth/token', [TokenController::class, 'store']);
// Route::delete('/auth/token', [TokenController::class, 'destroy'])->middleware('auth:sanctum');

