#!/usr/bin/env node
/**
 * Get your Stark Infra issuing balance.
 *
 * This is how you use the Starkinfra SDK in a real project.
 */
const starkinfra = require('starkinfra');

// Configure your project credentials
const project = new starkinfra.Project({
    environment: 'sandbox',
    id: process.env.SANDBOX_INFRA_ID,
    privateKey: process.env.SANDBOX_INFRA_PRIVATE_KEY
});

(async () => {
    // Fetch your issuing balance
    const balance = await starkinfra.issuingBalance.get({ user: project });

    console.log(`Balance: ${balance.amount} ${balance.currency}`);
    console.log(`ID: ${balance.id}`);
    console.log(`Updated: ${balance.updated}`);
})();
