import Poolscard from './PoolsCard';

const Pools = () => {
    return (
        <div className="flex justify-center items-center my-14">
            <div className="grid grid-cols-3 gap-6 w-full max-w-6xl">
                <Poolscard prize="$200,000" equivalent="200 ETH" view="Click to view" network="Ethereum" networkIcon="../../public/Images/eth.png" />
                <Poolscard prize="$100,000" equivalent="100 ETH" view="Click to view" network="Ethereum" networkIcon="../../public/Images/eth.png" />
                <Poolscard prize="$200,000" equivalent="200 ETH" view="Click to view" network="Base" networkIcon="../../public/Images/base.png" />
                <Poolscard prize="$200,000" equivalent="200 ETH" view="Click to view" network="Ethereum" networkIcon="../../public/Images/usdc.png" />
                <Poolscard prize="$200,000" equivalent="200 ETH" view="Click to view" network="Arbitrum" networkIcon="../../public/Images/arb.png" />
                <Poolscard prize="$200,000" equivalent="200 ETH" view="Click to view" network="Ethereum" networkIcon="../../public/Images/usdc.png" />
            </div>
        </div>


    );
};

export default Pools;