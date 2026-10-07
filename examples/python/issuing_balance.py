#!/usr/bin/env python3
"""
Get your Stark Infra issuing balance.

This is how you use the Starkinfra SDK in a real project.
"""
import os
import starkinfra

# Configure your project credentials
project = starkinfra.Project(
    environment="sandbox",
    id=os.environ["SANDBOX_INFRA_ID"],
    private_key=os.environ["SANDBOX_INFRA_PRIVATE_KEY"]
)

# Fetch your issuing balance
balance = starkinfra.issuingbalance.get(user=project)

print(f"Balance: {balance.amount} {balance.currency}")
print(f"ID: {balance.id}")
print(f"Updated: {balance.updated}")
