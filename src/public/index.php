<?php

use \Psr\Http\Message\ServerRequestInterface as PsrRequest;
use \Psr\Http\Message\ResponseInterface as PsrResponse;
use Slim\Views\PhpRenderer as Renderer;
use GuzzleHttp\Client as GuzzleClient;
use Dotenv\Dotenv;
use Slim\App;

require '../vendor/autoload.php';

$app = new App([
    'debug' => true,
]);

$container = $app->getContainer();
$container['view'] = new Renderer("../templates/");

$params = [];
$dotenv = new Dotenv(__DIR__);

foreach ($dotenv->load() as $var) {
    list($key, $value) = explode('=', $var);
    $params[$key] = $value;
}

# default route
$app->get('/hello/{name}', function (PsrRequest $request, PsrResponse $response) {
    $name = $request->getAttribute('name');
    $response->getBody()->write("Hello, $name");

    $response = $this->view->render($response, "index.html", [
        'name'     => $name,
    ]);

    return $response;
});

# guzzle test route
$app->get('/get', function (PsrRequest $request, PsrResponse $response) {

    $client = new GuzzleClient();
    $res = $client->request('GET', 'https://api.github.com/repos/guzzle/guzzle');
    $status = $res->getStatusCode();
    $header = $res->getHeaderLine('content-type');

    $response->getBody()->write("[Status], $status\n");
    $response->getBody()->write("[Header], $header\n");

    return $response;
});

$app->run();