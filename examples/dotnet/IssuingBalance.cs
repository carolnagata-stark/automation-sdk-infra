using System;
using StarkInfra;

class Program
{
    static void Main()
    {
        // Configure your project credentials
        Project project = new Project(
            id: Environment.GetEnvironmentVariable("SANDBOX_INFRA_ID"),
            privateKey: Environment.GetEnvironmentVariable("SANDBOX_INFRA_PRIVATE_KEY"),
            environment: "sandbox"
        );

        // Fetch your issuing balance
        Settings.User = project;
        StarkInfra.IssuingBalance balance = StarkInfra.IssuingBalance.Get();

        Console.WriteLine($"Balance: {balance.Amount} {balance.Currency}");
        Console.WriteLine($"ID: {balance.ID}");
        Console.WriteLine($"Updated: {balance.Updated}");
    }
}
