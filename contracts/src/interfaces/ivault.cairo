use core::starknet::ContractAddress;
use core::starknet::ClassHash;
use win_saved::types::YieldSourceData;

#[derive(Drop, Serde)]
pub struct WinnerStruct {
    pub address: ContractAddress,
    pub date: u64,
    pub amount: u256
}

#[starknet::interface]
pub trait IVault<TContractState> {
    fn deposit(ref self: TContractState, amount: u256);
    fn withdraw(ref self: TContractState, amount: u256);
    fn draw(ref self: TContractState, random_value: u32);
    fn get_total_assets(self: @TContractState) -> u256;
    fn get_yield_source_data(self: @TContractState) -> YieldSourceData;
    fn get_recent_winners(self: @TContractState) -> Array<WinnerStruct>;
    fn pause(ref self: TContractState);
    fn unpause(ref self: TContractState);
    fn upgrade(ref self: TContractState, new_class_hash: ClassHash);
}
