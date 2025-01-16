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
