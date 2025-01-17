use starknet::{ContractAddress, ClassHash};

#[derive(Copy, Drop, Serde)]
pub struct YieldSourceData {
    pub APY: felt252,
    pub deposit_limit: felt252,
}

#[starknet::interface]
pub trait IYieldSource<TContractState> {
    fn deposit(ref self: TContractState, token: ContractAddress, amount: felt252);
    fn withdraw(ref self: TContractState, token: ContractAddress, amount: felt252);
    fn withdraw_yield(ref self: TContractState, token: ContractAddress);
    fn get_supply_pool_data(self: @TContractState, token: ContractAddress) -> YieldSourceData;
    fn get_yield_generated(self: @TContractState, token: ContractAddress) -> u256;
    fn get_total_value_locked(self: @TContractState, token: ContractAddress) -> u256;
    fn get_supported_assets(self: @TContractState) -> Array<ContractAddress>;
    fn get_source_class_hash(self: @TContractState) -> ClassHash;
    fn get_source_contract_address(self: @TContractState) -> ContractAddress;
}
