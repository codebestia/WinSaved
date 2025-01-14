const Heropage = () => {
    return (
        <div className="my-20 relative py-24">

            <div className="flex justify-center items-center">
                <h1 className="text-[90px] font-semibold w-[45%] text-center leading-[80px]">The #1 Protocol for Real Adoption</h1>
            </div>
            <p className="text-center pt-4 text-white/80">The permissionless protocol 86,000 people are using to win by saving</p>

            <div className="flex justify-center items-center mt-10">
                <button className="bg-[#2594E4] py-2 px-3 rounded-lg">Launch DApp</button>
            </div>
            <img src="/Images/gemstoneblue.png" alt="Gem Stone" className='absolute right-[25%] top-[2%]' />
            <img src="/Images/starknet.png" alt="Starknet" className="absolute right-[18%] top-[30%] animate-slow-bounce" width={70} />
            <img src="/Images/starknet.png" alt="Starknet" className="absolute top-[30%] left-[10%] animate-slow-bounce" width={120} />
            <img src="/Images/goldcoin.png" alt="Gold coin" className='absolute right-[25%] bottom-[10%]' />
            <img src="/Images/diamondblue.png" alt="Diamond Blue" className='absolute left-[15%] bottom-0' />
        </div>
    );
}

export default Heropage;