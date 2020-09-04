export COMPOSE_PROJECT_NAME=net

tls

docker-compose up -d ca-tls

cp /tmp/hyperledger/tls/ca/crypto/ca-cert.pem /tmp/hyperledger/tls/ca/crypto/tls-ca-cert.pem 

export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/tls/ca/crypto/tls-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/tls/ca/admin
./bin/fabric-ca-client enroll -d -u https://tls-ca-admin:tls-ca-adminpw@0.0.0.0:7052
./bin/fabric-ca-client register -d --id.name peer1-org1 --id.secret peer1PW --id.type peer -u https://0.0.0.0:7052
./bin/fabric-ca-client register -d --id.name peer2-org1 --id.secret peer2PW --id.type peer -u https://0.0.0.0:7052
./bin/fabric-ca-client register -d --id.name peer1-org2 --id.secret peer1PW --id.type peer -u https://0.0.0.0:7052
./bin/fabric-ca-client register -d --id.name peer2-org2 --id.secret peer2PW --id.type peer -u https://0.0.0.0:7052
./bin/fabric-ca-client register -d --id.name orderer1-org0 --id.secret ordererPW --id.type orderer -u https://0.0.0.0:7052




docker-compose up -d rca-org0

export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/ca/admin
./bin/fabric-ca-client enroll -d -u https://rca-org0-admin:rca-org0-adminpw@0.0.0.0:7053
./bin/fabric-ca-client register -d --id.name orderer1-org0 --id.secret ordererpw --id.type orderer -u https://0.0.0.0:7053
./bin/fabric-ca-client register -d --id.name admin-org0 --id.secret org0adminpw --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7053

enroll orderer
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/orderer
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/ca/crypto/ca-cert.pem
./bin/fabric-ca-client enroll -d -u https://orderer1-org0:ordererpw@0.0.0.0:7053

export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/tls/ca/crypto/tls-ca-cert.pem 
./bin/fabric-ca-client enroll -d -u https://orderer1-org0:ordererPW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer1-org0

enroll admin
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
./bin/fabric-ca-client enroll -d -u https://admin-org0:org0adminpw@0.0.0.0:7053

mkdir /tmp/hyperledger/org0/orderer/msp/admincerts
cp /tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /tmp/hyperledger/org0/orderer/msp/admincerts/orderer-admin-cert.pem




docker-compose up -d rca-org1

export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org1/ca/admin
./bin/fabric-ca-client enroll -d -u https://rca-org1-admin:rca-org1-adminpw@0.0.0.0:7054
./bin/fabric-ca-client register -d --id.name peer1-org1 --id.secret peer1PW --id.type peer -u https://0.0.0.0:7054
./bin/fabric-ca-client register -d --id.name peer2-org1 --id.secret peer2PW --id.type peer -u https://0.0.0.0:7054
./bin/fabric-ca-client register -d --id.name admin-org1 --id.secret org1AdminPW --id.type admin -u https://0.0.0.0:7054
./bin/fabric-ca-client register -d --id.name user-org1 --id.secret org1UserPW --id.type client -u https://0.0.0.0:7054

enroll peer1
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org1/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
./bin/fabric-ca-client enroll -d -u https://peer1-org1:peer1PW@0.0.0.0:7054

export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/tls/ca/crypto/tls-ca-cert.pem 
./bin/fabric-ca-client enroll -d -u https://peer1-org1:peer1PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer1-org1


enroll peer2
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org1/peer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
./bin/fabric-ca-client enroll -d -u https://peer2-org1:peer2PW@0.0.0.0:7054

export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/tls/ca/crypto/tls-ca-cert.pem 
./bin/fabric-ca-client enroll -d -u https://peer2-org1:peer2PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer2-org1


enroll admin
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org1/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
./bin/fabric-ca-client enroll -d -u https://admin-org1:org1AdminPW@0.0.0.0:7054


mkdir /tmp/hyperledger/org1/peer1/msp/admincerts
mkdir /tmp/hyperledger/org1/peer2/msp/admincerts
cp /tmp/hyperledger/org1/admin/msp/signcerts/cert.pem /tmp/hyperledger/org1/peer1/msp/admincerts/org1-admin-cert.pem
cp /tmp/hyperledger/org1/admin/msp/signcerts/cert.pem /tmp/hyperledger/org1/peer2/msp/admincerts/org1-admin-cert.pem







docker-compose up -d rca-org2

export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org2/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org2/ca/admin
./bin/fabric-ca-client enroll -d -u https://rca-org2-admin:rca-org2-adminpw@0.0.0.0:7055
./bin/fabric-ca-client register -d --id.name peer1-org2 --id.secret peer1PW --id.type peer -u https://0.0.0.0:7055
./bin/fabric-ca-client register -d --id.name peer2-org2 --id.secret peer2PW --id.type peer -u https://0.0.0.0:7055
./bin/fabric-ca-client register -d --id.name admin-org2 --id.secret org2AdminPW --id.type admin -u https://0.0.0.0:7055
./bin/fabric-ca-client register -d --id.name user-org2 --id.secret org2UserPW --id.type client -u https://0.0.0.0:7055

