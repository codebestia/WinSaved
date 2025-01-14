import './index.css'
import Navbar from './components/Nav'
import Heropage from './components/Hero'
import Metrics from './components/Metrics'
import Content from './components/Content'
import Footer from './components/Footer'

function App() {
  return (
    <>
      <div className='bg-[#030B1E] h-screen'>
        <Navbar />
        <Heropage />
        <Metrics />
      </div>

      <div className='bg-[#030B1E]'>
        <Content />
      </div>
      <Footer />
    </>
  )
}

export default App
