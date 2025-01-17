const Navbar = () => {
    return (
        <div className="flex justify-between items-center py-10 px-28">
            <div>
                <p className="font-bold text-lg">LOGO</p>
            </div>

            <div className="flex space-x-[5rem] text-sm">
                <p>Prizes</p>
                <p>Vault</p>
                <p>Account</p>
            </div>

            <div>
                <button className="bg-[#2594E4] py-2 px-3 rounded-lg text-sm">
                    Connect Wallet
                </button>
            </div>
        </div>
    );
};

export default Navbar;