<<<<<<< HEAD
import { Link } from 'react-router-dom'

=======
>>>>>>> dev
const Navbar = () => {
  return (
    <div className="flex justify-between items-center py-10 px-28">
      <div>
        <p className="font-bold text-lg">LOGO</p>
      </div>

      <div className="flex space-x-5">
        <p>Home</p>
        <p>Winners</p>
        <p>Docs</p>
      </div>

      <div>
<<<<<<< HEAD
        <Link to="/DApp">
          <button className="bg-[#2594E4] py-2 px-3 rounded-lg">
            Launch DApp
          </button>
        </Link>
=======
        <button className="bg-[#2594E4] py-2 px-3 rounded-lg">
          Launch DApp
        </button>
>>>>>>> dev
      </div>
    </div>
  )
}

export default Navbar
