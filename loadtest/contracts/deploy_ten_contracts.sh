#!/bin/bash
echo -n Admin Key Name:
read keyname
echo
echo -n Chain ID:
read chainid
echo
echo -n seid binary:
read seidbin
echo
echo -n sei-chain directory:
read seihome
echo

cd $seihome/loadtest/contracts/mars && cargo build && docker run --rm -v "$(pwd)":/code \
  --mount type=volume,source="$(basename "$(pwd)")_cache",target=/code/target \
  --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry \
  cosmwasm/rust-optimizer:0.12.6

cd $seihome/loadtest/contracts/saturn && cargo build && docker run --rm -v "$(pwd)":/code \
  --mount type=volume,source="$(basename "$(pwd)")_cache",target=/code/target \
  --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry \
  cosmwasm/rust-optimizer:0.12.6

cd $seihome/loadtest/contracts/venus && cargo build && docker run --rm -v "$(pwd)":/code \
  --mount type=volume,source="$(basename "$(pwd)")_cache",target=/code/target \
  --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry \
  cosmwasm/rust-optimizer:0.12.6

# Deploy all contracts
echo "Deploying contracts..."

cd $seihome/loadtest/contracts
# store
echo "Storing..."
marsstoreres=$(printf "12345678\n" | $seidbin tx wasm store mars/artifacts/mars.wasm -y --from=$keyname --chain-id=$chainid --gas=5000000 --fees=1000000usei --broadcast-mode=block --output=json)
saturnstoreres=$(printf "12345678\n" | $seidbin tx wasm store saturn/artifacts/saturn.wasm -y --from=$keyname --chain-id=$chainid --gas=5000000 --fees=1000000usei --broadcast-mode=block --output=json)
venusstoreres=$(printf "12345678\n" | $seidbin tx wasm store venus/artifacts/venus.wasm -y --from=$keyname --chain-id=$chainid --gas=5000000 --fees=1000000usei --broadcast-mode=block --output=json)
marsid=$(python3 parser.py code_id $marsstoreres)
saturnid=$(python3 parser.py code_id $saturnstoreres)
venusid=$(python3 parser.py code_id $venusstoreres)

# instantiate
echo "Instantiating..."
marsinsres=$(printf "12345678\n" | $seidbin tx wasm instantiate $marsid '{}' -y --no-admin --from=$keyname --chain-id=$chainid --gas=5000000 --fees=1000000usei --broadcast-mode=block  --label=dex --output=json)
saturninsres=$(printf "12345678\n" | $seidbin tx wasm instantiate $saturnid '{}' -y --no-admin --from=$keyname --chain-id=$chainid --gas=5000000 --fees=1000000usei --broadcast-mode=block  --label=dex --output=json)
venusinsres=$(printf "12345678\n" | $seidbin tx wasm instantiate $venusid '{}' -y --no-admin --from=$keyname --chain-id=$chainid --gas=5000000 --fees=1000000usei --broadcast-mode=block  --label=dex --output=json)
marsaddr=$(python3 parser.py contract_address $marsinsres)
saturnaddr=$(python3 parser.py contract_address $saturninsres)
venusaddr=$(python3 parser.py contract_address $venusinsres)

marsinsres2=$(printf "12345678\n" | $seidbin tx wasm instantiate $marsid '{}' -y --no-admin --from=$keyname --chain-id=$chainid --gas=5000000 --fees=1000000usei --broadcast-mode=block  --label=dex --output=json)
saturninsres2=$(printf "12345678\n" | $seidbin tx wasm instantiate $saturnid '{}' -y --no-admin --from=$keyname --chain-id=$chainid --gas=5000000 --fees=1000000usei --broadcast-mode=block  --label=dex --output=json)
venusinsres2=$(printf "12345678\n" | $seidbin tx wasm instantiate $venusid '{}' -y --no-admin --from=$keyname --chain-id=$chainid --gas=5000000 --fees=1000000usei --broadcast-mode=block  --label=dex --output=json)
marsaddr2=$(python3 parser.py contract_address $marsinsres2)
saturnaddr2=$(python3 parser.py contract_address $saturninsres2)
venusaddr2=$(python3 parser.py contract_address $venusinsres2)

marsinsres3=$(printf "12345678\n" | $seidbin tx wasm instantiate $marsid '{}' -y --no-admin --from=$keyname --chain-id=$chainid --gas=5000000 --fees=1000000usei --broadcast-mode=block  --label=dex --output=json)
saturninsres3=$(printf "12345678\n" | $seidbin tx wasm instantiate $saturnid '{}' -y --no-admin --from=$keyname --chain-id=$chainid --gas=5000000 --fees=1000000usei --broadcast-mode=block  --label=dex --output=json)
venusinsres3=$(printf "12345678\n" | $seidbin tx wasm instantiate $venusid '{}' -y --no-admin --from=$keyname --chain-id=$chainid --gas=5000000 --fees=1000000usei --broadcast-mode=block  --label=dex --output=json)
marsaddr3=$(python3 parser.py contract_address $marsinsres3)
saturnaddr3=$(python3 parser.py contract_address $saturninsres3)
venusaddr3=$(python3 parser.py contract_address $venusinsres3)

marsinsres4=$(printf "12345678\n" | $seidbin tx wasm instantiate $marsid '{}' -y --no-admin --from=$keyname --chain-id=$chainid --gas=5000000 --fees=1000000usei --broadcast-mode=block  --label=dex --output=json)
marsaddr4=$(python3 parser.py contract_address $marsinsres4)

# register
echo "Registering..."