enroll peer1
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org2/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org2/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
./bin/fabric-ca-client enroll -d -u https://peer1-org2:peer1PW@0.0.0.0:7055

export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/tls/ca/crypto/tls-ca-cert.pem 
./bin/fabric-ca-client enroll -d -u https://peer1-org2:peer1PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer1-org2


enroll peer2
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org2/peer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org2/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
./bin/fabric-ca-client enroll -d -u https://peer2-org2:peer2PW@0.0.0.0:7055


export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/tls/ca/crypto/tls-ca-cert.pem 
./bin/fabric-ca-client enroll -d -u https://peer2-org2:peer2PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer2-org2


enroll admin
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org2/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org2/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
./bin/fabric-ca-client enroll -d -u https://admin-org2:org2AdminPW@0.0.0.0:7055

mkdir /tmp/hyperledger/org2/peer1/msp/admincerts
mkdir /tmp/hyperledger/org2/peer2/msp/admincerts
cp /tmp/hyperledger/org2/admin/msp/signcerts/cert.pem /tmp/hyperledger/org2/peer1/msp/admincerts/org2-admin-cert.pem
cp /tmp/hyperledger/org2/admin/msp/signcerts/cert.pem /tmp/hyperledger/org2/peer2/msp/admincerts/org2-admin-cert.pem





组织各组织msp

mkdir /tmp/hyperledger/org0/msp
mkdir /tmp/hyperledger/org1/msp
mkdir /tmp/hyperledger/org2/msp

mkdir /tmp/hyperledger/org0/msp/admincerts
mkdir /tmp/hyperledger/org1/msp/admincerts
mkdir /tmp/hyperledger/org2/msp/admincerts

mkdir /tmp/hyperledger/org0/msp/cacerts
mkdir /tmp/hyperledger/org1/msp/cacerts
mkdir /tmp/hyperledger/org2/msp/cacerts

mkdir /tmp/hyperledger/org0/msp/tlscacerts
mkdir /tmp/hyperledger/org1/msp/tlscacerts
mkdir /tmp/hyperledger/org2/msp/tlscacerts


mkdir /tmp/hyperledger/org0/msp/users
mkdir /tmp/hyperledger/org1/msp/users
mkdir /tmp/hyperledger/org2/msp/users

cp /tmp/hyperledger/tls/ca/crypto/tls-ca-cert.pem /tmp/hyperledger/org0/msp/tlscacerts/tls-ca-cert.pem
cp /tmp/hyperledger/org0/ca/crypto/ca-cert.pem /tmp/hyperledger/org0/msp/cacerts/ca-cert.pem
cp /tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /tmp/hyperledger/org0/msp/admincerts/cert.pem


cp /tmp/hyperledger/tls/ca/crypto/tls-ca-cert.pem /tmp/hyperledger/org1/msp/tlscacerts/tls-ca-cert.pem
cp /tmp/hyperledger/org1/ca/crypto/ca-cert.pem /tmp/hyperledger/org1/msp/cacerts/ca-cert.pem
cp /tmp/hyperledger/org1/admin/msp/signcerts/cert.pem /tmp/hyperledger/org1/msp/admincerts/cert.pem



cp /tmp/hyperledger/tls/ca/crypto/tls-ca-cert.pem /tmp/hyperledger/org2/msp/tlscacerts/tls-ca-cert.pem
cp /tmp/hyperledger/org2/ca/crypto/ca-cert.pem /tmp/hyperledger/org2/msp/cacerts/ca-cert.pem
cp /tmp/hyperledger/org2/admin/msp/signcerts/cert.pem /tmp/hyperledger/org2/msp/admincerts/cert.pem



./bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock /tmp/hyperledger/channel-artifacts/genesis.block -channelID ordererchannel
./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx /tmp/hyperledger/channel-artifacts/channel.tx -channelID mychannel

export CHANNEL_NAME=mychannel
./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx /tmp/hyperledger/channel-artifacts/${CHANNEL_NAME}.tx -channelID ${CHANNEL_NAME}

export orgmsp=org1MSP
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate /tmp/hyperledger/channel-artifacts/${orgmsp}anchors.tx -channelID ${CHANNEL_NAME} -asOrg ${orgmsp}

export orgmsp=org2MSP
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate /tmp/hyperledger/channel-artifacts/${orgmsp}anchors.tx -channelID ${CHANNEL_NAME} -asOrg ${orgmsp}


docker-compose up -d peer1-org1
docker-compose up -d peer2-org1


docker-compose up -d peer1-org2
docker-compose up -d peer2-org2





docker-compose up -d orderer1-org0
docker-compose up -d cli-org1
docker-compose up -d cli-org2



创建&加入通道
docker exec -it cli-org1 bash

export CHANNEL_NAME=mychannel
export ORDERER_CA=/tmp/hyperledger/org0/orderer/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org1/admin/msp


