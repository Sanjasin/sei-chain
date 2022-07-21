# ./scripts/initialize_local.sh to spawn chain locally, endpoint is default to localhost:9090
# build the contract to wasm with `cargo build; sudo docker run --rm -v "$(pwd)":/code   --mount type=volume,source="$(basename "$(pwd)")_cache",target=/code/target   --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry   cosmwasm/rust-optimizer:0.12.5`

# upload the code
printf '00000000\n' | ./build/seid tx wasm store ../spot-contract/artifacts/spot_market.wasm -y --from=alice --chain-id=sei --gas=5003639 --fees=100000usei --broadcast-mode=block
# replace addr here with an addr you have privateKey
printf '00000000\n' | ./build/seid tx wasm instantiate 1 '{"whitelist": ["sei1zywupnfk3t8lvtuzh540vls8mf53r5zuq98wkt"],"use_whitelist":false,"admin":"sei1zywupnfk3t8lvtuzh540vls8mf53r5zuq98wkt","limit_order_fee":{"decimal":"0.0001","negative":false},"market_order_fee":{"decimal":"0.0001","negative":false},"liquidation_order_fee":{"decimal":"0.0001","negative":false},"margin_ratio":{"decimal":"0.0625","negative":false},"max_leverage":{"decimal":"4","negative":false}}' -y --no-admin --chain-id=sei --gas=1500000 --fees=15000usei --broadcast-mode=block --label=dex --from=alice
# contract_address highly possible is the same, if not replace
printf '00000000\n' | ./build/seid tx dex register-contract sei14hj2tavq8fpesdwxxcu44rty3hh90vhujrvcmstl4zr3txmfvw9sh9m79m 1 -y --from=alice --chain-id=sei --fees=100000usei --gas=500000 --broadcast-mode=block

# add to asset list
# printf '00000000\n' | ./build/seid tx dex add-asset-proposal ./x/dex/example/add-asset-metadata-proposal.json -y --from=alice --chain-id=sei --fees=10000000usei --gas=500000 --broadcast-mode=block
# printf '00000000\n' | ./build/seid tx gov deposit 1 10000000usei -y --from=alice --chain-id=sei --fees=10000000usei --gas=500000 --broadcast-mode=block
# printf '00000000\n' | ./build/seid tx gov vote 1 yes -y --from=alice --chain-id=sei --fees=10000000usei --gas=500000 --broadcast-mode=block

# # add to asset list
# printf '00000000\n' | ./build/seid tx dex add-asset-proposal ./x/dex/example/add-asset1.json -y --from=alice --chain-id=sei --fees=10000000usei --gas=500000 --broadcast-mode=block
# printf '00000000\n' | ./build/seid tx gov deposit 2 10000000usei -y --from=alice --chain-id=sei --fees=10000000usei --gas=500000 --broadcast-mode=block
# printf '00000000\n' | ./build/seid tx gov vote 2 yes -y --from=alice --chain-id=sei --fees=10000000usei --gas=500000 --broadcast-mode=block

# # add to asset list
# printf '00000000\n' | ./build/seid tx dex add-asset-proposal ./x/dex/example/add-asset2.json -y --from=alice --chain-id=sei --fees=10000000usei --gas=500000 --broadcast-mode=block
# printf '00000000\n' | ./build/seid tx gov deposit 3 10000000usei -y --from=alice --chain-id=sei --fees=10000000usei --gas=500000 --broadcast-mode=block
# printf '00000000\n' | ./build/seid tx gov vote 3 yes -y --from=alice --chain-id=sei --fees=10000000usei --gas=500000 --broadcast-mode=block

# # wait till the asset addition take effects
# sleep 30

# # register a pair
# printf '00000000\n' | ./build/seid tx dex register-pairs-proposal ./x/dex/example/register-pair-proposal.json -y --from=alice --chain-id=sei --fees=10000000usei --gas=500000 --broadcast-mode=block
# printf '00000000\n' | ./build/seid tx gov deposit 4 10000000usei -y --from=alice --chain-id=sei --fees=10000000usei --gas=500000 --broadcast-mode=block
# printf '00000000\n' | ./build/seid tx gov vote 4 yes -y --from=alice --chain-id=sei --fees=10000000usei --gas=500000 --broadcast-mode=block

# sleep 5
# printf '00000000\n' | ./build/seid tx dex update-tick-size-proposal ./x/dex/example/update-tick-size-proposal.json -y --from=alice --chain-id=sei --fees=10000000usei --gas=500000 --broadcast-mode=block
# printf '00000000\n' | ./build/seid tx gov deposit 2 10000000usei -y --from=alice --chain-id=sei --fees=10000000usei --gas=500000 --broadcast-mode=block
# printf '00000000\n' | ./build/seid tx gov vote 2 yes -y --from=alice --chain-id=sei --fees=10000000usei --gas=500000 --broadcast-mode=block


# order: (position_direction, price, quantity, price_denom, asset_denom, position_effect(open/close), order_type(limit, market,..), leverage) 
# need to wait for vote period close to take effect, seem no early stop implemented for vote
#  ./build/seid tx dex place-orders sei14hj2tavq8fpesdwxxcu44rty3hh90vhujrvcmstl4zr3txmfvw9sh9m79m Long?1?1?atom?sei?Limit?1 --amount=10000usei -y --from=alice --chain-id=sei --fees=10000usei --gas=50000000 --broadcast-mode=block