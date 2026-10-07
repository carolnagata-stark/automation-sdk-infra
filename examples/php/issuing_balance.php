#!/usr/bin/env php
<?php
/**
 * Get your Stark Infra issuing balance.
 *
 * This is how you use the Starkinfra SDK in a real project.
 */
require __DIR__ . '/vendor/autoload.php';

use StarkInfra\Project;
use StarkInfra\IssuingBalance;

// Configure your project credentials
$project = new Project([
    'environment' => 'sandbox',
    'id' => getenv('SANDBOX_INFRA_ID'),
    'privateKey' => getenv('SANDBOX_INFRA_PRIVATE_KEY')
]);

// Fetch your issuing balance
$balance = IssuingBalance::get($project);

echo "Balance: {$balance->amount} {$balance->currency}\n";
echo "ID: {$balance->id}\n";
echo "Updated: {$balance->updated->format('Y-m-d\TH:i:s.uP')}\n";
