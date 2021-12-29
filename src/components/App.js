import React, { Component } from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from "../abis/KryptoBird.json";
import {
  MDBCard,
  MDBCardBody,
  MDBCardTitle,
  MDBCardText,
  MDBCardImage,
  MDBBtn,
} from "mdb-react-ui-kit";

import "./App.css";

//class Component
class App extends Component {
  //constructor
  constructor(props) {
    super(props);
    this.state = {
      account: "",
      contract: "",
      totalSupply: 0,
      kryptoBirdz: [],
    };
  }

  //load web3

  //this function will execute automatically when page renders(refresh)
  async componentDidMount() {
    await this.loadWeb3();
    await this.loadBlockchainData();
  }

  //detect ethereum provider in browser
  async loadWeb3() {
    //get ethereum provider in browser
    const provider = await detectEthereumProvider();

    //modern browsers
    //if there is a provider then let's log that it's working
    //and access the window from dom to set Web3 to the provider
    if (provider) {
      console.log("ethereum wallet connected");

      //creating new instance of web3
      window.web3 = new Web3(provider);
    } else {
      //if there is no ethereum provider
      console.log("no ethereum wallet detected");
    }
  }

  async loadBlockchainData() {
    //refactoring window.web3 to web3 (optional)
    const web3 = window.web3;
    //get account connected on metamask
    const accounts = await web3.eth.getAccounts();

    //set the account property in state
    this.setState({
      account: accounts[0],
    });

    //get the network id to which metamask is connected
    const networkId = await web3.eth.net.getId();

    //check whether KryptoBird contract is deployed to
    //network with same network id to which metamask is connected
    //KryptoBird.networks = '5777' : {address:'', data:''}
    //networkId is a key inside 'networks' property
    //networkId key contains a value as object with property address, transaction hash and events
    // "networks": {
    //     "5777": {
    //         "events": {},
    //         "links": {},
    //         "address": "0x99161b9611B6F9d96c7e55736895AE1aa61AA102",
    //             "transactionHash": "0xdbf53eb4f35e33de22025d95e0bf41e1675052842a8f174fde4cb15b51f923a1"
    //     }
    const networkData = KryptoBird.networks[networkId];

    //check whether the network id is same
    if (networkData) {
      //KryptoBird.networks = '5777' : {address:'', data:''}
      //networkId is a key inside networks property
      //networkId contains a value as object with property ad
      // "networks": {
      //     "5777": {
      //         "events": {},
      //         "links": {},
      //         "address": "0x99161b9611B6F9d96c7e55736895AE1aa61AA102",
      //             "transactionHash": "0xdbf53eb4f35e33de22025d95e0bf41e1675052842a8f174fde4cb15b51f923a1"
      //     }

      //get abi of contract from abi property
      const abi = KryptoBird.abi;

      //get network address from networkId property
      const address = networkData.address;

      //creating a new instance contract
      const contract = await new web3.eth.Contract(abi, address);

      this.setState({ contract });
      // console.log(this.state.contract);

      //call the total supply of Krypto Birdz
      //grab the total supply on the front end and log the results
      const totalSupply = await contract.methods.totalSupply().call();
      this.setState({ totalSupply });
      console.log(this.state.totalSupply);

      //set up an array to keep track of tokens
      //load kryptoBirdz

      for (let i = 1; i <= totalSupply; i++) {
        let KryptoBird = await contract.methods.kryptoBirdz(i - 1).call();

        //how should we handle the state on the front end?
        //store the tokens minted so far
        this.setState({
          kryptoBirdz: [...this.state.kryptoBirdz, KryptoBird],
        });
      }

      //console.log(this.state.kryptoBirdz);
    }
    //if network id of metamask does not match to the network id
    //of the network to which contract is deployed
    else {
      window.alert("smart contract not deployed");
    }
  }

  //with minting we are sending information and we need to specify the account
  mint = (kryptoBird) => {
    this.state.contract.methods
      .mint(kryptoBird)
      .send({ from: this.state.account })
      .once("receipt", (receipt) => {
        this.setState({
          kryptoBirdz: [...this.state.kryptoBirdz, KryptoBird],
        });
      });
  };
  //render component
  //JSX
  render() {
    return (
      <div className="container-filled">
        {console.log(this.state.kryptoBirdz)}
        <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
          <div
            className="navbar-brand col-sm-3 col-md-3 mr-0"
            style={{ color: "white" }}
          >
            Krypto Birdz NFTs (Non Fungible Tokens)
          </div>
          <ul className="navbar-nav px-3">
            <li className="nav-item text-nowrap d-none d-sm-none d-sm-block">
              <small className="text-white">{this.state.account}</small>
            </li>
          </ul>
        </nav>
        <div className="container-fluid mt-1">
          <div className="row">
            <main role="main" className="col-lg-12 d-flex text-center">
              <div
                className="content mr-auto ml-auto"
                style={{ opacity: "0.8" }}
              >
                <h1 style={{ color: "black" }}>
                  KryptoBirdz - NFT Marketplace
                </h1>
                <form
                  onSubmit={(event) => {
                    event.preventDefault();
                    const kryptoBird = this.kryptoBird.value;
                    this.mint(kryptoBird);
                  }}
                >
                  <input
                    type="text"
                    placeholder="add file location"
                    className="mb-1"
                    ref={(input) => (this.kryptoBird = input)}
                  />
                  <input
                    style={{ margin: "6px" }}
                    type="submit"
                    value="MINT"
                    className="btn btn-primary btn-black"
                  />
                </form>
              </div>
            </main>
          </div>
          <hr></hr>
          <div className="row text-center">
            {this.state.kryptoBirdz.map((kryptoBird, key) => {
              return (
                <div>
                  <div>
                    <MDBCard
                      className="token img"
                      style={{ maxWidth: "22rem" }}
                    >
                      <MDBCardImage
                        src={kryptoBird}
                        position="top"
                        height="250rem"
                        style={{ marginRight: "4px" }}
                      />
                      <MDBCardBody>
                        <MDBCardTitle>KryptoBirdz</MDBCardTitle>
                        <MDBCardText>
                          The KryptoBirdz are 20 uniquely generated Kbridz from
                          cyberpunk cloud galaxy , There is only one of each
                          bird and each bird can be owned by single person on
                          ethereum blockchain{" "}
                        </MDBCardText>
                        <MDBBtn href={kryptoBird}>Download</MDBBtn>
                      </MDBCardBody>
                    </MDBCard>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    );
  }
}

export default App;
