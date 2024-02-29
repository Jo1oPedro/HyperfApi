<?php

namespace App\Controller;

use App\interfaces\LoginRepositoryInterface;
use App\Request\LoginRequest;
use App\Request\UserRegisterRequest;
use Hyperf\HttpServer\Contract\ResponseInterface;

class AuthController
{
    private $loginRepository;
    private $response;

    public function __construct(LoginRepositoryInterface $loginRepository, ResponseInterface $response)
    {
        $this->loginRepository = $loginRepository;
        $this->response = $response;
    }

    public function login(LoginRequest $request)
    {
        return $this->loginRepository->login($request->validated());
    }

    public function register(UserRegisterRequest $request)
    {
        $result = $this->loginRepository->register($request->validated());

        if($result) {
            return $this->response->json([
                'message' => 'Usuário cadastrado com sucesso.'
            ])->withStatus(201);
        }
        return $this->response->json([
            'error' => 'Não foi possível realizar o cadastro.'
        ])->withStatus(500);
    }
}