valaddr=$(printf "12345678\n" | $seidbin keys show $(printf "12345678\n" | $seidbin keys show node_admin --output json | jq -r .address) --bech=val --output json | jq -r '.address')
printf "12345678\n" | $seidbin tx staking delegate $valaddr 1000000000usei --from=$keyname --chain-id=$chainid -b block -y --fees 2000usei

printf "12345678\n" | $seidbin tx dex register-contract $marsaddr $marsid false true 1000000 -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block
printf "12345678\n" | $seidbin tx dex register-contract $saturnaddr $saturnid false true 1000000 -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block
printf "12345678\n" | $seidbin tx dex register-contract $venusaddr $venusid false true 1000000 -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block
printf "12345678\n" | $seidbin tx dex register-contract $marsaddr2 $marsid false true 1000000 -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block
printf "12345678\n" | $seidbin tx dex register-contract $saturnaddr2 $saturnid false true 1000000 -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block
printf "12345678\n" | $seidbin tx dex register-contract $venusaddr2 $venusid false true 1000000 -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block
printf "12345678\n" | $seidbin tx dex register-contract $marsaddr3 $marsid false true 1000000 -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block
printf "12345678\n" | $seidbin tx dex register-contract $saturnaddr3 $saturnid false true 1000000 -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block
printf "12345678\n" | $seidbin tx dex register-contract $venusaddr3 $venusid false true 1000000 -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block
printf "12345678\n" | $seidbin tx dex register-contract $marsaddr4 $marsid false true 1000000 -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block

echo '{"batch_contract_pair":[{"contract_addr":"'$marsaddr'","pairs":[{"price_denom":"SEI","asset_denom":"ATOM","tick_size":"0.0000001"}]}]}' > mars.json
marspair=$(printf "12345678\n" | $seidbin tx dex register-pairs mars.json -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block --output=json)

echo '{"batch_contract_pair":[{"contract_addr":"'$saturnaddr'","pairs":[{"price_denom":"SEI","asset_denom":"ATOM","tick_size":"0.0000001"}]}]}' > saturn.json
saturnpair=$(printf "12345678\n" | $seidbin tx dex register-pairs saturn.json -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block --output=json)

echo '{"batch_contract_pair":[{"contract_addr":"'$venusaddr'","pairs":[{"price_denom":"SEI","asset_denom":"ATOM","tick_size":"0.0000001"}]}]}' > venus.json
venuspair=$(printf "12345678\n" | $seidbin tx dex register-pairs venus.json -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block --output=json)

echo '{"batch_contract_pair":[{"contract_addr":"'$marsaddr2'","pairs":[{"price_denom":"SEI","asset_denom":"ATOM","tick_size":"0.0000001"}]}]}' > mars2.json
marspair2=$(printf "12345678\n" | $seidbin tx dex register-pairs mars2.json -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block --output=json)

echo '{"batch_contract_pair":[{"contract_addr":"'$saturnaddr2'","pairs":[{"price_denom":"SEI","asset_denom":"ATOM","tick_size":"0.0000001"}]}]}' > saturn2.json
saturnpair2=$(printf "12345678\n" | $seidbin tx dex register-pairs saturn2.json -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block --output=json)

echo '{"batch_contract_pair":[{"contract_addr":"'$venusaddr2'","pairs":[{"price_denom":"SEI","asset_denom":"ATOM","tick_size":"0.0000001"}]}]}' > venus2.json
venuspair2=$(printf "12345678\n" | $seidbin tx dex register-pairs venus2.json -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block --output=json)

echo '{"batch_contract_pair":[{"contract_addr":"'$marsaddr3'","pairs":[{"price_denom":"SEI","asset_denom":"ATOM","tick_size":"0.0000001"}]}]}' > mars3.json
marspair3=$(printf "12345678\n" | $seidbin tx dex register-pairs mars3.json -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block --output=json)

echo '{"batch_contract_pair":[{"contract_addr":"'$saturnaddr3'","pairs":[{"price_denom":"SEI","asset_denom":"ATOM","tick_size":"0.0000001"}]}]}' > saturn3.json
saturnpair3=$(printf "12345678\n" | $seidbin tx dex register-pairs saturn3.json -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block --output=json)

echo '{"batch_contract_pair":[{"contract_addr":"'$venusaddr3'","pairs":[{"price_denom":"SEI","asset_denom":"ATOM","tick_size":"0.0000001"}]}]}' > venus3.json
venuspair3=$(printf "12345678\n" | $seidbin tx dex register-pairs venus3.json -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block --output=json)

echo '{"batch_contract_pair":[{"contract_addr":"'$marsaddr4'","pairs":[{"price_denom":"SEI","asset_denom":"ATOM","tick_size":"0.0000001"}]}]}' > mars4.json
marspair4=$(printf "12345678\n" | $seidbin tx dex register-pairs mars4.json -y --from=$keyname --chain-id=$chainid --fees=10000000usei --gas=500000 --broadcast-mode=block --output=json)

sleep 90

printf "12345678\n" | $seidbin tx staking unbond $valaddr 1000000000usei --from=$keyname --chain-id=$chainid -b block -y --fees 2000usei

echo $marsaddr
echo $saturnaddr
echo $venusaddr
echo $marsaddr2
echo $saturnaddr2
echo $venusaddr2
echo $marsaddr3
echo $saturnaddr3
echo $venusaddr3
echo $marsaddr4

echo '{"batch_contract_pair":[{"contract_addr":"sei14hj2tavq8fpesdwxxcu44rty3hh90vhujrvcmstl4zr3txmfvw9sh9m79m","pairs":[{"price_denom":"SEI","asset_denom":"ATOM","tick_size":"0.0000001"}]}]}' > mars4.json