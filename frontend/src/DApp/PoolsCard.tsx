import React from 'react'

interface PoolscardProps {
  prize: string
  view: string
  equivalent: string
  network: string
  networkIcon: string
}

const Poolscard: React.FC<PoolscardProps> = ({
  view,
  prize,
  equivalent,
  network,
  networkIcon,
}) => {
  return (
    <div className="bg-[#0e1e2d]/40 shadow-md rounded-3xl px-6 py-4 m-4 min-w-[350px] border border-gray-500 ">
      <div className="flex items-center mb-4 justify-between">
        <p>Grand Prize</p>
        <div className="flex items-center border border-gray-500 px-2 py-1 rounded-xl">
          <img
            src={networkIcon}
            alt={`${network} icon`}
            className="w-5 h-5 mr-2 my-2"
          />
          <h2 className="text-sm font-semibold">{network}</h2>
        </div>
      </div>
      <div className="bg-[#19394c] px-3 py-3 rounded-lg text-center">
        <p className="mb-2 text-[#a4b0b7]">
          <span className="font-bold text-3xl tracking-wide">{prize}</span>
        </p>
        <p className="mb-2 text-[#a4b0b7]">
          <span className="font-bold">{equivalent}</span>
        </p>
      </div>
      <p className="text-[#81868e] text-center mt-3">
        <span className="font text-sm">{view}</span>
      </p>
    </div>
  )
}

export default Poolscard
