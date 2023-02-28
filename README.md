<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->

<a name="readme-top"></a>

<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![Discord][discord-shield]][discord-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/ella-codes-dao/ella.wallet">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">ella.wallet</h3>

  <p align="center">
    A wallet built on the Flow Blockchain focused on everyday usage of crypto, DAO Membership, and bankless individuals
    <br />
    <a href="https://github.com/ella-codes-dao/ella.wallet"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/ella-codes-dao/ella.wallet">View Demo</a>
    ·
    <a href="https://github.com/ella-codes-dao/ella.wallet/issues">Report Bug</a>
    ·
    <a href="https://github.com/ella-codes-dao/ella.wallet/issues">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## About The Project

<!-- [![Product Name Screen Shot][product-screenshot]](https://example.com)

<p align="right">(<a href="#readme-top">back to top</a>)</p> -->

### Built With

- [![React][react.js]][react-url]
- [![Vue][vue.js]][vue-url]
- [![Angular][angular.io]][angular-url]
- [![Svelte][svelte.dev]][svelte-url]
- [![Laravel][laravel.com]][laravel-url]
- [![Bootstrap][bootstrap.com]][bootstrap-url]
- [![JQuery][jquery.com]][jquery-url]

Ella.wallet is a self-custodial blockchain wallet that has been specifically designed to support cross-chain transactions and multi-device support, making it incredibly convenient and user-friendly. This wallet is built on the Flow Blockchain, which is known for its scalability, low transaction fees, and its ability to handle high volumes of transactions, making it an excellent choice for anyone who wants to use cryptocurrency for everyday transactions.

One of the main features of Ella.wallet is its support for cross-chain transactions. This means that users can easily transfer cryptocurrencies between different blockchains, making it incredibly convenient for anyone who wants to use multiple cryptocurrencies for their day-to-day transactions. Additionally, Ella.wallet also supports multi-device support, allowing users to access their wallets from different devices and platforms, making it incredibly easy to manage their cryptocurrencies.

Ella.wallet is also designed with the needs of DAO (decentralized autonomous organization) membership in mind. This means that it offers features that are specifically tailored to the needs of DAO members, such as the ability to easily vote on proposals, participate in governance decisions, and manage their DAO tokens.

For bankless individuals, Ella.wallet offers an excellent solution for accessing and managing their cryptocurrencies without the need for traditional banking services. This can be particularly beneficial for people who live in areas with limited access to banking services or for those who prefer to keep their financial transactions private and secure.

Overall, Ella.wallet is an excellent choice for anyone who wants to use cryptocurrency for everyday transactions, participate in DAO governance, and manage their cryptocurrency holdings securely and conveniently.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.

- npm
  ```sh
  npm install npm@latest -g
  ```

### Installation

1. Get a free API Key at [https://example.com](https://example.com)
2. Clone the repo
   ```sh
   git clone https://github.com/ella-codes-dao/ella.wallet.git
   ```
3. Install NPM packages
   ```sh
   npm install
   ```
4. Enter your API in `config.js`
   ```js
   const API_KEY = "ENTER YOUR API";
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->

## Usage

At Ella.wallet, we believe that security should be simple and easy to understand. That's why we've designed our wallet with a focus on everyday usage while still ensuring that your assets are always secure.

Our wallet uses a multi-key system, with both device and account keys assigned a weight of 500. This means that if you need to remove a device from your wallet, you can easily do so without compromising the security of your assets. Additionally, access to your wallet requires both the device and account keys, adding an extra layer of protection to keep your assets secure.

To further enhance security, we also offer the option of adding an account key to your wallet. This eliminates the need for a recovery key to be stored on any devices, which helps boost the overall security of your assets.

In the event that you lose a device or your account key is compromised, our recovery process is simple and straightforward. You'll need both the original recovery key and a password to regain access to your assets, ensuring that they are always safe and secure.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->

## Roadmap

- [x] Wallet creation using recovery key and account/devices keys
- [ ] Account recovery using recovery key
- [ ] Wallet Connect integration (FCL Auth/Sign Transactions)
- [ ] Ability to remove account/device keys from wallet allowing for multi device control access control
- [ ] USDC "Bridge" Accounts (Integration with the Circle APIs to allow for cross bridge sending and receiving of USDC)
- [ ] NFT Catalog Integration
- [ ] Multiple Wallet Support (allow each device/app to support multiple wallets simultaneously)
- [ ] ella.card (US/EU card program linked to USDC Bridge account)

See the [open issues](https://github.com/ella-codes-dao/ella.wallet/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->

## Contributing

At Ella.Wallet, we are committed to building a strong community of users and developers who are passionate about cryptocurrency and the potential of blockchain technology. We believe that collaboration is essential to building innovative solutions that meet the needs of our users, which is why we welcome contributions from our community members.

If you are interested in contributing to the development of Ella.Wallet, we encourage you to join our dedicated Discord channel for community members and developers. This channel is a space for sharing ideas, collaborating on projects, and discussing the latest developments in the world of cryptocurrency.

As a community-driven project, we value the input and feedback of our users. Whether you have a suggestion for a new feature, a bug to report, or simply want to share your thoughts on how we can improve the user experience, we want to hear from you. Our Discord channel is a great place to connect with other community members and share your ideas with the Ella.wallet development team.

We are dedicated to creating a welcoming and inclusive community that fosters collaboration and creativity. Whether you are an experienced developer or simply passionate about cryptocurrency, we welcome your contributions and look forward to working together to build the future of blockchain technology.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->

## Contact

- Brian Pistone - Lead Developer - brian@ella.holdings
- Ashton Mercer - Development - ashton@ella.holdings
- Andrew Van Dyke - Development - andrew@ella.holdings
- Eric Merritt - Development - eric@ella.holdings

Project Link: [https://github.com/ella-codes-dao/ella.wallet](https://github.com/ella-codes-dao/ella.wallet)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->

## Acknowledgments

- []()
- []()
- []()

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/ella-codes-dao/ella.wallet.svg?style=for-the-badge
[contributors-url]: https://github.com/ella-codes-dao/ella.wallet/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/ella-codes-dao/ella.wallet.svg?style=for-the-badge
[forks-url]: https://github.com/ella-codes-dao/ella.wallet/network/members
[stars-shield]: https://img.shields.io/github/stars/ella-codes-dao/ella.wallet.svg?style=for-the-badge
[stars-url]: https://github.com/ella-codes-dao/ella.wallet/stargazers
[issues-shield]: https://img.shields.io/github/issues/ella-codes-dao/ella.wallet.svg?style=for-the-badge
[issues-url]: https://github.com/ella-codes-dao/ella.wallet/issues
[license-shield]: https://img.shields.io/badge/License-ELv2-blue.svg?style=for-the-badge
[license-url]: https://github.com/ella-codes-dao/ella.wallet/blob/master/LICENSE.txt
[discord-shield]: https://img.shields.io/discord/123456789?style=for-the-badge
[discord-url]: https://linkedin.com/in/linkedin_username
[product-screenshot]: images/screenshot.png
[react.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[react-url]: https://reactjs.org/
[vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[vue-url]: https://vuejs.org/
[angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[angular-url]: https://angular.io/
[svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[svelte-url]: https://svelte.dev/
[laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[laravel-url]: https://laravel.com
[bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[bootstrap-url]: https://getbootstrap.com
[jquery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[jquery-url]: https://jquery.com
