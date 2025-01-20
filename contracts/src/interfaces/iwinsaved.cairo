use starknet::{ContractAddress, ClassHash};
#[starknet::interface]
pub trait IWinSaved<TContractState> {
    fn create_vault(
        ref self: TContractState,
        yield_token: ContractAddress,
        yield_source: ContractAddress,
        draw_duration: u64
    );
    fn make_vault_draw(ref self: TContractState, vault: ContractAddress);
    fn add_yield_token(ref self: TContractState, token: ContractAddress);
    fn add_yield_source(ref self: TContractState, yield_source: ContractAddress, name: ByteArray);
    fn get_vaults(self: @TContractState) -> Array<ContractAddress>;
    fn get_yield_sources(self: @TContractState) -> Array<ContractAddress>;
    fn get_yield_tokens(self: @TContractState) -> Array<ContractAddress>;
    fn pause_vault(ref self: TContractState, vault: ContractAddress);
    fn unpause_vault(ref self: TContractState, vault: ContractAddress);
    fn upgrade_vault(ref self: TContractState, vault: ContractAddress, class_hash: ClassHash);
}
