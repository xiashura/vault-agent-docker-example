with (import <nixpkgs> { });
let
  vault-init-secret = pkgs.writeShellScriptBin "vault-init-secret" ''
    vault policy write app $VAULT_PATH_ROLES

    vault secrets enable -version=2 kv
    vault kv put kv/secrets/static id=1 user=test1 password=sup4s3cr3t

  '';
  vault-approle = pkgs.writeShellScriptBin "vault-approle" ''
    vault auth enable approle
    vault write auth/approle/role/app token_policies="app"

    vault read -format=json auth/approle/role/app/role-id | jq -r '.data.role_id' > $VAULT_AGENT_DIR/roleid
    vault write -format=json -f auth/approle/role/app/secret-id | jq -r '.data.secret_id' > $VAULT_AGENT_DIR/secretid

    docker restart vault-agent
  '';

in stdenv.mkDerivation {

  VAULT_PATH_ROLES = "./policy/admin-policy.hcl";
  VAULT_AGENT_DIR = "./vault-agent/config";
  VAULT_ADDR = "http://127.0.0.1:8200";
  VAULT_TOKEN = "root";

  name = "vault";
  buildInputs = [ vault-approle vault-init-secret vault jq ];
}
