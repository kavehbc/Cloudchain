# Cloudchain
Cloudchain is a research idea of designing a cloud federation based on the blockchain technology.  
The current version is developed on the Ethereum network using the Solidity language (v. 0.4.24).
It has three smartcontracts:
1. *CCRegistry*: Cloudchain Registery is a global contract that maps cloud providers identification values *Name, Reputation Value, Computing Capacity* and *Storage Capacity* to their Ethereum address identities (equivalent to the public keys).
2. *CCProfile*: Cloudchain Profile holds a list of references to CCContract, representing all the participants' previous and current engagements with other nodes in the system.
3. *CCContract*: Cloudchain Contract is issued between two nodes in the system when one node accepts and provides the requested service for the other.

## Research Team
#### Lead Researcher:  
[Mona Taghavi](http://www.monataghavi.com) (Concordia University, Canada)  

#### Developer:  
[Kaveh Bakhtiyari](http://www.bakhtiyari.com) (University of Duisburg-Essen, Germany and The National University of Malaysia)  

#### Research Supervisors:  
[Jamal Bentahar](https://users.encs.concordia.ca/~bentahar/) (Concordia University, Canada)  
[Hadi Otrok](https://users.encs.concordia.ca/~h_otrok/) (Khalifa University, UAE and Concordia University, Canada)

## Abstract
In this paper, we introduce, design and develop *Cloudchain*, a blockchain-based cloud federation, to enable cloud service providers to trade their computing resources through smart contracts. Traditional cloud federations have strict challenges that might hinder the members' motivation to participate in, such as forming stable coalitions with long-term commitments, participants' trustworthiness, shared revenue, and security of the managed data and services. Cloudchain provides a fully distributed structure over the public Ethereum network to overcome these issues. Three types of contracts are defined where cloud providers can register themselves, create a profile and list of their transactions, and initiate a request for a service. We further design a dynamic differential game among the Cloudchain members, with roles of cloud service requesters and suppliers, to maximize their profit. Within this paradigm, providers engage in coopetitions (i.e., cooperative competitions) with each other while their service demand is dynamically changing based on two variables of gas price and reputation value. We implemented Cloudchain and simulated the differential game using Solidity and Web3.js for five cloud providers during 100 days. The results showed that cloud providers who request services achieve higher profitability through Cloudchain to those providers that supply these requests. Meanwhile, spending high gas price is not economically appealing for cloud requesters with a high number of requests, and fairly cheaper prices might cause some delays in their transactions during the network peak times. The best strategy for cloud suppliers was found to be gradually increasing their reputation, especially when the requesters' demand is not significantly impacted by the reputation value.
  
## Citation
If you are using any part of *Cloudchain*, please cite our paper.  

*Citation details will be announced soon.*

## More information
Published full-text: *it will be available soon*  
Powerpoint Presentation: *it will be available soon*
