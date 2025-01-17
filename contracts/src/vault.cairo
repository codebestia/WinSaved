#[starknet::contract]
pub mod Vault {
    use core::num::traits::Zero;
    use core::starknet::{
        ContractAddress, get_caller_address, get_contract_address, get_block_timestamp, ClassHash
    };
    use core::starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Vec, VecTrait,
        MutableVecTrait
    };
    use openzeppelin_access::ownable::OwnableComponent;
    use openzeppelin_token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    use openzeppelin_security::{PausableComponent, ReentrancyGuardComponent};
    use openzeppelin_upgrades::upgradeable::UpgradeableComponent;
    use win_saved::interfaces::{
        ivault::{IVault, WinnerStruct}, ierc20::{IERC20Dispatcher, IERC20DispatcherTrait},
        iyieldsource::{IYieldSourceDispatcher, IYieldSourceDispatcherTrait}
    };
    use win_saved::types::{YieldSourceData, UserBalanceStruct, VaultDetails, TokenData};

    component!(path: ERC20Component, storage: erc20, event: ERC20Event);
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: PausableComponent, storage: pausable, event: PausableEvent);
    component!(
        path: ReentrancyGuardComponent, storage: reentrancyguard, event: ReentrancyGuardEvent
    );
    component!(path: UpgradeableComponent, storage: upgradable, event: UpgradableEvent);

    #[abi(embed_v0)]
    impl ERC20MixinImpl = ERC20Component::ERC20MixinImpl<ContractState>;
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;

    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[abi(embed_v0)]
    impl PausableImpl = PausableComponent::PausableImpl<ContractState>;
    impl PausableInternalImpl = PausableComponent::InternalImpl<ContractState>;

    impl ReentrancyGuardInternalImpl = ReentrancyGuardComponent::InternalImpl<ContractState>;

    impl UpgradeableInternalImpl = UpgradeableComponent::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        yield_token: ContractAddress,
        yield_source: ContractAddress,
        draw_duration: u64,
        last_draw_time: u64,
        winners: Vec<Winner>,
        #[substorage(v0)]
        erc20: ERC20Component::Storage,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        #[substorage(v0)]
        pausable: PausableComponent::Storage,
        #[substorage(v0)]
        reentrancyguard: ReentrancyGuardComponent::Storage,
        #[substorage(v0)]
        upgradable: UpgradeableComponent::Storage,
    }

    #[starknet::storage_node]
    struct Winner {
        address: ContractAddress,
        amount: u256,
        date: u64,
        claimed: bool,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        UserDepositedEvent: UserDepositedEvent,
        UserWithdrawalEvent: UserWithdrawalEvent,
        PrizeDrawEvent: PrizeDrawEvent,
        UserWinEvent: UserWinEvent,
        #[flat]
        ERC20Event: ERC20Component::Event,
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        #[flat]
        PausableEvent: PausableComponent::Event,
        #[flat]
        ReentrancyGuardEvent: ReentrancyGuardComponent::Event,
        #[flat]
        UpgradableEvent: UpgradeableComponent::Event,
    }

    #[derive(Drop, starknet::Event)]
    struct UserDepositedEvent {
        #[key]
        user: ContractAddress,
        amount: u256,
        date: u64,
    }
    #[derive(Drop, starknet::Event)]
    struct UserWithdrawalEvent {
        #[key]
        user: ContractAddress,
        amount: u256,
        date: u64,
    }
    #[derive(Drop, starknet::Event)]
    struct PrizeDrawEvent {
        date: u64,
    }
    #[derive(Drop, starknet::Event)]
    struct UserWinEvent {
        #[key]
        user: ContractAddress,
        amount: u256,
        date: u64,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        yield_token: ContractAddress,
        yield_source: ContractAddress,
        draw_duration: u64
    ) {
        let owner = get_caller_address();
        self.ownable.initializer(owner);
        // get yield token name for creater vault token (share) name
        let erc20_dispatcher = IERC20Dispatcher { contract_address: yield_token };
        let token_name = format!("WinSaved_{}", erc20_dispatcher.name());
        let token_symbol = format!("ws{}", erc20_dispatcher.symbol());
        self.yield_token.write(yield_token);
        self.yield_source.write(yield_source);
        self.draw_duration.write(draw_duration);
        self.erc20.initializer(token_name, token_symbol);
    }

    #[abi(embed_v0)]
    impl VaultImpl of IVault<ContractState> {
        fn get_vault_details(self: @ContractState) -> VaultDetails {
            let yield_token_address = self.yield_token.read();
            let yield_erc20_dispatcher = IERC20Dispatcher { contract_address: yield_token_address };
            let yield_source_dispatcher = IYieldSourceDispatcher {
                contract_address: self.yield_source.read()
            };
            let yield_source_data = yield_source_dispatcher
                .get_supply_pool_data(yield_token_address);
            let TVL = yield_source_dispatcher.get_total_value_locked(yield_token_address);
            let total_yield = yield_source_dispatcher.get_yield_generated(yield_token_address);
            VaultDetails {
                yield_token: TokenData {
                    symbol: erc20_dispatcher.symbol(), address: yield_token_address
                },
                vault_token: TokenData {
                    symbol: self.erc20.symbol(), address: get_contract_address()
                },
                APY: yield_source_data.APY,
                owner: self.ownable.owner(),
                total_deposit: TVL,
                total_yield: total_yield
            }
        }
        fn deposit(ref self: ContractState, amount: u256) {
            // check paused
            self.pausable.assert_not_paused();
            self.reentrancyguard.start();
            let caller = get_caller_address();
            let contract_address = get_contract_address();
            //transfer token from user
            let erc20_address = self.yield_token.read();
            let erc20_dispatcher = IERC20Dispatcher { contract_address: erc20_address };
            erc20_dispatcher.transfer_from(caller, contract_address, amount);
            // make call to yield source to deposit
            let yield_source_dispatcher = IYieldSourceDispatcher {
                contract_address: self.yield_source.read()
            };
            yield_source_dispatcher.withdraw(erc20_address, amount.try_into().unwrap());
            // mint token
            self.erc20.mint(caller, amount);
            let current_date_time = get_block_timestamp();
            self.emit(UserDepositedEvent { user: caller, amount: amount, date: current_date_time });
            self.reentrancyguard.end();
        }
        fn pause(ref self: ContractState) {
            self.ownable.assert_only_owner();
            self.pausable.pause();
        }
        fn unpause(ref self: ContractState) {
            self.ownable.assert_only_owner();
            self.pausable.unpause();
        }
        fn withdraw(ref self: ContractState, amount: u256) {
            self.pausable.assert_not_paused();
            self.reentrancyguard.start();
            let caller = get_caller_address();
            let contract_address = get_contract_address();
            // get user vault token balance and assert if balance is equal to amount
            let user_balance = self.erc20.balance_of(caller);
            assert!(user_balance >= amount, "Insufficient balance");
            // make call to yield source to withdraw amount
            let erc20_address = self.yield_token.read();
            let yield_source_dispatcher = IYieldSourceDispatcher {
                contract_address: self.yield_source.read()
            };
            yield_source_dispatcher.withdraw(erc20_address, amount.try_into().unwrap());
            //transfer token to user
            let erc20_dispatcher = IERC20Dispatcher { contract_address: erc20_address };
            // burn token
            self.erc20.burn(caller, amount);
            erc20_dispatcher.transfer(caller, amount);

            let current_date_time = get_block_timestamp();
            self
                .emit(
                    UserWithdrawalEvent { user: caller, amount: amount, date: current_date_time }
                );
            self.reentrancyguard.end();
        }
        fn draw(ref self: ContractState, random_value: u32) {
            self.ownable.assert_only_owner();
            // check whether last draw time is greater than draw duration
            self.assert_vault_draw_availabiliity();

            // check whether yield is available

            // get_all users that deposited to this vault
            let users = self.get_all_users();
            let sorted_holders = self.sort_users_by_balance(users);
            // get the top half for randomization
            let top_average: u32 = sorted_holders.len() / 2;
            let mut top_average_holders: Array<ContractAddress> = array![];
            for idx in 0..top_average {
                top_average_holders.append(*sorted_holders.at(idx));
            };

            let rand_num = random_value % top_average_holders.len();
            let winner = *top_average_holders.at(rand_num.into());
            let win_amount = self.disperse_prize_to_winner(winner);
            self.emit(PrizeDrawEvent { date: get_block_timestamp() });
            self
                .emit(
                    UserWinEvent { user: winner, amount: win_amount, date: get_block_timestamp() }
                );
        }
        fn get_total_assets(self: @ContractState) -> u256 {
            // access total assets form yield source
            let yield_source_dispatcher = IYieldSourceDispatcher {
                contract_address: self.yield_source.read()
            };
            yield_source_dispatcher.get_total_value_locked()
        }
        fn get_yield_source_data(self: @ContractState) -> YieldSourceData {
            // access yield source connector interface
            // change later when connector is created
            YieldSourceData { lending_accumulator: 10, deposit_limit: 10, }
        }
        fn get_recent_winners(self: @ContractState) -> Array<WinnerStruct> {
            let mut winners_array: Array<WinnerStruct> = array![];
            for index in 0
                ..self
                    .winners
                    .len() {
                        let current = self.winners.at(index);
                        winners_array
                            .append(
                                WinnerStruct {
                                    address: current.address.read(),
                                    amount: current.amount.read(),
                                    date: current.date.read()
                                }
                            );
                    };
            winners_array
        }
        fn upgrade(ref self: ContractState, new_class_hash: ClassHash) {
            self.ownable.assert_only_owner();
            assert!(new_class_hash.is_non_zero(), "Zero ClassHash detected.. aborting");
            self.upgradable.upgrade(new_class_hash);
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalImplTrait {
        fn get_all_users(self: @ContractState) -> Array<UserBalanceStruct> {
            // query event for all users that has deposited and check balance of vault token
            // return users with balance greater than zero
            let all_holders: Array<UserBalanceStruct> = array![];
            all_holders
        }
        /// Sort users by vault token balance
        fn sort_users_by_balance(
            self: @ContractState, users: Array<UserBalanceStruct>
        ) -> Array<ContractAddress> {
            let sorted_holders: Array<ContractAddress> = array![];
            sorted_holders
        }
        fn disperse_prize_to_winner(ref self: ContractState, user: ContractAddress) -> u256 {
            // functionality to disperse yield to winner
            // liquidate yield from yield source to contract and transfer to winner
            let yield_amount: u256 =
                1000; // access yield source after liquidation for the exact amount
            // transfer yield amount to winner via dispatcher

            // add winner to winner struct
            let index = self.winners.len();
            let position = self.winners.at(index);
            position.address.write(user);
            position.amount.write(yield_amount);
            position.date.write(get_block_timestamp());
            position.claimed.write(true);

            let erc20_address = self.yield_token.read();
            let erc20_dispatcher = IERC20Dispatcher { contract_address: erc20_address };
            erc20_dispatcher.transfer(user, yield_amount);

            yield_amount
        }
        fn assert_vault_draw_availabiliity(self: @ContractState) {
            let current_time = get_block_timestamp();
            let draw_diff = current_time - self.last_draw_time.read();
            assert!(draw_diff > self.draw_duration.read(), "Cannot make prize draw");
        }
    }
}

