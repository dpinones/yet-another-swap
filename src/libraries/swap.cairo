use orion::numbers::signed_integer::{i32::i32, integer_trait::IntegerTrait};
use yas::libraries::tick::Info;

#[starknet::interface]
trait ISwap<TStorage> {
    fn set_tick(ref self: TStorage, tick: i32);
    fn get_tick(self: @TStorage, tick: i32) -> Info;
}

#[starknet::contract]
mod Swap {
    use super::{ISwap};

    use orion::numbers::signed_integer::{i32::i32, i64::i64, i128::i128};
    use orion::numbers::signed_integer::integer_trait::IntegerTrait;

    use yas::libraries::tick::{Info, Tick};

    #[storage]
    struct Storage {}

    #[external(v0)]
    impl Swap of ISwap<ContractState> {
        fn set_tick(ref self: ContractState, tick: i32) {
            //TODO: temporary component syntax
            let mut state = Tick::unsafe_new_contract_state();
            Tick::TickImpl::set_tick(
                ref state,
                tick,
                Info {
                    fee_growth_outside_0X128: 1,
                    fee_growth_outside_1X128: 2,
                    liquidity_gross: 3,
                    liquidity_net: IntegerTrait::<i128>::new(4, false),
                    seconds_per_liquidity_outside_X128: 5,
                    tick_cumulative_outside: IntegerTrait::<i64>::new(6, false),
                    seconds_outside: 7,
                    initialized: true
                }
            );
        }

        fn get_tick(self: @ContractState, tick: i32) -> Info {
            //TODO: temporary component syntax
            let state = Tick::unsafe_new_contract_state();
            Tick::TickImpl::get_tick(@state, tick)
        }
    }
}
