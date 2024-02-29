<?php

namespace App\interfaces;

use App\Request\LoginRequest;
use App\Request\UserRegisterRequest;

interface LoginRepositoryInterface
{
    public function login(array $request);
    public function register(array $request);
}