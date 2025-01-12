## WINSAVED

WinSaved is a no loss price saving protocol where users deposit funds into a prize pool and instead of earning interest, they stand a chance to win prizes through regular price draws. The protocol gives users a chance at a large upside without risking their deposit. Each day, the yield from deposits is awarded randomly as prizes. Users have a chance to win everyone else's yield.

## How yield is generated

The protocol uses a concept called tokenized vaults (ERC4626). This contract is an advanced implementation of ERC20. ERC4626 standardizes how yield-bearing vaults work in DeFi. A vault is essentially a smart contract that accepts deposits of an underlying token (like USDC), invests them according to some strategy into Defi using the DeFi using the DeFi contract interface, and issues shares to depositors representing their ownership of the vault. For example, when a user deposits into the vault, the funds are sent to the Aave protocol with the vault address as the owner then as the value of the fund appreciates and interest is accrued, the value of the user shares appreciates as well giving the user a better chance of winning the prize. All the yield generated from the vault is liquidated into the protocol native token after a period of time and sent as reward to a lucky user.


## LIfeCycle of the protocol

The protocol will have predefined vaults for several supported tokens and it will have its own native token which will be used as the prize. Unlike PoolTogether, only the protocol can create vaults and these vaults will be predefined vaults with predefined tokens and DeFI protocols for the investment plan. The DeFI protocol will include lending and borrowing protocols, DEX protocols for liquidity provision, token farms e.t.c.
After a predefined period of time, the yield gotten from investing in the protocol is liquidated by the vaults and sent to the price pool contract.

- User LifeCycle
- User deposit funds to a vault in their preferred token that the protocol has to offer
- User get rewards if lucky
- User can withdraw funds anytime
- User has to claim reward if given
