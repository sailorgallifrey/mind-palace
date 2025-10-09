#!/usr/bin/env bash
declare -A region_map
region_map["us-east-1"]="usea1"
region_map["us-east-2"]="usea2"

base_path=~/Developer/isg-sre-yggdrasil
cluster_family_paths=($base_path/clusters/*)

for cluster_family_path in "${cluster_family_paths[@]}"; do
  cluster_realm=$(basename "$cluster_family_path")

  cluster_families=$(hcl2json "$cluster_family_path"/_default.tfvars | jq -rc '.cluster_families | keys')
  for cluster_family in $(echo "$cluster_families" | jq -r .[]); do
    cluster_name=idp-"$cluster_family"

    export CLUSTER_REALM="$cluster_realm"
    export CLUSTER_NAME="$cluster_name"

    environments=$(helmfile --quiet build --file $base_path/k8s/00-bootstrap.yaml.gotmpl | yq '.environments | keys')
    for environment in $(echo "$environments" | yq -r .[]); do
      for region in "${!region_map[@]}"; do
        short_region=${region_map[$region]}
        if [[ $environment == *"$region"* ]]; then
          cluster_region="$region"
          cluster_env_short="${environment/$region/"$short_region"}"
          cluster_env_no_region="${environment/-$region/""}"
        fi
      done

      aws_account="aws-isg-$cluster_env_no_region"
      alias="${cluster_env_short/$cluster_realm/"$cluster_name"}"
      if $update_all || gum confirm "Add or update local context?" --default=true; then
        echo -n "$(gum style --bold --padding "0 3" --foreground "#FFDE00" "AWS Account:")"
        gum style --foreground "" "   $aws_account"
        echo -n "$(gum style --bold --padding "0 3" --foreground "#FFDE00" "Cluster Name:")"
        gum style --foreground "" "  $cluster_name"
        echo -n "$(gum style --bold --padding "0 3" --foreground "#FFDE00" "Cluster Region:")"
        gum style --foreground "" "$cluster_region"
        echo -n "$(gum style --bold --padding "0 3" --foreground "#FFDE00" "Cluster Alias:")"
        echo -e "$(gum style --foreground "" " $alias")\n"

        output=$(aws eks update-kubeconfig \
          --profile "$aws_account" \
          --region "$cluster_region" \
          --name "$cluster_name" \
          --alias "$alias" \
          --user-alias "$alias")
        echo -e "$(gum style --italic --padding "0 3" --foreground "#367C2B" "$output.")\n"

        echo -n "$(gum style --bold --padding "0 3" --foreground "#FFDE00" "AWS Account:")"
        gum style --foreground "" "   $aws_account-FIREFIGHT"
        echo -n "$(gum style --bold --padding "0 3" --foreground "#FFDE00" "Cluster Name:")"
        gum style --foreground "" "  $cluster_name"
        echo -n "$(gum style --bold --padding "0 3" --foreground "#FFDE00" "Cluster Region:")"
        gum style --foreground "" "$cluster_region"
        echo -n "$(gum style --bold --padding "0 3" --foreground "#FFDE00" "Cluster Alias:")"
        echo -e "$(gum style --foreground "" " $alias-ff")\n"


        output_ff=$(aws eks update-kubeconfig \
          --profile "$aws_account"-FIREFIGHT \
          --region "$cluster_region" \
          --name "$cluster_name" \
          --alias "$alias-ff" \
          --user-alias "$alias-ff")
        echo -e "$(gum style --italic --padding "0 3" --foreground "#367C2B" "$output_ff.")\n"
      elif test $? -eq 130; then
        exit 130 # allow Ctrl-C to exit script entirely
      else
        echo -e "$(gum style --italic --padding "0 3" --foreground "#367C2B" "Skipped $alias.")\n"
      fi
    done
  done
done
