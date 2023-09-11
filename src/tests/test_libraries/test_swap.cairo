mod SwapTests {
    use starknet::syscalls::deploy_syscall;

    use orion::numbers::signed_integer::{i32::i32, i64::i64, i128::i128};
    use orion::numbers::signed_integer::integer_trait::IntegerTrait;

    use yas::libraries::swap::{Swap, ISwap, ISwapDispatcher, ISwapDispatcherTrait};

    fn deploy() -> ISwapDispatcher {
        let calldata: Array<felt252> = ArrayTrait::new();
        let (address, _) = deploy_syscall(
            Swap::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), true
        )
            .expect('DEPLOY_FAILED');
        return (ISwapDispatcher { contract_address: address });
    }

    #[test]
    #[available_gas(30000000)]
    fn test_swap() {
        let swap = deploy();

        let tick_id = IntegerTrait::<i32>::new(2, false);
        swap.set_tick(tick_id);

        let result = swap.get_tick(tick_id);
        assert(result.fee_growth_outside_0X128 == 1, 'fee_growth_0X128 should be 1');
        assert(result.fee_growth_outside_1X128 == 2, 'fee_growth_1X128 should be 2');
        assert(result.liquidity_gross == 3, 'liquidity_gross should be 3');
        assert(
            result.liquidity_net == IntegerTrait::<i128>::new(4, false), 'liquidity_net should be 4'
        );
        assert(result.seconds_per_liquidity_outside_X128 == 5, 'sec_per_liqui_X128 should be 5');
        assert(
            result.tick_cumulative_outside == IntegerTrait::<i64>::new(6, false),
            'tick_cumulative should be 6'
        );
        assert(result.seconds_outside == 7, 'seconds_outside should be 7');
        assert(result.initialized == true, 'initialized should be true');
    }
}
