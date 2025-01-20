import Pools from './Pools'

const HeroPage = () => {
  return (
    <div>
      <div className="text-center pt-20 flex justify-center pb-8">
        <h1 className="text-[45px] w-[25%] leading-tight">
          <span className="opacity-60">Save your deposit. Win up to</span>{' '}
          <em>$362,497</em>
        </h1>
      </div>

      <button className="bg-[#2594E4] py-2 px-3 rounded-lg text-sm mx-auto block">
        Connect Wallet
      </button>

      <Pools />
    </div>
  )
}

export default HeroPage
