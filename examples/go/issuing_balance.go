package main

import (
	"fmt"
	"os"

	"github.com/starkinfra/core-go/starkcore/user/project"
	"github.com/starkinfra/core-go/starkcore/utils/checks"
	"github.com/starkinfra/sdk-go/starkinfra"
	"github.com/starkinfra/sdk-go/starkinfra/issuingbalance"
)

func main() {
	// Configure your project credentials
	privateKey, _ := checks.CheckPrivateKey(os.Getenv("SANDBOX_INFRA_PRIVATE_KEY"))
	environment, _ := checks.CheckEnvironment("sandbox")

	starkinfra.User = project.Project{
		Id:          os.Getenv("SANDBOX_INFRA_ID"),
		PrivateKey:  privateKey,
		Environment: environment,
	}

	// Fetch your issuing balance
	balance, err := issuingbalance.Get(nil)

	if err.Errors != nil {
		for _, e := range err.Errors {
			fmt.Printf("code: %s, message: %s", e.Code, e.Message)
		}
		os.Exit(1)
	}

	fmt.Printf("%+v", balance)
}
