use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
pub struct YieldSourceData {
    pub lending_accumulator: felt252,
    pub deposit_limit: felt252,
}

#[derive(Copy, Drop, Serde)]
pub struct UserBalanceStruct {
    pub address: ContractAddress,
    pub amount: u256,
}

#[derive(Copy, Drop, Serde)]
pub struct TokenData {
    pub symbol: ByteArray,
    pub address: ContractAddress
}

#[derive(Copy, Drop, Serde)]
pub struct VaultDetails {
    pub yield_token: TokenData,
    pub vault_token: TokenData,
    pub APY: felt252,
    pub owner: ContractAddress,
    pub total_deposit: u256,
    pub total_yield: u256
}
