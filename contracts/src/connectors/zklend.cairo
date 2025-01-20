use starknet::ContractAddress;

#[starknet::interface]
trait IZKLend<TContractState> {
    fn deposit(ref self: TContractState, token: ContractAddress, amount: felt252);
    fn withdraw(ref self: TContractState, token: ContractAddress, amount: felt252);
    fn get_lending_accumulator(self: @TContractState, token: ContractAddress) -> felt252;
    fn get_reserve_data(self: @TContractState, token: ContractAddress) -> MarketReserveData;
}
#[derive(Drop, Serde)]
struct MarketReserveData {
    enabled: bool,
    decimals: felt252,
    z_token_address: ContractAddress,
    interest_rate_model: ContractAddress,
    collateral_factor: felt252,
    borrow_factor: felt252,
    reserve_factor: felt252,
    last_update_timestamp: felt252,
    lending_accumulator: felt252,
    debt_accumulator: felt252,
    current_lending_rate: felt252,
    current_borrowing_rate: felt252,
    raw_total_debt: felt252,
    flash_loan_fee: felt252,
    liquidation_bonus: felt252,
    debt_limit: felt252,
    deposit_limit: felt252,
}

#[starknet::contract]
pub mod ZKLendConnector {
    use starknet::{ContractAddress, ClassHash};
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use starknet::syscalls::library_call_syscall;
    use starknet::SyscallResult;
    use win_saved::interfaces::iyieldsource::{IYieldSource, YieldSourceData};
    use super::{IZKLendDispatcher, IZKLendDispatcherTrait};

    #[storage]
    struct Storage {
        contract_address: ContractAddress,
        contract_class_hash: ClassHash
    }

    #[constructor]
    fn constructor(
        ref self: ContractState, contract_address: ContractAddress, class_hash: ClassHash
    ) {
        self.contract_address.write(contract_address);
        self.contract_class_hash.write(class_hash);
    }

    #[abi(embed_v0)]
    impl ZKLendConnectorImpl of IYieldSource<ContractState> {
        fn get_source_class_hash(self: @ContractState) -> ClassHash {
            self.contract_class_hash.read()
        }
        fn get_source_contract_address(self: @ContractState) -> ContractAddress {
            self.contract_address.read()
        }
        fn deposit(ref self: ContractState, token: ContractAddress, amount: felt252) {
            let lib_address = self.contract_class_hash.read();
            // Make the library call
            library_call_syscall(
                lib_address,
                selector!("deposit"), // Function selector
                array![token.into(), amount].span()
            )
                .unwrap();
        }
        fn withdraw(ref self: ContractState, token: ContractAddress, amount: felt252) {
            let lib_address = self.contract_class_hash.read();
            library_call_syscall(
                lib_address,
                selector!("withdraw"), // Function selector
                array![token.into(), amount].span()
            )
                .unwrap();
        }
        fn withdraw_yield(ref self: ContractState, token: ContractAddress) {}
        fn get_supply_pool_data(self: @ContractState, token: ContractAddress) -> YieldSourceData {
            let izklend_dispatcher = IZKLendDispatcher {
                contract_address: self.contract_address.read()
            };
            let accumulator = izklend_dispatcher.get_lending_accumulator(token);
            let data = izklend_dispatcher.get_reserve_data(token);
            YieldSourceData { APY: accumulator, deposit_limit: data.deposit_limit }
        }
        fn get_yield_generated(self: @ContractState, token: ContractAddress) -> u128 {
            1000000
        }
        fn get_total_value_locked(self: @ContractState, token: ContractAddress) -> u128 {
            100000
        }
        fn get_supported_assets(self: @ContractState) -> Array<ContractAddress> {
            let asset_array: Array<ContractAddress> = array![];
            asset_array
        }
    }
}
