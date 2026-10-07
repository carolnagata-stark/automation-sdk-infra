import com.starkinfra.IssuingBalance;
import com.starkinfra.Project;

public class IssuingBalanceExample {
    public static void main(String[] args) throws Exception {
        // Configure your project credentials
        Project project = new Project(
            "sandbox",
            System.getenv("SANDBOX_INFRA_ID"),
            System.getenv("SANDBOX_INFRA_PRIVATE_KEY")
        );

        // Fetch your issuing balance
        IssuingBalance balance = IssuingBalance.get(project);

        System.out.printf("Balance: %d %s%n", balance.amount, balance.currency);
        System.out.printf("ID: %s%n", balance.id);
        System.out.printf("Updated: %s%n", balance.updated);
    }
}
