import Navbar from "./Navbar";
import HeroPage from "./HeroPage";
import Footer from "../components/Footer";

const DApp = () => {
  return (
    <div className="bg-[#030B1E] bg-hero-semi-circle">
      <Navbar />
      <HeroPage />
      <Footer/>
    </div>
  );
};

export default DApp;