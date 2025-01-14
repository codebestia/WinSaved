const Content = () => {
    return (
        <div className="py-20 bg-custom-radial group">
            <div>
                <h1 className="text-4xl text-center font-semibold pb-8">WinSave is for Saving & Winning</h1>
                {/* Parent container */}
                <div className="flex justify-center my-20 space-x-[-5%] group-hover:space-x-8 transition-all duration-300">
                    {/* Card 1 */}
                    <div className="bg-[#232429]/40 text-white w-fit px-8 py-20 border border-[#FAFAFA52] rounded-2xl transform rotate-[-20deg] group-hover:rotate-0 z-10 transition-transform duration-300">
                        <p className="font-bold text-2xl">Deposit</p>
                        <p>Deposit for a chance to win big</p>
                        <img src="../../public/Images/mail.png" alt="" />
                    </div>

                    {/* Card 2 */}
                    <div className="bg-[#0F1725] text-white w-fit px-12 py-20 border border-[#FAFAFA52] rounded-2xl z-50 transform group-hover:rotate-0 transition-transform duration-300">
                        <p className="font-bold text-2xl">Win Prizes</p>
                        <p>Deposit for a chance to win big</p>
                        <img src="../../public/Images/percentage.png" alt="" />
                    </div>

                    {/* Card 3 */}
                    <div className="bg-[#232429]/40 text-white w-fit px-8 py-20 border border-[#FAFAFA52] rounded-2xl transform rotate-[20deg] group-hover:rotate-0 z-10 transition-transform duration-300">
                        <p className="font-bold text-2xl">No Loss</p>
                        <p>Deposit for a chance to win big</p>
                        <img src="../../public/Images/safe.png" alt="" />
                    </div>
                </div>
            </div>
        </div>

    );
}

export default Content;