const Metrics = () => {
  return (
    <div className="flex justify-around py-10 px-40 text-white text-2xl bg-[#010a1d]">
      <div className="flex flex-col text-center">
        <p className="text-3xl">$5.1 Million</p>
        <p className="text-sm text-white/60">Total Prizes Awarded</p>
      </div>
      <div className="flex flex-col text-center">
        <p className="text-3xl">$21 Million</p>
        <p className="text-sm text-white/60">Locked with WinSaved</p>
      </div>
      <div className="flex flex-col text-center">
        <p className="text-3xl">86,000+</p>
        <p className="text-sm text-white/60">Unique Wallets</p>
      </div>
      <div className="flex flex-col text-center">
        <p className="text-3xl">0</p>
        <p className="text-sm text-white/60">Losses</p>
      </div>
    </div>
  )
}

export default Metrics
