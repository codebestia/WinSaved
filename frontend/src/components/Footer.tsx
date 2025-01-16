const Footer = () => {
  const footerSections = [
    {
      title: 'COMPANY',
      links: ['About Us', 'Partnerships', 'Games', 'Branding', 'FAQ'],
    },
    {
      title: 'SOCIAL',
      links: ['Facebook', 'Twitter', 'Instagram', 'TikTok', 'Our Discord'],
    },
    {
      title: 'SUPPORTED GAMES',
      links: [
        'League of Legends',
        'Counter-Strike 2',
        'Valorant',
        'TeamFight Tactics',
        'Apex Legends',
      ],
    },
  ]

  return (
    <footer className="bg-[#030817] py-12">
      <div className="container mx-auto px-6">
        <div className="flex flex-wrap">
          {/* Logo Section */}
          <div className="w-full md:w-1/4 mb-8 md:mb-0">
            <span className="text-[#02C0FF] text-xl font-semibold">LOGO</span>
          </div>

          {/* Links Sections */}
          {footerSections.map((section, index) => (
            <div key={index} className="w-full md:w-1/4 mb-8 md:mb-0">
              <h3 className="text-white text-sm font-medium mb-4">
                {section.title}
              </h3>
              <ul className="space-y-2">
                {section.links.map((link, linkIndex) => (
                  <li key={linkIndex}>
                    <a
                      href="#"
                      className="text-gray-400 hover:text-white text-sm transition-colors duration-200"
                    >
                      {link}
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>
      </div>
    </footer>
  )
}

export default Footer