peer channel create -o orderer1-org0:7050 -c ${CHANNEL_NAME} --ordererTLSHostnameOverride orderer1-org0 -f /tmp/hyperledger/channel-artifacts/${CHANNEL_NAME}.tx --outputBlock /tmp/hyperledger/channel-artifacts/${CHANNEL_NAME}.block --tls --cafile ${ORDERER_CA}
#peer channel create -t 50s -o orderer1-org0:7050 -c ${CHANNEL_NAME} -f /tmp/hyperledger/channel-artifacts/mychannel.tx  --outputBlock /tmp/hyperledger/channel-artifacts/${CHANNEL_NAME}.block  --tls --cafile ${ORDERER_CA}

export CORE_PEER_ADDRESS=peer1-org1:7051
peer channel join -b /tmp/hyperledger/channel-artifacts/mychannel.block

export CORE_PEER_ADDRESS=peer2-org1:8051
peer channel join -b /tmp/hyperledger/channel-artifacts/mychannel.block

export CORE_PEER_LOCALMSPID=org1MSP
peer channel update -o orderer1-org0:7050 --ordererTLSHostnameOverride orderer1-org0 -c $CHANNEL_NAME -f /tmp/hyperledger/channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls --cafile $ORDERER_CA




docker exec -it cli-org2 bash

export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org2/admin/msp


export CORE_PEER_ADDRESS=peer1-org2:9051
peer channel join -b /tmp/hyperledger/channel-artifacts/mychannel.block

export CORE_PEER_ADDRESS=peer2-org2:10051
peer channel join -b /tmp/hyperledger/channel-artifacts/mychannel.block

export CHANNEL_NAME=mychannel
export ORDERER_CA=/tmp/hyperledger/org0/orderer/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_LOCALMSPID=org2MSP

peer channel update -o orderer1-org0:7050 --ordererTLSHostnameOverride orderer1-org0 -c $CHANNEL_NAME -f /tmp/hyperledger/channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls --cafile $ORDERER_CA






docker exec -it cli-org1 bash


打包链码
export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org1/admin/msp
peer lifecycle chaincode package fabcar.tar.gz --path /opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/fabcar/ --lang golang --label fabcar_1

org1安装链码
peer lifecycle chaincode install fabcar.tar.gz

审批链码
export CHANNEL_NAME=mychannel
export ORDERER_CA=/tmp/hyperledger/org0/orderer/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem

export CORE_PEER_LOCALMSPID=org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/tmp/hyperledger/org1/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org1/admin/msp 
export CORE_PEER_ADDRESS=peer1-org1:7051
peer lifecycle chaincode approveformyorg -o orderer1-org0:7050 --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name fabcar --version 1 --init-required --sequence 1 --waitForEvent --package-id fabcar_1:206a5ce87aefb8b9780b75451523c2aa3ef718ceebaaeae5082ae88ea259b305



docker exec -it cli-org2 bash

org2安装链码
export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org2/admin/msp
peer lifecycle chaincode package fabcar.tar.gz --path /opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/fabcar/ --lang golang --label fabcar_1
peer lifecycle chaincode install fabcar.tar.gz

审批链码
export CHANNEL_NAME=mychannel
export ORDERER_CA=/tmp/hyperledger/org0/orderer/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
peer lifecycle chaincode approveformyorg  -o orderer1-org0:7050 --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name fabcar --version 1 --init-required --sequence 1 --waitForEvent --package-id fabcar_1:206a5ce87aefb8b9780b75451523c2aa3ef718ceebaaeae5082ae88ea259b305

向通道提交链码，只需要在一个节点上进行
peer lifecycle chaincode commit -o orderer1-org0:7050 --tls --cafile $ORDERER_CA --peerAddresses peer1-org1:7051 --tlsRootCertFiles /tmp/hyperledger/org1/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem --peerAddresses peer1-org2:9051 --tlsRootCertFiles /tmp/hyperledger/org2/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem --channelID $CHANNEL_NAME --name fabcar --version 1 --sequence 1 --init-required


#向通道提交链码，只需要在一个节点上进行
#peer lifecycle chaincode commit -o orderer1-org0:7050 --tls --cafile $ORDERER_CA --peerAddresses peer1-org1:7051 --tlsRootCertFiles /tmp/hyperledger/org1/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem --peerAddresses peer1-org2:9051 --tlsRootCertFiles /tmp/hyperledger/org2/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem --channelID $CHANNEL_NAME --name fabcar --version 1 --sequence 1 --init-required

初始化链码
peer chaincode invoke -o orderer1-org0:7050 --tls --cafile $ORDERER_CA --peerAddresses peer1-org1:7051 --tlsRootCertFiles /tmp/hyperledger/org1/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem --peerAddresses peer1-org2:9051 --tlsRootCertFiles /tmp/hyperledger/org2/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem -C $CHANNEL_NAME -n fabcar --isInit -c '{"Args":["InitLedger"]}'


peer chaincode query -C $CHANNEL_NAME -n fabcar -c '{"Args":["QueryAllCars"]}'