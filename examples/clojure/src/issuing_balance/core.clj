(ns issuing-balance.core
  (:require [starkinfra.issuing-balance :as issuing-balance]
            [starkinfra.settings]
            [starkinfra.user]))

(defn -main []
  ;; Configure your project credentials
  (starkinfra.settings/user
    (starkinfra.user/project
      "sandbox"
      (System/getenv "SANDBOX_INFRA_ID")
      (System/getenv "SANDBOX_INFRA_PRIVATE_KEY")))

  ;; Fetch your issuing balance
  (let [balance (issuing-balance/get)]
    (println (str "Balance: " (:amount balance) " " (:currency balance)))
    (println (str "ID: " (:id balance)))
    (println (str "Updated: " (:updated balance)))))
