# Cloudchain
Cloudchain is a research idea of designing a cloud federation based on the blockchain technology.  
The current version is developed on the Ethereum network using the Solidity language.
It has three smartcontracts:
1. *CCRegistry*: Cloudchain Registery is a global contract that maps cloud providers identification values *Name, Reputation Value, Computing Capacity* and *Storage Capacity* to their Ethereum address identities (equivalent to the public keys).
2. *CCProfile*: Cloudchain Profile holds a list of references to CCContract, representing all the participants' previous and current engagements with other nodes in the system.
3. *CCContract*: Cloudchain Contract is issued between two nodes in the system when one node accepts and provides the requested service for the other.

## Research Team
#### Lead Researcher:  
[Mona Taghavi](http://www.monataghavi.com) (Concordia University, Canada)  

#### Blockchain Developer:  
[Kaveh Bakhtiyari](http://www.bakhtiyari.com) (University of Duisburg-Essen, Germany and The National University of Malaysia)  

#### Research Supervisors:  
[Jamal Bentahar](https://users.encs.concordia.ca/~bentahar/) (Concordia University, Canada)  
[Hadi Otrok](https://users.encs.concordia.ca/~h_otrok/) (Khalifa University, UAE and Concordia University, Canada)

## Abstract
*Cloudchain* is a blockchain-based cloud federation which enables cloud service providers to trade their computing resources through smart contracts. Traditional cloud federations have strict challenges that might hinder the members' motivation to participate in, such as forming stable coalitions with long-term commitments, participants' trustworthiness, shared revenue, and security of the managed data and services. Cloudchain provides a fully distributed structure over the public Ethereum network to overcome these issues. Due to the inability of the blockchain network to access the outside world, we introduce an oracle as a verifier agent to monitor the quality of the service and report to the smart contract agents deployed on the blockchain. To obtain more information about the model and strategic decision making of its beneficieries through dynamic games, we refer you to read our publications. 
  
## Citation
If you are using any part of *Cloudchain*, please cite our papers.  

- M. Taghavi, J. Bentahar, H. Otrok, and K. Bakhtiyari, ***"A reinforcement learning model for the reliability of blockchain oracles,"*** in Expert Systems with Applications, (In Press)
DOI: https://doi.org/10.1016/j.eswa.2022.119160
[[Reproducable Code]](https://doi.org/10.24433/CO.3464870.v1)

- M. Taghavi, J. Bentahar, H. Otrok, and K. Bakhtiyari, ***"A Blockchain-based Model for Cloud Service Quality Monitoring,"*** in IEEE Transactions on Services Computing, vol. 13, no. 2, pp. 276-288, 1 March-April 2020.
DOI: https://doi.org/10.1109/TSC.2019.2948010  
[[ResearchGate]](https://www.researchgate.net/publication/336623007_A_Blockchain-based_Model_for_Cloud_Service_Quality_Monitoring) |
[[Full-Text]](http://wvvw.monataghavi.com/download/pub/2019-10-tsc-cloudchain.pdf)

- M. Taghavi, J. Bentahar, H. Otrok, and K. Bakhtiyari, ***"Cloudchain: A Blockchain-Based Coopetition Differential Game Model for Cloud Computing,"*** in 16th International Conference on Service Oriented Computing (ICSOC), Hangzhou, China, 2018, pp. 146-161: Springer International Publishing.
DOI: https://doi.org/10.1007/978-3-030-03596-9_10  
[[ResearchGate]](https://www.researchgate.net/publication/328517305_Cloudchain_A_Blockchain-based_Coopetition_Differential_Game_Model_for_Cloud_Computing)| [[Full-Text]](http://wvvw.monataghavi.com/download/pub/2018-11-icsoc-cloudchain.pdf) |
[[Powerpoint]](http://wvvw.monataghavi.com/download/presentations/2018-11-icsoc-cloudchain.pptx) |
[[Youtube]](https://www.youtube.com/watch?v=fomO5C_ze2g)

## More information
Published full-text: [Mona Taghavi](http://monataghavi.com) | [Kaveh Bakhtiyari](http://bakhtiyari.com)  
Youtube Video: https://www.youtube.com/watch?v=fomO5C_ze2g

## Youtube Video

[![Blockchain](http://img.youtube.com/vi/fomO5C_ze2g/0.jpg)](http://www.youtube.com/watch?v=fomO5C_ze2g)

## Version History
#### 0.1.6: 3 November 2018  
> Solidity (0.4.25)<br>
> Introducing the role of a trusted verifier into Cloudchain  

#### 0.1.5: 1 June 2018    
> Solidity (0.4.24)<br>
> Base Version  
