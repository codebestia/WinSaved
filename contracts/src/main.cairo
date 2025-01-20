#[starknet::contract]
pub mod WinSaved {
    use starknet::{ContractAddress, ClassHash, get_caller_address, get_block_timestamp};
    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, Vec, VecTrait, MutableVecTrait
    };
    use starknet::syscalls::{deploy_syscall};
    use win_saved::interfaces::{
        iwinsaved::IWinSaved, ivault::{IVaultDispatcher, IVaultDispatcherTrait}
    };

    use openzeppelin_access::ownable::OwnableComponent;
    use openzeppelin_token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    use openzeppelin_security::{PausableComponent, ReentrancyGuardComponent};
    use openzeppelin_upgrades::upgradeable::UpgradeableComponent;

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

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[abi(embed_v0)]
    impl PausableImpl = PausableComponent::PausableImpl<ContractState>;
    impl PausableInternalImpl = PausableComponent::InternalImpl<ContractState>;

    impl ReentrancyGuardInternalImpl = ReentrancyGuardComponent::InternalImpl<ContractState>;

    impl UpgradeableInternalImpl = UpgradeableComponent::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        vaults: Vec<ContractAddress>,
        tokens: Vec<ContractAddress>,
        yield_sources: Vec<ContractAddress>,
        vault_class_hash: ClassHash,
        duration_range: (u64, u64),
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

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        VaultCreatedEvent: VaultCreatedEvent,
        TokenAddedEvent: TokenAddedEvent,
        YieldSourceEvent: YieldSourceEvent,
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
    struct VaultCreatedEvent {
        address: ContractAddress
    }
    #[derive(Drop, starknet::Event)]
    struct TokenAddedEvent {
        address: ContractAddress
    }

    #[derive(Drop, starknet::Event)]
    struct YieldSourceEvent {
        address: ContractAddress
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        vault_class_hash: ClassHash,
        min_draw_duration: u64,
        max_draw_duration: u64
    ) {
        let caller = get_caller_address();
        self.ownable.initializer(caller);
        self.duration_range.write((min_draw_duration, max_draw_duration));
    }

    #[abi(embed_v0)]
    impl WinSavedImpl of IWinSaved<ContractState> {
        fn create_vault(
            ref self: ContractState,
            yield_token: ContractAddress,
            yield_source: ContractAddress,
            draw_duration: u64
        ) {
            self.ownable.assert_only_owner();
            self.validate_yield_token(yield_token);
            self.validate_yield_source(yield_source);
            let constructor_calldata: Array<felt252> = array![
                yield_token.into(), yield_source.into(), draw_duration.into()
            ];
            let salt: felt252 = get_block_timestamp().into();
            let (contract_address, _) = deploy_syscall(
                self.vault_class_hash.read(), salt, constructor_calldata.span(), false
            )
                .unwrap();
            self.vaults.append().write(contract_address);
            self.emit(VaultCreatedEvent { address: contract_address });
        }
        fn make_vault_draw(
            ref self: ContractState, vault: ContractAddress
        ) { // generate random number with prima lib
        }
        fn add_yield_token(ref self: ContractState, token: ContractAddress) {
            self.ownable.assert_only_owner();
            self.tokens.append().write(token);
            self.emit(TokenAddedEvent { address: token });
        }
        fn add_yield_source(
            ref self: ContractState, yield_source: ContractAddress, name: ByteArray
        ) {
            self.ownable.assert_only_owner();
            self.yield_sources.append().write(yield_source);
            self.emit(YieldSourceEvent { address: yield_source });
        }
        fn get_yield_tokens(self: @ContractState) -> Array<ContractAddress> {
            let mut tokens: Array<ContractAddress> = array![];
            for index in 0..self.tokens.len() {
                tokens.append(self.tokens.at(index).read());
            };
            tokens
        }
        fn get_yield_sources(self: @ContractState) -> Array<ContractAddress> {
            let mut sources: Array<ContractAddress> = array![];
            for index in 0
                ..self.yield_sources.len() {
                    sources.append(self.yield_sources.at(index).read());
                };
            sources
        }
        fn get_vaults(self: @ContractState) -> Array<ContractAddress> {
            let mut vaults: Array<ContractAddress> = array![];
            for index in 0..self.vaults.len() {
                vaults.append(self.vaults.at(index).read());
            };
            vaults
        }
        fn pause_vault(ref self: ContractState, vault: ContractAddress) {
            self.ownable.assert_only_owner();
            self.validate_vault(vault);
            let dispatcher = IVaultDispatcher { contract_address: vault };
            dispatcher.pause();
        }
        fn unpause_vault(ref self: ContractState, vault: ContractAddress) {
            self.ownable.assert_only_owner();
            self.validate_vault(vault);
            let dispatcher = IVaultDispatcher { contract_address: vault };
            dispatcher.unpause();
        }
        fn upgrade_vault(ref self: ContractState, vault: ContractAddress, class_hash: ClassHash) {
            self.ownable.assert_only_owner();
            self.validate_vault(vault);
            let dispatcher = IVaultDispatcher { contract_address: vault };
            dispatcher.upgrade(class_hash);
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn validate_yield_source(self: @ContractState, yield_source: ContractAddress) {
            let mut checker = false;
            for index in 0
                ..self
                    .yield_sources
                    .len() {
                        if yield_source == self.yield_sources.at(index).read() {
                            checker = true;
                        }
                    };

            assert!(checker, "Invalid yield source");
        }
        fn validate_yield_token(self: @ContractState, yield_token: ContractAddress) {
            let mut checker = false;
            for index in 0
                ..self
                    .tokens
                    .len() {
                        if yield_token == self.tokens.at(index).read() {
                            checker = true;
                        }
                    };

            assert!(checker, "Invalid yield token");
        }
        fn validate_vault(self: @ContractState, vault: ContractAddress) {
            let mut checker = false;
            for index in 0
                ..self
                    .vaults
                    .len() {
                        if vault == self.vaults.at(index).read() {
                            checker = true;
                        }
                    };

            assert!(checker, "Invalid vault address");
        }
        fn validate_draw_time(self: @ContractState, duration: u64) {
            let (min_duration, max_duration) = self.duration_range.read();
            if duration < min_duration || duration > max_duration {
                panic!("Duration out of bound");
            }
        }
    }
}
